package com.r1.ecommerceproject.dao;

import com.r1.ecommerceproject.model.ProductBean;

import java.sql.SQLException;
import java.util.Collection;

public interface ProductDao extends BaseDao<ProductBean, Long> {
	//Collection<String> doRetrieveAllImages(Long idProduct) throws SQLException;

}
