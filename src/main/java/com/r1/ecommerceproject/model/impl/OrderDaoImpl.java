package com.r1.ecommerceproject.model.impl;

import com.r1.ecommerceproject.model.OrderDao;
import com.r1.ecommerceproject.model.UserDao;
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

    private final UserDao userDao = new UserDaoImpl();

    @Override
    public OrderBean doRetrieveById(String orderNumber) throws SQLException {
        String sql = "SELECT o.*, o.id_utente FROM Ordine o WHERE numero_ordine = ?";
        try (Connection c = DataSourceConnectionPool.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, orderNumber);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    OrderBean order = new OrderBean();
                    order.setNumeroOrdine(rs.getString("numero_ordine"));
                    order.setNote(rs.getString("note"));
                    order.setDataOrdine(rs.getTimestamp("data_ordine"));
                    order.setDataArrivo(rs.getTimestamp("data_arrivo"));
                    order.setTotale(rs.getBigDecimal("totale_ordine"));

                    long uid = rs.getLong("id_utente");
                    order.setUserId(uid);
                    // recupera UserBean
                    order.setCliente(userDao.doRetrieveById(uid));

                    // recupera indirizzo
                    AddressBean addr = doRetrieveAddress(orderNumber);
                    order.setIndirizzo(addr);

                    // prodotti
                    Collection<ProductBean> prods = doRetrieveAllProductsInOrder(orderNumber);
                    order.setProdotti(prods);

                    return order;
                }
            }
        }
        return null;
    }

    @Override
    public Collection<ProductBean> doRetrieveAllProductsInOrder(String orderNumber) throws SQLException {
        String sql =
                "SELECT p.*, po.quantita, po.prezzo_unitario, po.iva_percentuale " +
                        "FROM Prodotti_Ordine po " +
                        "JOIN Prodotto p ON po.codice_prodotto = p.codice_prodotto " +
                        "JOIN Ordine o ON o.id = po.id_ordine " +
                        "WHERE o.numero_ordine = ?";
        Collection<ProductBean> list = new ArrayList<>();
        try (Connection c = DataSourceConnectionPool.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, orderNumber);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProductBean p = new ProductBean();
                    // popola i campi base...
                    p.setNome(rs.getString("nome"));
                    p.setQuantity(rs.getInt("quantita"));
                    p.setImmagine(rs.getString("image_url"));
                    p.setPrezzoUnitario(rs.getBigDecimal("prezzo_unitario"));
                    p.setIvaPercentuale(rs.getBigDecimal("iva_percentuale"));
                    list.add(p);
                }
            }
        }
        return list;
    }

    @Override
    public void doDelete(Long id) throws SQLException {
        String sql = "DELETE FROM " + ORDER_TABLE + " WHERE id = ?";
        try (Connection conn = DataSourceConnectionPool.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, id);
            stmt.executeUpdate();
        }
    }

    @Override
    public Collection<OrderBean> doRetrieveAll(String orderBy) throws SQLException {
        StringBuilder query = new StringBuilder("SELECT * FROM " + ORDER_TABLE);
        if (orderBy != null && !orderBy.trim().isEmpty()) {
            String[] parts = orderBy.trim().split("\\s+");
            String column = parts[0].toLowerCase();
            String direction = (parts.length > 1 && "DESC".equalsIgnoreCase(parts[1])) ? "DESC" : "ASC";
            if (ALLOWED_ORDER_COLUMNS.contains(column)) {
                query.append(" ORDER BY ").append(column).append(" ").append(direction);
            } else {
                throw new IllegalArgumentException("Parametro orderBy non valido: " + orderBy);
            }
        }

        Collection<OrderBean> orders = new ArrayList<>();
        try (Connection conn = DataSourceConnectionPool.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query.toString());
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                OrderBean order = new OrderBean();
                order.setIdOrder(rs.getInt("id"));
                order.setNumeroOrdine(rs.getString("numero_ordine"));
                order.setNote(rs.getString("note"));
                order.setDataOrdine(rs.getTimestamp("data_ordine"));
                order.setDataArrivo(rs.getTimestamp("data_arrivo"));
                order.setTotale(rs.getBigDecimal("totale_ordine"));
                orders.add(order);
            }
        }
        return orders;
    }

    @Override
    public void doSave(OrderBean entity) throws SQLException {
        // not implemented
    }

    @Override
    public Long doSave(OrderBean order, long addressId, long userId) throws SQLException {
        String orderNumber = Utils.generateOrderNumber();
        String insertSql =
                "INSERT INTO " + ORDER_TABLE + " " +
                        "(numero_ordine, note, id_utente, id_indirizzo, totale_ordine) " +
                        "VALUES (?, ?, ?, ?, ?)";

        try (Connection connection = DataSourceConnectionPool.getConnection();
             PreparedStatement ps = connection.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, orderNumber);
            ps.setString(2, order.getNote());
            ps.setLong(3, userId);
            ps.setLong(4, addressId);
            ps.setBigDecimal(5, order.getTotale());
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getLong(1);
                } else {
                    throw new SQLException("Errore durante l'inserimento dell'ordine");
                }
            }
        }
    }

    @Override
    public void doSaveOrderProduct(Long orderId, ProductBean product, int quantity) throws SQLException {
        String query = "INSERT INTO Prodotti_Ordine (id_ordine, codice_prodotto, prezzo_unitario, quantita) VALUES (?, ?, ?, ?)";
        try (Connection conn = DataSourceConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setLong(1, orderId);
            ps.setLong(2, product.getCodiceProdotto());
            ps.setBigDecimal(3, product.getPrezzoUnitario());
            ps.setInt(4, quantity);
            ps.executeUpdate();
        }
    }

    @Override
    public void doUpdate(OrderBean entity) throws SQLException {
        // not implemented
    }

    @Override
    public void doDelete(String orderNumber) throws SQLException {
        String sql = "DELETE FROM " + ORDER_TABLE + " WHERE numero_ordine = ?";
        try (Connection conn = DataSourceConnectionPool.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, orderNumber);
            stmt.executeUpdate();
        }
    }

    @Override
    public void doUpdate(OrderBean entity, long addressId, long userId) throws SQLException {
        String updateSql =
                "UPDATE " + ORDER_TABLE + " SET " +
                        "data_ordine = ?, " +
                        "data_arrivo = ?, " +
                        "note = ?, " +
                        "totale_ordine = ?, " +
                        "id_utente = ?, " +
                        "id_indirizzo = ? " +
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

        try (Connection connection = DataSourceConnectionPool.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setLong(1, userId);
            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    OrderBean order = new OrderBean();
                    order.setNumeroOrdine(rs.getString("numero_ordine"));
                    order.setNote(rs.getString("note"));
                    order.setDataOrdine(rs.getTimestamp("data_ordine"));
                    order.setDataArrivo(rs.getTimestamp("data_arrivo"));
                    order.setTotale(rs.getBigDecimal("totale_ordine"));
                    orders.add(order);
                }
            }
        }
        return orders;
    }

    @Override
    public AddressBean doRetrieveAddress(String orderId) throws SQLException {
        AddressBean address = null;
        String query = "SELECT i.id_indirizzo, i.via, i.citta, i.CAP, i.tipologia " +
                "FROM Ordine o JOIN Indirizzo i ON o.id_indirizzo = i.id_indirizzo " +
                "WHERE o.numero_ordine = ?";

        try (Connection con = DataSourceConnectionPool.getConnection();
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

    @Override
    public String getOrderNumber(Long orderId) throws SQLException {
        String query = "SELECT numero_ordine FROM Ordine WHERE id = ?";
        String orderNumber = null;
        try (Connection conn = DataSourceConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setLong(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    orderNumber = rs.getString("numero_ordine");
                }
            }
        }
        return orderNumber;
    }
    @Override
    public List<OrderBean> getOrdiniByUtenteId(int idUtente) throws SQLException {
        List<OrderBean> ordini = new ArrayList<>();

        try (Connection con = DataSourceConnectionPool.getConnection();
             PreparedStatement ps = con.prepareStatement("SELECT * FROM ordine WHERE id_utente = ? ORDER BY data_ordine DESC")) {
            ps.setInt(1, idUtente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderBean ordine = new OrderBean();
                    ordine.setIdOrder((int) rs.getLong("id"));
                    ordine.setNumeroOrdine(rs.getString("numero_ordine"));
                    ordine.setDataOrdine(rs.getTimestamp("data_ordine"));
                    ordine.setDataArrivo(rs.getTimestamp("data_arrivo"));
                    ordine.setNote(rs.getString("note"));
                    ordine.setTotale(rs.getBigDecimal("totale_ordine"));
                    ordine.setUserId(rs.getInt("id_utente"));
                    ordine.setIdIndirizzo(rs.getInt("id_indirizzo"));
                    ordini.add(ordine);
                }
            }
        }

        return ordini;
    }
    @Override
    public int countOrdersByMonth(int mese) throws SQLException {
        String sql = "SELECT COUNT(*) FROM ordine WHERE MONTH(data_ordine) = ?";
        try (Connection con = DataSourceConnectionPool.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, mese);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

}
