package com.r1.ecommerceproject.model;

import java.sql.SQLException;
import java.util.List;

public interface UserDao {
    public boolean doSave(UserBean user)throws SQLException;
    public boolean addAddress(AddressBean indirizzo, long idUtente)throws SQLException;
    public boolean addPhoneNumber(long idUtente, PhoneNumberBean telefono)throws SQLException;
    public boolean userExist(String email)throws SQLException;
    public UserBean doRetrieveByEmail(String email) throws SQLException;
    List<UserBean> getAllUsers() throws SQLException;
    UserBean doRetrieveById(long id) throws SQLException;
}
