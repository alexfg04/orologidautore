package com.r1.ecommerceproject.dao;

import com.r1.ecommerceproject.model.AddressBean;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

public interface AddressDao {


        /* Recupera tutti gli indirizzi associati a un utente specifico tramite il proprio Id */
    List<AddressBean> doRetrieveAddressesByUserId(long userId) throws SQLException;

    /*Recupera un singolo indirizzo tramite il suo ID.*/
    AddressBean doRetrieveAddressById(long addressId) throws SQLException;

    /*Salva un nuovo indirizzo nel database e lo associa a un utente.*/
    void doSave(AddressBean address, long userId) throws SQLException;

    /* Aggiorna un indirizzo esistente nel database.*/
    void doUpdate(AddressBean address) throws SQLException;

    /*Elimina l'associazione tra un indirizzo e un utente specifico.*/
    void doDelete(long addressId, long userId) throws SQLException;
}