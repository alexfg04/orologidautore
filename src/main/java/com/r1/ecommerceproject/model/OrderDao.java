package com.r1.ecommerceproject.model;

import java.sql.SQLException;
import java.util.Collection;
import java.util.List;

public interface OrderDao extends BaseDao<OrderBean, String> {
    OrderBean doRetrieveById(String orderNumber) throws SQLException;
    void doDelete(Long id) throws SQLException;
    void doDelete(String orderNumber) throws SQLException;
    Collection<OrderBean> doRetrieveAll(String orderBy) throws SQLException;
    Collection<OrderBean> doRetrieveAllOrdersByUserId(long userId) throws SQLException;
    Long doSave(OrderBean order, long addressId, long userId) throws SQLException;
    void doSaveOrderProduct(Long orderId, ProductBean product, int quantity) throws SQLException;
    void doUpdate(OrderBean entity, long addressId, long userId) throws SQLException;
    Collection<ProductBean> doRetrieveAllProductsInOrder(String orderNumber) throws SQLException;
    AddressBean doRetrieveAddress(String orderId) throws SQLException;
    void savePayment(PaymentBean payment, Long orderId) throws SQLException;
    String getOrderNumber(Long orderId) throws SQLException;
    List<OrderBean> getOrdiniByUtenteId(int idUtente) throws SQLException;
    int countOrdersByMonth(int mese) throws SQLException;
}
