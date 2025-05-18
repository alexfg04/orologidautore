package com.r1.ecommerceproject.dao;

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

    private static final List<String> ALLOWED_ORDER_COLUMNS = Arrays.asList(
            "codice_prodotto", "nome", "prezzo", "categoria", "marca"
            // Aggiungere altre colonne consentite per l'ordinamento
    );

    @Override
    public synchronized void doSave(ProductBean product) throws SQLException {
        String insertSQL = "INSERT INTO " + TABLE_NAME +
                " (nome, descrizione, prezzo, modello, marca, categoria, taglia , materiale, image_url)" +
                "VALUES ( ?, ?, ?,?, ?, ?, ?, ?, ?)";

        try (Connection connection = DataSourceConnectionPool.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(insertSQL)) {

            preparedStatement.setString(1, product.getNome());
            preparedStatement.setString(2, product.getDescrizione());
            preparedStatement.setDouble(3, product.getPrezzo());
            preparedStatement.setString(4, product.getModello());
            preparedStatement.setString(5, product.getMarca());
            preparedStatement.setString(6, product.getCategoria());
            preparedStatement.setString(7, product.getTaglia());
            preparedStatement.setString(8, product.getMateriale());
            preparedStatement.setString(9, product.getImmagine());

            preparedStatement.executeUpdate();
        }
    }

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
        bean.setCategoria(rs.getString("categoria"));
        bean.setTaglia(rs.getString("taglia"));
        bean.setMarca(rs.getString("marca"));
        bean.setPrezzo(rs.getDouble("prezzo"));
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
    public synchronized void doUpdate(ProductBean product) { }

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
    public synchronized Collection<ProductBean> doRetrievePageableProducts(int page, int pageSize, ProductFilter filter) throws SQLException {
        List<Object> parameters = filter.getParameterValues();
        String conditions = filter.getQueryCondition();

        String query = "SELECT * FROM " + TABLE_NAME + " " + conditions + " LIMIT ? OFFSET ?";

        Collection<ProductBean> products = new LinkedList<>();

        try (Connection connection = DataSourceConnectionPool.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {

            int idx = 1;
            for (Object o : parameters) {
                preparedStatement.setObject(idx++, o);
            }
            // imposta l'offset e il numero di elementi da ritornare per pagina
            preparedStatement.setInt(idx++, pageSize);
            preparedStatement.setInt(idx, (page - 1) * pageSize);

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
    public int doCountProducts(ProductFilter filter) throws SQLException {
        List<Object> parameters = filter.getParameterValues();
        String conditions = filter.getQueryCondition();

        String query = "SELECT COUNT(*) FROM " + TABLE_NAME + " " + conditions;
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
}
