package com.r1.ecommerceproject.dao;

import com.r1.ecommerceproject.model.AddressBean;
import com.r1.ecommerceproject.model.AddressBean.Tipo;
import com.r1.ecommerceproject.utils.DataSourceConnectionPool;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement; // Per Statement.RETURN_GENERATED_KEYS
import java.util.ArrayList;
import java.util.List;



public class AddressDaoImpl implements AddressDao {



    private static final String TABLE_NAME_ADDRESS = "Indirizzo"; // Nome della tabella Indirizzo

    private static final String TABLE_NAME_LOCATO = "Locato"; // Nome della tabella di associazione Locato



// Metodo helper per mappare un ResultSet a un AddressBean

    private AddressBean getAddressBean(ResultSet rs) throws SQLException {

        AddressBean bean = new AddressBean();

        bean.setId(rs.getLong("id_indirizzo"));

        bean.setVia(rs.getString("via"));

        bean.setCitta(rs.getString("citta"));

        bean.setCAP(rs.getString("CAP"));

// Converte la stringa del DB nel tipo enum. Assicurati che i valori DB siano 'fatturazione', 'spedizione', 'entrambi'

        bean.setTipologia(Tipo.valueOf(rs.getString("tipologia").toUpperCase()));

        return bean;

    }



    @Override

