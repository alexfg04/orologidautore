package com.r1.ecommerceproject.dao;

import com.r1.ecommerceproject.utils.DataSourceConnectionPool;
import com.r1.ecommerceproject.model.ProductBean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import java.util.LinkedList;

public class ProductDaoImpl implements ProductDao {

	private static final String TABLE_NAME = "product";

	@Override
	public synchronized void doSave(ProductBean product) throws SQLException {
		String insertSQL = "INSERT INTO " + TABLE_NAME + " (NAME, DESCRIPTION, PRICE, QUANTITY) VALUES (?, ?, ?, ?)";

		try (Connection connection = DataSourceConnectionPool.getConnection();
			 PreparedStatement preparedStatement = connection.prepareStatement(insertSQL)) {

			preparedStatement.setString(1, product.getName());
			preparedStatement.setString(2, product.getDescription());
			preparedStatement.setInt(3, product.getPrice());
			preparedStatement.setInt(4, product.getQuantity());

			preparedStatement.executeUpdate();
			connection.commit();
		}
	}

	@Override
	public synchronized ProductBean doRetrieveByKey(int code) throws SQLException {
		String selectSQL = "SELECT * FROM " + TABLE_NAME + " WHERE CODE = ?";
		ProductBean bean = null;

		try (Connection connection = DataSourceConnectionPool.getConnection();
			 PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {

			preparedStatement.setInt(1, code);
			try (ResultSet rs = preparedStatement.executeQuery()) {
				if (rs.next()) {
					bean = new ProductBean();
					bean.setCode(rs.getInt("CODE"));
					bean.setName(rs.getString("NAME"));
					bean.setDescription(rs.getString("DESCRIPTION"));
					bean.setPrice(rs.getInt("PRICE"));
					bean.setQuantity(rs.getInt("QUANTITY"));
				}
			}
		}
		return bean;
	}

	@Override
	public synchronized boolean doDelete(int code) throws SQLException {
		String deleteSQL = "DELETE FROM " + TABLE_NAME + " WHERE CODE = ?";
		int result;

		try (Connection connection = DataSourceConnectionPool.getConnection();
			 PreparedStatement preparedStatement = connection.prepareStatement(deleteSQL)) {

			preparedStatement.setInt(1, code);
			result = preparedStatement.executeUpdate();
		}
		return result != 0;
	}

	@Override
	public synchronized Collection<ProductBean> doRetrieveAll(String order) throws SQLException {
		String selectSQL = "SELECT * FROM " + TABLE_NAME;
		if (order != null && !order.isBlank()) {
			selectSQL += " ORDER BY " + order;
		}

		Collection<ProductBean> products = new LinkedList<>();

		try (Connection connection = DataSourceConnectionPool.getConnection();
			 PreparedStatement preparedStatement = connection.prepareStatement(selectSQL);
			 ResultSet rs = preparedStatement.executeQuery()) {

			while (rs.next()) {
				ProductBean bean = new ProductBean();
				bean.setCode(rs.getInt("CODE"));
				bean.setName(rs.getString("NAME"));
				bean.setDescription(rs.getString("DESCRIPTION"));
				bean.setPrice(rs.getInt("PRICE"));
				bean.setQuantity(rs.getInt("QUANTITY"));
				products.add(bean);
			}
		}
		return products;
	}
}
