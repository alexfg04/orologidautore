package com.r1.ecommerceproject.utils;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

public class DataSourceConnectionPool {

	private static final DataSource dataSource;

	static {
		try {
			// Recupera il contesto JNDI
			Context initContext = new InitialContext();
			Context envContext = (Context) initContext.lookup("java:/comp/env");

			// Cerca il DataSource configurato in Tomcat
			dataSource = (DataSource) envContext.lookup("jdbc/storage");
		} catch (NamingException e) {
			throw new ExceptionInInitializerError("Errore nella configurazione del DataSource: " + e.getMessage());
		}
	}

	/**
	 * Restituisce una connessione al database dal pool di Tomcat
	 */
	public static Connection getConnection() throws SQLException {
		return dataSource.getConnection();
	}
}
