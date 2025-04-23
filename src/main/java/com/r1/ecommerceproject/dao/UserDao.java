package com.r1.ecommerceproject.dao;

import com.r1.ecommerceproject.model.AddressBean;
import com.r1.ecommerceproject.model.PhoneNumberBean;
import com.r1.ecommerceproject.model.UserBean;

import java.sql.SQLException;

public interface UserDao {
    public boolean doSave(UserBean user)throws SQLException;
    public boolean addAddress(AddressBean indirizzo, long idUtente)throws SQLException;
    public boolean addPhoneNumber(long idUtente, PhoneNumberBean telefono)throws SQLException;
    public boolean userExist(String email)throws SQLException;
}
