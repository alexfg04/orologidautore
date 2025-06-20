package com.r1.ecommerceproject.dao;

import com.r1.ecommerceproject.model.ProductBean;
import com.r1.ecommerceproject.utils.ProductFilter;

import java.sql.SQLException;
import java.util.Collection;
import java.util.HashMap;

public interface ProductDao extends BaseDao<ProductBean, Long> {
	//Collection<String> doRetrieveAllImages(Long idProduct) throws SQLException;
    HashMap<ProductBean, Integer> doGetCartAsProducts(HashMap<Long, Integer> cart) throws SQLException;
    Collection<ProductBean> doRetrievePageableProducts(int page, int pageSize, ProductFilter filter) throws SQLException;
    int doCountProducts(ProductFilter filter) throws SQLException;

}
