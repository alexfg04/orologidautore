package com.r1.ecommerceproject.dao;

import com.r1.ecommerceproject.model.AddressBean;
import com.r1.ecommerceproject.model.OrderBean;
import com.r1.ecommerceproject.model.ProductBean;

import java.sql.SQLException;
import java.util.Collection;

public interface OrderDao extends BaseDao<OrderBean, String> {
    OrderBean doRetrieveById(String orderId) throws SQLException;
    void doDelete(String orderId) throws SQLException;
    Collection<OrderBean> doRetrieveAll(String orderBy) throws SQLException;
    Collection<OrderBean> doRetrieveAllOrdersByUserId(long userId) throws SQLException;
    void doSave(OrderBean order, long addressId, long PaymentId) throws SQLException;
    Collection<ProductBean> doRetrieveAllProductsInOrder(String orderId) throws SQLException;
    AddressBean doRetrieveAddress(String orderId) throws SQLException;
}
