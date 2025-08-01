package com.r1.ecommerceproject.model;

import com.r1.ecommerceproject.utils.ProductFilter;

import java.sql.SQLException;
import java.util.Collection;
import java.util.HashMap;

public interface ProductDao extends BaseDao<ProductBean, Long> {
	//Collection<String> doRetrieveAllImages(Long idProduct) throws SQLException;
    HashMap<ProductBean, Integer> doGetCartAsProducts(HashMap<Long, Integer> cart) throws SQLException;
    Collection<ProductBean> doRetrievePageableProducts(ProductFilter filter) throws SQLException;
    int doCountProducts(ProductFilter filter) throws SQLException;

    //controlla se il prodotto si trova nei preferiti
    boolean isFavorite(long userId, long productId) throws SQLException;

    //aggiunge il prodotto ai preferiti
    boolean addFavorite(long userId, long productId) throws SQLException;

    //rimuove il prodotto dai preferiti
    boolean removeFavorite(long userId, long productId) throws SQLException;

    Collection<ProductBean> doRetrieveAllFavorites(String orderBy, long Id_Utente) throws SQLException;
    void updateProduct(ProductBean prodotto) throws SQLException;
    void doSave(ProductBean product) throws SQLException;
}
