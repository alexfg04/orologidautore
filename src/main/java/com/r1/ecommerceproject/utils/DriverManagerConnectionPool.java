package com.r1.ecommerceproject.utils;

import java.io.IOException;
import java.io.InputStream;
import java.sql.*;
import java.util.*;

public class DriverManagerConnectionPool {

	private static final List<Connection> freeDbConnections;
	private static final Properties dbProps = new Properties();

	static {
		freeDbConnections = new LinkedList<>();
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");

			// Carica le proprietà dal file
			try (InputStream input = DriverManagerConnectionPool.class.getClassLoader().getResourceAsStream("db.properties")) {
				if (input == null) {
					throw new RuntimeException("File db.properties non trovato!");
				}
				dbProps.load(input);
			} catch (IOException e) {
				throw new RuntimeException("Errore nel caricamento di db.properties: " + e.getMessage());
			}

		} catch (ClassNotFoundException e) {
			System.out.println("DB driver non trovato: " + e.getMessage());
		}
	}

	private static synchronized Connection createDBConnection() throws SQLException {
		String ip = dbProps.getProperty("db.host");
		String port = dbProps.getProperty("db.port");
		String db = dbProps.getProperty("db.name");
		String username = dbProps.getProperty("db.user");
		String password = dbProps.getProperty("db.password");

		String connectionUrl = String.format(
				"jdbc:mysql://%s:%s/%s?useUnicode=true&useJDBCCompliantTimezoneShift=true&useLegacyDatetimeCode=false&serverTimezone=UTC",
				ip, port, db);

		Connection newConnection = DriverManager.getConnection(connectionUrl, username, password);
		newConnection.setAutoCommit(false);
		return newConnection;
	}

	public static synchronized Connection getConnection() {
		if (freeDbConnections.isEmpty()) {
			// Se il pool è vuoto, crea una nuova connessione
			try {
				System.out.println("Pool vuoto, creo nuova connessione...");
				return createDBConnection();
			} catch (SQLException e) {
				throw new RuntimeException("Impossibile creare una nuova connessione DB: " + e.getMessage(), e);
			}
		}

		System.out.println("Restituisco connessione dal pool (" + (freeDbConnections.size() - 1) + ")");
		return freeDbConnections.remove(0);
	}

	public static synchronized void releaseConnection(Connection connection) {
		if (connection != null) {
			freeDbConnections.add(connection);
		}
	}
}
