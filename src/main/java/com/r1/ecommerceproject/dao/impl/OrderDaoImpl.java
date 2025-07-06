package com.r1.ecommerceproject.dao.impl;

import com.r1.ecommerceproject.dao.OrderDao;
import com.r1.ecommerceproject.model.AddressBean;
import com.r1.ecommerceproject.model.OrderBean;
import com.r1.ecommerceproject.model.PaymentBean;
import com.r1.ecommerceproject.model.ProductBean;
import com.r1.ecommerceproject.utils.DataSourceConnectionPool;
import com.r1.ecommerceproject.utils.Utils;

import java.sql.*;
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
    public OrderBean doRetrieveById(String orderNumber) throws SQLException {
        String query = "SELECT * FROM " + ORDER_TABLE + " WHERE id = ?";
        OrderBean order = null;

        try(Connection conn = DataSourceConnectionPool.getConnection();
            PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, orderNumber);
            try(ResultSet rs = stmt.executeQuery()) {
                if(rs.next()) {
                    order = new OrderBean();
                    order.setNumeroOrdine(rs.getString("numero_ordine"));
                    order.setNote(rs.getString("note"));
                    order.setDataOrdine(rs.getTimestamp("data_ordine"));
                    order.setDataArrivo(rs.getTimestamp("data_arrivo"));
                    order.setTotale(rs.getBigDecimal("totale"));
                }
            }
        }
        return order;
    }

    @Override
    public void doDelete(String orderNumber) throws SQLException {
        String sql = "DELETE FROM " + ORDER_TABLE + " WHERE id = ?";
        try (Connection conn = DataSourceConnectionPool.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, orderNumber);
            stmt.executeUpdate();
        }
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
                    order.setNumeroOrdine(rs.getString("numero_ordine"));
                    order.setNote(rs.getString("note"));
                    order.setDataOrdine(rs.getTimestamp("data_ordine"));
                    order.setDataArrivo(rs.getTimestamp("data_arrivo"));
                    order.setTotale(rs.getBigDecimal("totale"));
                    orders.add(order);
                }
            }
        }
        return orders;
    }

    //metodo implementato per togliere l'errore riguardo l'implementazione del metodo doSave in BaseDao
    @Override
    public void doSave(OrderBean entity) throws SQLException {

    }

    @Override
    public Long doSave(OrderBean order, long addressId, long userId) throws SQLException{

        String orderNumber= Utils.generateOrderNumber();
        String insertSql =
                "INSERT INTO Ordine (numero_ordine, note, totale_ordine, id_utente, id_indirizzo) " +
                        "VALUES (?, ? ,?, ?, ?)";

        try (Connection connection = DataSourceConnectionPool.getConnection();
             PreparedStatement ps = connection.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, orderNumber);
            ps.setString(2, order.getNote());
            ps.setBigDecimal(3, order.getTotale());
            ps.setLong(4, userId);
            ps.setLong(5, addressId);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if(rs.next()) {
                return rs.getLong(1);
            } else {
                throw new SQLException("Errore durante l'inserimento dell'ordine");
            }
        }
    }

    @Override
    public void doSaveOrderProduct(Long orderId, ProductBean product, int quantity) throws SQLException {
        String query = "INSERT INTO Prodotti_Ordine (id_ordine, codice_prodotto,  prezzo_unitario, quantita) VALUES (?, ?, ?, ?)";
        try (Connection conn = DataSourceConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setLong(1, orderId);
            ps.setLong(2, product.getCodiceProdotto());
            ps.setBigDecimal(3, product.getPrezzo());
            ps.setInt(4, quantity);
            ps.executeUpdate();
        }
    }


    //metodo che fa la stessa cosa di doSave
    @Override
    public void doUpdate(OrderBean entity) throws SQLException {

    }

    @Override
    public void doUpdate(OrderBean entity, long addressId, long userId) throws SQLException {
        String updateSql =
                "UPDATE Ordine SET " +
                        "data_ordine = ?,"+
                        "data_arrivo   = ?, " +
                        "note          = ?, " +
                        "totale_ordine = ?, " +
                        "id_utente     = ?, " +
                        "id_indirizzo  = ?  " +
                        "WHERE numero_ordine = ?";

        try (Connection conn = DataSourceConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(updateSql)) {

            ps.setTimestamp(1, new Timestamp(entity.getDataOrdine().getTime()));
            ps.setTimestamp(2, new Timestamp(entity.getDataArrivo().getTime()));
            ps.setString(3, entity.getNote());
            ps.setBigDecimal(4, entity.getTotale());
            ps.setLong(5, userId);
            ps.setLong(6, addressId);
            ps.setString(7, entity.getNumeroOrdine());
            ps.executeUpdate();
        }
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
                    order.setNumeroOrdine(rs.getString("numero_ordine"));
                    order.setNote(rs.getString("note"));
                    order.setDataOrdine(rs.getTimestamp("data_ordine"));
                    order.setDataArrivo(rs.getTimestamp("data_arrivo"));
                    order.setTotale(rs.getBigDecimal("totale"));
                    orders.add(order);
                }
            }
        }
        return orders;
    }


    @Override
    public Collection<ProductBean> doRetrieveAllProductsInOrder(Long orderId) throws SQLException {
        String query = "SELECT p.* FROM " + ORDER_TABLE + " o " +
                "JOIN Prodotti_Ordine po ON o.id = po.id " +
                "JOIN Prodotto p ON po.codice_prodotto = p.codice_prodotto " +
                "WHERE o.numero_ordine = ?";
        Collection<ProductBean> products = new ArrayList<>();
        try(Connection connection = DataSourceConnectionPool.getConnection();
            PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setLong(1, orderId);
            try(ResultSet rs = preparedStatement.executeQuery()) {
                while(rs.next()) {
                    ProductBean product = new ProductBean();
                    product.setCodiceProdotto(rs.getInt("codice_prodotto"));
                    product.setNome(rs.getString("nome"));
                    product.setPrezzo(rs.getBigDecimal("prezzo"));
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
        AddressBean address = null;
        String query = "SELECT i.id_indirizzo, i.via, i.citta, i.CAP, i.tipologia " +
                "FROM Ordine o JOIN Indirizzo i ON o.id_indirizzo = i.id_indirizzo " +
                "WHERE o.numero_ordine = ?";

        try (Connection con = DataSourceConnectionPool.getConnection(); // Assumi che tu abbia un DataSource definito
             PreparedStatement ps = con.prepareStatement(query)) {

            ps.setString(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    address = new AddressBean();
                    address.setId(rs.getLong("id_indirizzo"));
                    address.setVia(rs.getString("via"));
                    address.setCitta(rs.getString("citta"));
                    address.setCap(rs.getString("CAP"));
                    address.setTipologia(AddressBean.Tipo.valueOf(rs.getString("tipologia")));
                }
            }
        }

        return address;
    }

    @Override
    public void savePayment(PaymentBean payment, Long orderId) throws SQLException {
        String query = "INSERT INTO PagamentoOrdine (id_ordine, token, paypal_email, amount, currency) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DataSourceConnectionPool.getConnection();
        PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setLong(1, orderId);
            ps.setString(2, payment.getToken());
            ps.setString(3, payment.getEmailPayer());
            ps.setBigDecimal(4, payment.getAmount());
            ps.setString(5, payment.getCurrency());
            ps.executeUpdate();
        }
    }

}
