package com.r1.ecommerceproject.dao;

import java.sql.SQLException;
import java.util.Collection;

public interface BaseDao<T, K> {
    T doRetrieveById(K id) throws SQLException;
    Collection<T> doRetrieveAll(String orderBy) throws SQLException;
    void doSave(T entity) throws SQLException;
    void doUpdate(T entity) throws SQLException;
    void doDelete(K id) throws SQLException;
}
