package com.r1.ecommerceproject.dao;

import com.r1.ecommerceproject.model.User;
import com.r1.ecommerceproject.utils.DataSourceConnectionPool;

import java.sql.*;

public class UserDAO {

    public static User authenticate(String email, String password) {
        User user = null;

        // Query per cercare l'utente in base all'email
        String query = "SELECT * FROM account WHERE email = ?";

        try (Connection conn = DataSourceConnectionPool.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, email);  // Usa l'email come parametro

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // Recupera la password memorizzata nel database
                String storedPassword = rs.getString("password");

                // Confronta la password fornita con quella memorizzata
                if (storedPassword.equals(password)) {  // Confronto diretto (da migliorare con hashing)
                    user = new User();
                    user.setUsername(rs.getString("nome"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(storedPassword);  // Imposta la password
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return user;
    }


    // Metodo per registrare un utente
    public static boolean registerUser(User user) {
        String query = "INSERT INTO account (name, email, password) VALUES (?, ?, ?)";

        try (Connection conn = DataSourceConnectionPool.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPassword());

            stmt.executeUpdate();
            return true;

        } catch (SQLIntegrityConstraintViolationException e) {
            // Gestisci caso di email già registrata
            return false;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
