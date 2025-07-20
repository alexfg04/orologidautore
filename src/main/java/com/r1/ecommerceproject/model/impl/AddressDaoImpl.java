package com.r1.ecommerceproject.model.impl;

import com.r1.ecommerceproject.model.AddressDao;
import com.r1.ecommerceproject.model.AddressBean;
import com.r1.ecommerceproject.model.AddressBean.Tipo;
import com.r1.ecommerceproject.utils.DataSourceConnectionPool;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AddressDaoImpl implements AddressDao {

    private static final String TABLE_NAME_ADDRESS = "Indirizzo";
    private static final String TABLE_NAME_LOCATO = "Indirizzo_Utente";

    // Metodo helper modernizzato
    private AddressBean mapResultSetToAddress(ResultSet rs) throws SQLException {
        var bean = new AddressBean();
        bean.setId(rs.getLong("id_indirizzo"));
        bean.setVia(rs.getString("via"));
        bean.setCitta(rs.getString("citta"));
        bean.setCap(rs.getString("CAP"));
        bean.setTipologia(Tipo.valueOf(rs.getString("tipologia").toUpperCase()));
        bean.setDefault(rs.getBoolean("is_default"));
        return bean;
    }

    @Override
    public List<AddressBean> doRetrieveAddressesByUserId(long userId) throws SQLException {
        var selectSQL = """
            SELECT i.*, l.is_default FROM %s i
            JOIN %s l ON i.id_indirizzo = l.id_indirizzo
            WHERE l.id_utente = ?
            """.formatted(TABLE_NAME_ADDRESS, TABLE_NAME_LOCATO);

        try (var connection = DataSourceConnectionPool.getConnection();
             var preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setLong(1, userId);
            
            try (var rs = preparedStatement.executeQuery()) {
                var addresses = new ArrayList<AddressBean>();
                while (rs.next()) {
                    addresses.add(mapResultSetToAddress(rs));
                }
                return addresses;
            }
        }
    }

    @Override
    public AddressBean doRetrieveById(long addressId) throws SQLException {
        var selectSQL = "SELECT * FROM %s WHERE id_indirizzo = ?".formatted(TABLE_NAME_ADDRESS);
        
        AddressBean bean = null;
        
        try (var connection = DataSourceConnectionPool.getConnection();
             var preparedStatement = connection.prepareStatement(selectSQL)) {
            
            preparedStatement.setLong(1, addressId);
            
            try (var rs = preparedStatement.executeQuery()) {
                if (rs.next()) {
                    bean = new AddressBean();
                    bean.setId(rs.getLong("id_indirizzo"));
                    bean.setVia(rs.getString("via"));
                    bean.setCitta(rs.getString("citta"));
                    bean.setCap(rs.getString("CAP"));
                    bean.setTipologia(Tipo.valueOf(rs.getString("tipologia").toUpperCase()));
                }
            }
        }
        return bean;
    }

    @Override
    public synchronized void doSave(AddressBean address, long userId) throws SQLException {
        var insertAddressSQL = """
            INSERT INTO %s (via, citta, CAP, tipologia)
            VALUES (?, ?, ?, ?)
            """.formatted(TABLE_NAME_ADDRESS);
            
        var insertLocatoSQL = """
            INSERT INTO %s (id_indirizzo, id_utente) 
            VALUES (?, ?)
            """.formatted(TABLE_NAME_LOCATO);

        try (var connection = DataSourceConnectionPool.getConnection()) {
            connection.setAutoCommit(false);
            
            try {
                // 1. Inserisci indirizzo e ottieni ID generato
                long generatedAddressId;
                try (var psAddress = connection.prepareStatement(insertAddressSQL, 
                        Statement.RETURN_GENERATED_KEYS)) {
                    
                    psAddress.setString(1, address.getVia());
                    psAddress.setString(2, address.getCitta());
                    psAddress.setString(3, address.getCap());
                    psAddress.setString(4, address.getTipologia().name().toUpperCase());
                    psAddress.executeUpdate();
                    
                    try (var generatedKeys = psAddress.getGeneratedKeys()) {
                        if (generatedKeys.next()) {
                            generatedAddressId = generatedKeys.getLong(1);
                            address.setId(generatedAddressId);
                        } else {
                            throw new SQLException("La creazione dell'indirizzo non ha generato nessun ID.");
                        }
                    }
                }
                
                // 2. Associa indirizzo all'utente
                try (var psLocato = connection.prepareStatement(insertLocatoSQL)) {
                    psLocato.setLong(1, generatedAddressId);
                    psLocato.setLong(2, userId);
                    psLocato.executeUpdate();
                }
                
                connection.commit();
                
            } catch (SQLException e) {
                connection.rollback();
                throw e;
            } finally {
                connection.setAutoCommit(true);
            }
        }
    }

    @Override
    public synchronized void doUpdate(AddressBean address) throws SQLException {
        var updateSQL = """
            UPDATE %s 
            SET via = ?, citta = ?, CAP = ?, tipologia = ? 
            WHERE id_indirizzo = ?
            """.formatted(TABLE_NAME_ADDRESS);

        try (var connection = DataSourceConnectionPool.getConnection();
             var preparedStatement = connection.prepareStatement(updateSQL)) {
            
            preparedStatement.setString(1, address.getVia());
            preparedStatement.setString(2, address.getCitta());
            preparedStatement.setString(3, address.getCap());
            preparedStatement.setString(4, address.getTipologia().name().toLowerCase());
            preparedStatement.setLong(5, address.getId());
            
            preparedStatement.executeUpdate();
        }
    }

    @Override
    public synchronized void doDelete(long addressId, long userId) throws SQLException {
        var deleteLocatoSQL = """
            DELETE FROM %s 
            WHERE id_indirizzo = ? AND id_utente = ?
            """.formatted(TABLE_NAME_LOCATO);
            
        var checkReferencesSQL = """
            SELECT COUNT(*) FROM %s 
            WHERE id_indirizzo = ?
            """.formatted(TABLE_NAME_LOCATO);
            
        var deleteAddressSQL = """
            DELETE FROM %s 
            WHERE id_indirizzo = ?
            """.formatted(TABLE_NAME_ADDRESS);

        try (var connection = DataSourceConnectionPool.getConnection()) {
            connection.setAutoCommit(false);
            
            try {
                // 1. Elimina associazione
                try (var psLocato = connection.prepareStatement(deleteLocatoSQL)) {
                    psLocato.setLong(1, addressId);
                    psLocato.setLong(2, userId);
                    psLocato.executeUpdate();
                }
                
                // 2. Controlla riferimenti rimanenti
                int remainingReferences = 0;
                try (var psCheck = connection.prepareStatement(checkReferencesSQL)) {
                    psCheck.setLong(1, addressId);
                    try (var rs = psCheck.executeQuery()) {
                        if (rs.next()) {
                            remainingReferences = rs.getInt(1);
                        }
                    }
                }
                
                // 3. Elimina indirizzo se non ci sono più riferimenti
                if (remainingReferences == 0) {
                    try (var psAddress = connection.prepareStatement(deleteAddressSQL)) {
                        psAddress.setLong(1, addressId);
                        psAddress.executeUpdate();
                    }
                }
                
                connection.commit();
                
            } catch (SQLException e) {
                connection.rollback();
                throw e;
            } finally {
                connection.setAutoCommit(true);
            }
        }
    }

    @Override
    public void changeDefaultAddress(long addressId, long userId) throws SQLException {
        var resetDefaultSQL = """
                UPDATE %s
                SET is_default = false
                WHERE id_utente = ?
                """.formatted(TABLE_NAME_LOCATO);

        var setDefaultSQL = """
                UPDATE %s
                SET is_default = true
                WHERE id_indirizzo = ? AND id_utente = ?
                """.formatted(TABLE_NAME_LOCATO);

        try (var connection = DataSourceConnectionPool.getConnection()) {
            connection.setAutoCommit(false);

            try {
                // Reset all addresses to non-default
                try (var psReset = connection.prepareStatement(resetDefaultSQL)) {
                    psReset.setLong(1, userId);
                    psReset.executeUpdate();
                }

                // Set the specified address as default
                try (var psSetDefault = connection.prepareStatement(setDefaultSQL)) {
                    psSetDefault.setLong(1, addressId);
                    psSetDefault.setLong(2, userId);
                    psSetDefault.executeUpdate();
                }

                connection.commit();

            } catch (SQLException e) {
                connection.rollback();
                throw e;
            } finally {
                connection.setAutoCommit(true);
            }
        }
    }
}