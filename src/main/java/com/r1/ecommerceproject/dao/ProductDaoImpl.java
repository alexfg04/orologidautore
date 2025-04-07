package com.r1.ecommerceproject.dao;

import com.r1.ecommerceproject.utils.DataSourceConnectionPool;
import com.r1.ecommerceproject.model.ProductBean;
import com.r1.ecommerceproject.model.ProductBean.Stato;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import java.util.LinkedList;

public class ProductDaoImpl implements ProductDao {

	private static final String TABLE_NAME = "Prodotto";

	@Override
	public synchronized void doSave(ProductBean product) throws SQLException {
		String insertSQL = "INSERT INTO " + TABLE_NAME + " (materiale, categoria, taglia, marca, prezzo, stato, modello, descrizione , nome) VALUES ( ?, ?, ?,?, ?, ?, ?,?, ?)";

		try (Connection connection = DataSourceConnectionPool.getConnection();
			 PreparedStatement preparedStatement = connection.prepareStatement(insertSQL)) {

			preparedStatement.setString(1, product.getMateriale());
			preparedStatement.setString(2, product.getCategoria());
			preparedStatement.setString(3, product.getTaglia());
			preparedStatement.setString(4, product.getMarca());
			preparedStatement.setDouble(5, product.getPrezzo());
			preparedStatement.setString(6, product.getStato().name());
			preparedStatement.setString(7, product.getModello());
			preparedStatement.setString(8, product.getDescrizione());
			preparedStatement.setString(9, product.getNome());


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
					bean.setCodiceProdotto(rs.getInt("codice_prodotto"));
					bean.setMateriale(rs.getString("materiale"));
					bean.setCategoria(rs.getString("categoria"));
					bean.setTaglia(rs.getString("taglia"));
					bean.setMarca(rs.getString("marca"));
					bean.setPrezzo(rs.getDouble("prezzo"));
					bean.setStato(Stato.valueOf(rs.getString("stato")));
					bean.setModello(rs.getString("modello"));
					bean.setDescrizione(rs.getString("descrizione"));
					bean.setNome(rs.getString("nome"));
				}
			}
		}
		return bean;
	}

	@Override
	public synchronized boolean doDelete(int code) throws SQLException {
		String deleteSQL = "DELETE FROM " + TABLE_NAME + " WHERE codice_prodotto = ?";
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
				bean = new ProductBean();
				bean.setCodiceProdotto(rs.getInt("codice_prodotto"));
				bean.setMateriale(rs.getString("materiale"));
				bean.setCategoria(rs.getString("categoria"));
				bean.setTaglia(rs.getString("taglia"));
				bean.setMarca(rs.getString("marca"));
				bean.setPrezzo(rs.getDouble("prezzo"));
				bean.setStato(Stato.valueOf(rs.getString("stato")));
				bean.setModello(rs.getString("modello"));
				bean.setDescrizione(rs.getString("descrizione"));
				bean.setNome(rs.getString("nome"));
				products.add(bean);
			}
		}
		return products;
	}
}
