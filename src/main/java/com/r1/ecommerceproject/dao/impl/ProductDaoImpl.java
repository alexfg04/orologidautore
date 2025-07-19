package com.r1.ecommerceproject.dao.impl;

import com.r1.ecommerceproject.dao.ProductDao;
import com.r1.ecommerceproject.utils.DataSourceConnectionPool;
import com.r1.ecommerceproject.model.ProductBean;
import com.r1.ecommerceproject.model.ProductBean.Stato;
import com.r1.ecommerceproject.utils.ProductFilter;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

public class ProductDaoImpl implements ProductDao {

    private static final String TABLE_NAME = "Prodotto";
    private static final String TABLE_NAME2= "Preferiti";

    private static final List<String> ALLOWED_ORDER_COLUMNS = Arrays.asList(
            "codice_prodotto", "nome", "prezzo", "categoria", "marca"
            // Aggiungere altre colonne consentite per l'ordinamento
    );


    @Override
    public synchronized ProductBean doRetrieveById(Long id) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE codice_prodotto = ?";
        ProductBean bean = null;

        try (Connection connection = DataSourceConnectionPool.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {

            preparedStatement.setLong(1, id);
            try (ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next()) {
                    bean = getProductBean(rs);
                }
            }
        }
        return bean;
    }

    private ProductBean getProductBean(ResultSet rs) throws SQLException {
        ProductBean bean;
        bean = new ProductBean();
        bean.setCodiceProdotto(rs.getInt("codice_prodotto"));
        bean.setMateriale(rs.getString("materiale"));
        bean.setGenere(rs.getString("gender"));
        bean.setTaglia(rs.getString("taglia"));
        bean.setMarca(rs.getString("marca"));
        bean.setPrezzo(rs.getBigDecimal("prezzo"));
        bean.setStato(Stato.valueOf(rs.getString("stato")));
        bean.setModello(rs.getString("modello"));
        bean.setDescrizione(rs.getString("descrizione"));
        bean.setNome(rs.getString("nome"));
        bean.setImmagine(rs.getString("image_url"));
        return bean;
    }

    @Override
    public synchronized void doDelete(Long id) throws SQLException {
        String deleteSQL = "DELETE FROM " + TABLE_NAME + " WHERE codice_prodotto = ?";

        try (Connection connection = DataSourceConnectionPool.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(deleteSQL)) {

            preparedStatement.setLong(1, id);
            preparedStatement.executeUpdate();
        }
    }

    @Override
    public synchronized Collection<ProductBean> doRetrieveAll(String orderBy) throws SQLException {
        String selectSQL = "SELECT * FROM " + TABLE_NAME;
        if (orderBy != null && !orderBy.trim().isEmpty()) {
            String[] parts = orderBy.trim().split("\\s+");
            String column = parts[0].toLowerCase();
            String direction = (parts.length > 1 && "DESC".equalsIgnoreCase(parts[1])) ? "DESC" : "ASC";

            if (ALLOWED_ORDER_COLUMNS.contains(column)) {
                selectSQL += " ORDER BY " + column + " " + direction;
            } else {
                throw new IllegalArgumentException("Parametro orderBy non valido: " + orderBy);
            }
        }
        Collection<ProductBean> products = new LinkedList<>();

        try (Connection connection = DataSourceConnectionPool.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL);
             ResultSet rs = preparedStatement.executeQuery()) {

            while (rs.next()) {
                //ProductBean bean = new ProductBean();
                ProductBean bean = getProductBean(rs);
                products.add(bean);
            }
        }
        return products;
    }


    @Override
    public HashMap<ProductBean, Integer> doGetCartAsProducts(HashMap<Long, Integer> cart) throws SQLException {
        HashMap<ProductBean, Integer> products = new HashMap<>();

        for(Long id : cart.keySet()) {
            ProductBean product = doRetrieveById(id);
            if (product != null) {
                products.put(product, cart.get(id));
            }
        }
        return products;
    }
    @Override
    public synchronized Collection<ProductBean> doRetrievePageableProducts(ProductFilter filter) throws SQLException {
        String conditions = filter.toSql();
        List<Object> parameters = filter.getParameters();

        String query = "SELECT * FROM " + TABLE_NAME + conditions;
        Collection<ProductBean> products = new LinkedList<>();

        try (Connection connection = DataSourceConnectionPool.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {

            int idx = 1;
            for (Object o : parameters) {
                preparedStatement.setObject(idx++, o);
            }

            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    ProductBean bean = getProductBean(rs);
                    products.add(bean);
                }
            }
        }
        return products;
    }

    @Override
    public synchronized Collection<ProductBean> doRetrieveAllFavorites(String orderBy, long Id_Utente) throws SQLException {
        String selectSQL =
                "SELECT p.* " +
                        "  FROM " + TABLE_NAME2 + " f " +
                        "  JOIN " + TABLE_NAME  + " p " +
                        "    ON f.codice_prodotto = p.codice_prodotto " +
                        " WHERE f.Id_Utente = ?";


        if (orderBy != null && !orderBy.isBlank()) {
            if (orderBy.matches("^[a-zA-Z_]+$")) { // Allow only letters and underscores
                selectSQL += " ORDER BY " + orderBy;
            } else {
                throw new IllegalArgumentException("Invalid orderBy parameter");
            }
        }

        Collection<ProductBean> products = new LinkedList<>();

        try (Connection connection = DataSourceConnectionPool.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {

            preparedStatement.setLong(1, Id_Utente);

            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    products.add(getProductBean(rs));
                }
            }
        }
        return products;
    }

    //controlla se il prodotto si trova nei preferiti
    @Override
    public boolean isFavorite(long userId, long productId) throws SQLException {
        String selectSQL = "SELECT 1 FROM " + TABLE_NAME2 + " WHERE codice_prodotto = ? AND id_utente = ?";

        try (Connection connection = DataSourceConnectionPool.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {

            preparedStatement.setLong(1, productId);
            preparedStatement.setLong(2, userId);
            try (ResultSet rs = preparedStatement.executeQuery()) {
                return rs.next();
            }
        }
    }

    //aggiunge il prodotto ai preferiti
    @Override
    public boolean addFavorite(long userId, long productId) throws SQLException {
        String insertSQL = "INSERT INTO " + TABLE_NAME2 + " (id_utente, codice_prodotto) VALUES(?,?)";

        try (Connection connection = DataSourceConnectionPool.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(insertSQL)) {
            preparedStatement.setLong(1, userId);
            preparedStatement.setLong(2, productId);

            return preparedStatement.executeUpdate() > 0;
        }
    }

    //rimuove il prodotto dai preferiti
    @Override
    public boolean removeFavorite(long userId, long productId) throws SQLException {
        String deleteSQL = "DELETE FROM " + TABLE_NAME2 +
                " WHERE codice_prodotto = ? AND id_utente = ?";
        try (Connection connection = DataSourceConnectionPool.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(deleteSQL)) {
            preparedStatement.setLong(1, productId);
            preparedStatement.setLong(2, userId);
            return preparedStatement.executeUpdate() > 0;
        }
    }

    @Override
    public int doCountProducts(ProductFilter filter) throws SQLException {
        String conditions = filter.toSql();
        List<Object> parameters = filter.getParameters();

        String query = "SELECT COUNT(*) FROM " + TABLE_NAME + conditions;
        int count = 0;
        try (Connection connection = DataSourceConnectionPool.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            int idx = 1;
            for (Object o : parameters) {
                preparedStatement.setObject(idx++, o);
            }
            try (ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
            return count;
        }
    }

    @Override
    public void doUpdate(ProductBean prodotto) throws SQLException {
        updateProduct(prodotto);
    }

    @Override
    public void updateProduct(ProductBean prodotto) throws SQLException {
        try (Connection con = DataSourceConnectionPool.getConnection();
             PreparedStatement ps = con.prepareStatement(
                     "UPDATE prodotto SET nome = ?, marca = ?, gender = ?, prezzo = ?, modello = ?, descrizione = ?, taglia = ?, materiale = ?, updated_at = NOW() WHERE codice_prodotto = ?")) {

            ps.setString(1, prodotto.getNome());
            ps.setString(2, prodotto.getMarca());
            ps.setString(3, prodotto.getGenere());
            ps.setBigDecimal(4, prodotto.getPrezzo());
            ps.setString(5, prodotto.getModello());
            ps.setString(6, prodotto.getDescrizione());
            ps.setString(7, prodotto.getTaglia());
            ps.setString(8, prodotto.getMateriale());
            ps.setInt(9, prodotto.getCodiceProdotto());

            ps.executeUpdate();
        }
    }
    @Override
    public void doSave(ProductBean product) throws SQLException {
        String sql = "INSERT INTO prodotto (nome, marca, gender, modello, descrizione, taglia, materiale, prezzo, image_url, created_at, updated_at) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())";

        try (Connection con = DataSourceConnectionPool.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, product.getNome());
            ps.setString(2, product.getMarca());
            ps.setString(3, product.getGenere());
            ps.setString(4, product.getModello());
            ps.setString(5, product.getDescrizione());
            ps.setString(6, product.getTaglia());
            ps.setString(7, product.getMateriale());
            ps.setBigDecimal(8, product.getPrezzo());
            ps.setString(9, product.getImmagine());

            ps.executeUpdate();
        }
    }



}
