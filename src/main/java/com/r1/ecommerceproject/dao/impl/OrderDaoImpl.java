package com.r1.ecommerceproject.dao.impl;

import com.r1.ecommerceproject.dao.OrderDao;
import com.r1.ecommerceproject.model.AddressBean;
import com.r1.ecommerceproject.model.OrderBean;
import com.r1.ecommerceproject.model.ProductBean;
import com.r1.ecommerceproject.utils.DataSourceConnectionPool;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;

public class OrderDaoImpl implements OrderDao {
    private static final String ORDER_TABLE = "Ordine";

    private static final List<String> ALLOWED_ORDER_COLUMNS = Arrays.asList(
            "data_ordine", "data_arrivo"
    );

    @Override
    public OrderBean doRetrieveById(String orderId) throws SQLException {
        String query = "SELECT * FROM " + ORDER_TABLE + " WHERE numero_ordine = ?";
        OrderBean order = null;

        try(Connection conn = DataSourceConnectionPool.getConnection();
            PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, orderId);
            try(ResultSet rs = stmt.executeQuery()) {
                if(rs.next()) {
                    order = new OrderBean();
                    order.setId(rs.getString("numero_ordine"));
                    order.setNote(rs.getString("note"));
                    order.setDataOrdine(rs.getTimestamp("data_ordine"));
                    order.setDataArrivo(rs.getTimestamp("data_arrivo"));
                    order.setTotale(rs.getDouble("totale"));
                }
            }
        }
        return order;
    }

    @Override
    public void doDelete(String orderId) throws SQLException {

    }

    @Override
    public Collection<OrderBean> doRetrieveAll(String orderBy) throws SQLException {
        String query = "SELECT * FROM " + ORDER_TABLE;
        if(orderBy != null && !orderBy.trim().isEmpty()) {
            String[] parts = orderBy.trim().split("\\s+");
            String column = parts[0].toLowerCase();
            String direction = (parts.length > 1 && "DESC".equalsIgnoreCase(parts[1])) ? "DESC" : "`ASC`";
            query += " ORDER BY " + column + " " + direction;

            if (ALLOWED_ORDER_COLUMNS.contains(column)) {
                query += " ORDER BY " + column + " " + direction;
            } else {
                throw new IllegalArgumentException("Parametro orderBy non valido: " + orderBy);
            }
        }

        Collection<OrderBean> orders = new ArrayList<>();
        try(Connection conn = DataSourceConnectionPool.getConnection();
            PreparedStatement stmt = conn.prepareStatement(query)) {
            try(ResultSet rs = stmt.executeQuery()) {
                while(rs.next()) {
                    OrderBean order = new OrderBean();
                    order.setId(rs.getString("numero_ordine"));
                    order.setNote(rs.getString("note"));
                    order.setDataOrdine(rs.getTimestamp("data_ordine"));
                    order.setDataArrivo(rs.getTimestamp("data_arrivo"));
                    order.setTotale(rs.getDouble("totale"));
                    orders.add(order);
                }
            }
        }
        return orders;
    }

    @Override
    public void doSave(OrderBean entity) throws SQLException {

    }

    @Override
    public void doUpdate(OrderBean entity) throws SQLException {

    }

    @Override
    public Collection<OrderBean> doRetrieveAllOrdersByUserId(long userId) throws SQLException {
        String query = "SELECT * FROM " + ORDER_TABLE + " WHERE id_utente = ?";
        Collection<OrderBean> orders = new ArrayList<>();

        try(Connection connection = DataSourceConnectionPool.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setLong(1, userId);
            try(ResultSet rs = preparedStatement.executeQuery()) {
                while(rs.next()) {
                    OrderBean order = new OrderBean();
                    order.setId(rs.getString("numero_ordine"));
                    order.setNote(rs.getString("note"));
                    order.setDataOrdine(rs.getTimestamp("data_ordine"));
                    order.setDataArrivo(rs.getTimestamp("data_arrivo"));
                    order.setTotale(rs.getDouble("totale"));
                    orders.add(order);
                }
            }
        }
        return orders;
    }

    @Override
    public void doSave(OrderBean order, long addressId, long PaymentId) throws SQLException {

    }

    @Override
    public Collection<ProductBean> doRetrieveAllProductsInOrder(String orderId) throws SQLException {
        String query = "SELECT p.* FROM " + ORDER_TABLE + " o " +
                "JOIN Prodotti_Ordine po ON o.numero_ordine = po.numero_ordine " +
                "JOIN Prodotto p ON po.codice_prodotto = p.codice_prodotto " +
                "WHERE o.numero_ordine = ?";
        Collection<ProductBean> products = new ArrayList<>();
        try(Connection connection = DataSourceConnectionPool.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setString(1, orderId);
            try(ResultSet rs = preparedStatement.executeQuery()) {
                while(rs.next()) {
                    ProductBean product = new ProductBean();
                    product.setCodiceProdotto(rs.getInt("codice_prodotto"));
                    product.setNome(rs.getString("nome"));
                    product.setPrezzo(rs.getDouble("prezzo"));
                    product.setStato(ProductBean.Stato.valueOf(rs.getString("stato")));
                    product.setCategoria(rs.getString("categoria"));
                    product.setTaglia(rs.getString("taglia"));
                    product.setMarca(rs.getString("marca"));
                    product.setModello(rs.getString("modello"));
                    product.setDescrizione(rs.getString("descrizione"));
                    product.setImmagine(rs.getString("image_url"));
                    products.add(product);
                }
            }
        }
        return products;
    }

    @Override
    public AddressBean doRetrieveAddress(String orderId) throws SQLException {
        return null;
    }
}