    public List<AddressBean> doRetrieveAddressesByUserId(long userId) throws SQLException {

// Query per recuperare tutti gli indirizzi associati a un utente tramite la tabella Locato

        String selectSQL = "SELECT i.* FROM " + TABLE_NAME_ADDRESS + " i " +

                "JOIN " + TABLE_NAME_LOCATO + " l ON i.id_indirizzo = l.id_indirizzo " +

                "WHERE l.id_utente = ?";



        List<AddressBean> addresses = new ArrayList<>();



        try (Connection connection = DataSourceConnectionPool.getConnection();

             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {



            preparedStatement.setLong(1, userId);



            try (ResultSet rs = preparedStatement.executeQuery()) {

                while (rs.next()) {

                    addresses.add(getAddressBean(rs));

                }

            }

        }

        return addresses;

    }



    @Override

    public AddressBean doRetrieveAddressById(long addressId) throws SQLException {

        String selectSQL = "SELECT * FROM " + TABLE_NAME_ADDRESS + " WHERE id_indirizzo = ?";

        AddressBean bean = null;



        try (Connection connection = DataSourceConnectionPool.getConnection();

             PreparedStatement preparedStatement = connection.prepareStatement(selectSQL)) {



            preparedStatement.setLong(1, addressId);

            try (ResultSet rs = preparedStatement.executeQuery()) {

                if (rs.next()) {

                    bean = getAddressBean(rs);

                }

            }

        }

        return bean;

    }



    @Override

    public synchronized void doSave(AddressBean address, long userId) throws SQLException {

// Query per inserire un nuovo indirizzo

        String insertAddressSQL = "INSERT INTO " + TABLE_NAME_ADDRESS +

                " (via, citta, CAP, tipologia) VALUES (?, ?, ?, ?)";

// Query per associare l'indirizzo appena creato all'utente

        String insertLocatoSQL = "INSERT INTO " + TABLE_NAME_LOCATO +

                " (id_indirizzo, id_utente) VALUES (?, ?)";



        Connection connection = null;

        PreparedStatement psAddress = null;

        PreparedStatement psLocato = null;

        ResultSet generatedKeys = null;



        try {

            connection = DataSourceConnectionPool.getConnection();

            connection.setAutoCommit(false); // Inizia una transazione



// 1. Inserisci il nuovo indirizzo e ottieni l'ID generato

            psAddress = connection.prepareStatement(insertAddressSQL, Statement.RETURN_GENERATED_KEYS);

            psAddress.setString(1, address.getVia());

            psAddress.setString(2, address.getCitta());

            psAddress.setString(3, address.getCAP());

            psAddress.setString(4, address.getTipologia().name().toLowerCase()); // Salva enum in minuscolo



            psAddress.executeUpdate();



            generatedKeys = psAddress.getGeneratedKeys();

            long generatedAddressId = -1;

            if (generatedKeys.next()) {

                generatedAddressId = generatedKeys.getLong(1);

                address.setId(generatedAddressId); // Aggiorna il bean con l'ID

            } else {

                throw new SQLException("La creazione dell'indirizzo non ha generato nessun ID.");

            }



// 2. Associa l'indirizzo all'utente nella tabella Locato

            psLocato = connection.prepareStatement(insertLocatoSQL);

            psLocato.setLong(1, generatedAddressId);

            psLocato.setLong(2, userId);

            psLocato.executeUpdate();



            connection.commit(); // Conferma la transazione

        } catch (SQLException e) {

            if (connection != null) {

                connection.rollback(); // Esegui il rollback in caso di errore

            }

            throw e; // Rilancia l'eccezione

        } finally {

// Chiudi le risorse

            if (generatedKeys != null) generatedKeys.close();

            if (psAddress != null) psAddress.close();

            if (psLocato != null) psLocato.close();

            if (connection != null) {

                connection.setAutoCommit(true); // Ripristina l'auto-commit

                connection.close();

            }

        }

    }



    @Override

    public synchronized void doUpdate(AddressBean address) throws SQLException {

// Query per aggiornare un indirizzo esistente

        String updateSQL = "UPDATE " + TABLE_NAME_ADDRESS +

                " SET via=?, citta=?, CAP=?, tipologia=? WHERE id_indirizzo=?";



        try (Connection connection = DataSourceConnectionPool.getConnection();

             PreparedStatement preparedStatement = connection.prepareStatement(updateSQL)) {



            preparedStatement.setString(1, address.getVia());

            preparedStatement.setString(2, address.getCitta());

            preparedStatement.setString(3, address.getCAP());

            preparedStatement.setString(4, address.getTipologia().name().toLowerCase()); // Salva enum in minuscolo

            preparedStatement.setLong(5, address.getId());



            preparedStatement.executeUpdate();

        }

    }



    @Override

    public synchronized void doDelete(long addressId, long userId) throws SQLException {

// 1. Elimina l'associazione specifica utente-indirizzo dalla tabella Locato

        String deleteLocatoSQL = "DELETE FROM " + TABLE_NAME_LOCATO + " WHERE id_indirizzo = ? AND id_utente = ?";

// 2. Controlla se l'indirizzo è ancora referenziato da altri utenti nella tabella Locato

        String checkReferencesSQL = "SELECT COUNT(*) FROM " + TABLE_NAME_LOCATO + " WHERE id_indirizzo = ?";

// 3. Elimina l'indirizzo dalla tabella Indirizzo se non ci sono più riferimenti

        String deleteAddressSQL = "DELETE FROM " + TABLE_NAME_ADDRESS + " WHERE id_indirizzo = ?";



        Connection connection = null;

        PreparedStatement psLocato = null;

        PreparedStatement psCheck = null;

        PreparedStatement psAddress = null;

        ResultSet rsCheck = null;



        try {

            connection = DataSourceConnectionPool.getConnection();

            connection.setAutoCommit(false); // Inizia una transazione



// 1. Elimina l'associazione Locato

            psLocato = connection.prepareStatement(deleteLocatoSQL);

            psLocato.setLong(1, addressId);

            psLocato.setLong(2, userId);

            psLocato.executeUpdate();



// 2. Controlla i riferimenti rimanenti

            psCheck = connection.prepareStatement(checkReferencesSQL);

            psCheck.setLong(1, addressId);

            rsCheck = psCheck.executeQuery();

            int remainingReferences = 0;

            if (rsCheck.next()) {

                remainingReferences = rsCheck.getInt(1);

            }



// 3. Se non ci sono più riferimenti, elimina l'indirizzo

            if (remainingReferences == 0) {

                psAddress = connection.prepareStatement(deleteAddressSQL);

                psAddress.setLong(1, addressId);

                psAddress.executeUpdate();

            }



            connection.commit(); // Conferma la transazione

        } catch (SQLException e) {

            if (connection != null) {

                connection.rollback(); // Esegui il rollback in caso di errore

            }

            throw e; // Rilancia l'eccezione

        } finally {

// Chiudi le risorse

            if (psLocato != null) psLocato.close();

            if (rsCheck != null) rsCheck.close();

            if (psCheck != null) psCheck.close();

            if (psAddress != null) psAddress.close();

            if (connection != null) {

                connection.setAutoCommit(true); // Ripristina l'auto-commit

                connection.close();

            }

        }

    }

}