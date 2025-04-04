package com.r1.ecommerceproject.dao;

import com.r1.ecommerceproject.model.ProductBean;

import java.sql.SQLException;
import java.util.Collection;

public interface ProductDao {
	public void doSave(ProductBean product) throws SQLException;

	public boolean doDelete(int code) throws SQLException;

	public ProductBean doRetrieveByKey(int code) throws SQLException;
	
	public Collection<ProductBean> doRetrieveAll(String order) throws SQLException;
}
