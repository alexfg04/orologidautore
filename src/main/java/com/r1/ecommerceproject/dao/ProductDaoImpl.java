package com.r1.ecommerceproject.dao;

import com.r1.ecommerceproject.utils.DataSourceConnectionPool;
import com.r1.ecommerceproject.model.ProductBean;
import com.r1.ecommerceproject.model.ProductBean.Stato;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import java.util.HashMap;
import java.util.LinkedList;

public class ProductDaoImpl implements ProductDao {

    private static final String TABLE_NAME = "Prodotto";
    private static final String TABLE_NAME2= "Preferiti";

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
        if (orderBy != null && !orderBy.isBlank()) {
            if (orderBy.matches("^[a-zA-Z_]+$")) { // Allow only letters and underscores
                selectSQL += " ORDER BY " + orderBy;
            } else {
                throw new IllegalArgumentException("Invalid orderBy parameter");
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
    public boolean isFavorite(long userId, long productId) throws SQLException{
        String selectSQL="SELECT 1 FROM "+TABLE_NAME2+" WHERE codice_prodotto = ? AND id_utente = ?";

        try (Connection connection = DataSourceConnectionPool.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {

            preparedStatement.setLong(1, productId);
            preparedStatement.setLong(2, userId);
            try(ResultSet rs=preparedStatement.executeQuery()){
                return rs.next();
            }
        }
    }


    //aggiunge il prodotto ai preferiti
    @Override
    public boolean addFavorite(long userId, long productId) throws SQLException{
        String insertSQL="INSERT INTO "+TABLE_NAME2+" (id_utente, codice_prodotto) VALUES(?,?)";

        try (Connection connection = DataSourceConnectionPool.getConnection();
        PreparedStatement preparedStatement = connection.prepareStatement(insertSQL)) {
            preparedStatement.setLong(1, userId);
            preparedStatement.setLong(2, productId);

            return preparedStatement.executeUpdate()>0;
        }
    }

    //rimuove il prodotto dai preferiti
    @Override
    public boolean removeFavorite(long userId, long productId) throws SQLException{

        String deleteSQL ="DELETE FROM " + TABLE_NAME2 +
                        " WHERE codice_prodotto = ? AND id_utente = ?";
        try (Connection connection = DataSourceConnectionPool.getConnection();
        PreparedStatement preparedStatement = connection.prepareStatement(deleteSQL)) {
            preparedStatement.setLong(1, productId);
            preparedStatement.setLong(2, userId);
            return preparedStatement.executeUpdate()>0;
        }
    }
}
