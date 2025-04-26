package com.r1.ecommerceproject.dao;

import com.r1.ecommerceproject.model.ProductBean;

import java.sql.SQLException;
import java.util.HashMap;

public interface ProductDao extends BaseDao<ProductBean, Long> {
	//Collection<String> doRetrieveAllImages(Long idProduct) throws SQLException;
    HashMap<ProductBean, Integer> doGetCartAsProducts(HashMap<Long, Integer> cart) throws SQLException;

}
