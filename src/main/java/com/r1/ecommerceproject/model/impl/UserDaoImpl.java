package com.r1.ecommerceproject.model.impl;

import com.r1.ecommerceproject.model.UserDao;
import com.r1.ecommerceproject.model.AddressBean;
import com.r1.ecommerceproject.model.PhoneNumberBean;
import com.r1.ecommerceproject.model.UserBean;
import com.r1.ecommerceproject.utils.DataSourceConnectionPool;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDaoImpl implements UserDao {
    private static final String TABLE_NAME="Utente";
    private static final String TABLE_NAME2="Indirizzo";
    private static final String TABLE_NAME3="NumeroTelefono";
    private static final String TABLE_NAME4="Indirizzo_Utente";

    //metodo che ci permette di effettuare l'intera registazione di un nuovo utente e dei suoi dati
    @Override
    public boolean doSave(UserBean user) throws SQLException {
        String insertSQL =
                "INSERT INTO " + TABLE_NAME +
                        " (nome, cognome, email, password, tipologia, data_nascita)" +
                        " VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection connection = DataSourceConnectionPool.getConnection();
             PreparedStatement stmt = connection.prepareStatement(
                     insertSQL, Statement.RETURN_GENERATED_KEYS)) {

            // 1) Imposta i parametri
            stmt.setString(1, user.getNome());
            stmt.setString(2, user.getCognome());
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getPassword());
            stmt.setString(5, user.getTipologia().name());
            stmt.setDate(6, Date.valueOf(user.getDataDiNascita()));

            // 2) Esegui l'INSERT
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creazione utente fallita: nessuna riga inserita.");
            }

            // 3) Recupera la chiave generata e valorizza il bean
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    long newId = generatedKeys.getLong(1);
                    user.setId(newId);      // usa il setter corretto del tuo bean
                } else {
                    throw new SQLException("Creazione utente fallita: impossibile ottenere l'ID generato.");
                }
            }
        }

        return true;
    }

    //metodo che permette di inserire un nuovo indirizzo all'interno del nostro database
    @Override
    public	boolean addAddress(AddressBean Indirizzo, long Id_Utente)throws SQLException{
        long Id_Indirizzo;
        //salvataggio di un nuovo indirizzo
        String createIndirizzo="INSERT INTO " + TABLE_NAME2 +
                " (via, citta,CAP)" +
                "VALUES ( ?, ?, ?)";

        try (Connection connection = DataSourceConnectionPool.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(createIndirizzo, Statement.RETURN_GENERATED_KEYS)) {

            preparedStatement.setString(1,Indirizzo.getVia());
            preparedStatement.setString(2,Indirizzo.getCitta());
            preparedStatement.setString(3,Indirizzo.getCap());


            if(preparedStatement.executeUpdate() == 0) {
                throw new SQLException("Errore nella creazione dell'indirizzo");
            }
            // Recuperare l'ID appena generato per aggiungerlo nella tabella dell'utente
            try (ResultSet generatedKeys = preparedStatement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    Id_Indirizzo = generatedKeys.getLong(1);
                }else{
                    throw new SQLException("Errore nella creazione dell'indirizzo");
                }
            }
            return associateAddress(Id_Indirizzo, Id_Utente, Indirizzo.getTipologia());
        }

    }


    //metodo utilizzato per associare un indirizzo all utente corretto
    private boolean associateAddress(long Id_Indirizzo, long Id_Utente, AddressBean.Tipo tipo)throws SQLException {

        String query ="INSERT INTO " + TABLE_NAME4 +
                " (id_indirizzo, id_utente, tipologia)" +
                "VALUES ( ?, ?, ?)";

        try (PreparedStatement preparedStatement = DataSourceConnectionPool.getConnection().prepareStatement(query)) {

            preparedStatement.setLong(1,Id_Indirizzo);
            preparedStatement.setLong(2,Id_Utente);
            preparedStatement.setString(3, tipo.name());

            return preparedStatement.executeUpdate() > 0;
        }
    }


    //metodo utilizzato per salvare un nuovo numero di telefono
    @Override
    public boolean addPhoneNumber(long Id_Utente, PhoneNumberBean telefono)throws SQLException{

        String createTelefono="INSERT INTO "+ TABLE_NAME3 +
                "(prefisso, numero, id_utente)"+
                "VALUES(?,?,?)";


        try (Connection connection = DataSourceConnectionPool.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(createTelefono)) {

            preparedStatement.setString(1,telefono.getPrefisso());
            preparedStatement.setString(2,telefono.getNumero());
            preparedStatement.setLong(3,Id_Utente);				//associamo il numero di telefono al giusto utente

            if(preparedStatement.executeUpdate() == 0){
                throw new SQLException("Errore nella creazione del numero di telefono");
            }else{
                return true;
            }
        }
    }


    @Override
    public boolean userExist(String email)throws SQLException {

        String query = " SELECT 1 FROM " + TABLE_NAME
                + " WHERE email = ? LIMIT 1";

        try (Connection connection = DataSourceConnectionPool.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {

            preparedStatement.setString(1,email);

            try (ResultSet rs=preparedStatement.executeQuery()){
                return rs.next();						//ritorna true se esiste l'utente nel database
            }
        }
    }

    @Override
    public UserBean doRetrieveByEmail(String email) throws SQLException {
        String query = "SELECT * FROM " + TABLE_NAME + " WHERE email = ?";
        UserBean user;
        try (Connection connection = DataSourceConnectionPool.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setString(1, email);
            try (ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next()) {
                    user = new UserBean();
                    user.setId(rs.getLong("id_utente"));
                    user.setNome(rs.getString("nome"));
                    user.setCognome(rs.getString("cognome"));
                    user.setEmail(rs.getString("email"));
                    user.setPassword(rs.getString("password"));

                    // Conversione sicura della tipologia
                    String ruolo = rs.getString("tipologia");
                    if (ruolo != null) {
                        user.setTipologia(UserBean.Role.valueOf(ruolo.toUpperCase()));
                    } else {
                        user.setTipologia(UserBean.Role.UTENTE); // fallback predefinito
                    }
                } else {
                    throw new SQLException("Utente non trovato");
                }
            }
        }
        return user;
    }


    @Override
    public List<UserBean> getAllUsers() throws SQLException {
        List<UserBean> users = new ArrayList<>();
        String query = "SELECT * FROM " + TABLE_NAME;

        try (Connection connection = DataSourceConnectionPool.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query);
             ResultSet rs = preparedStatement.executeQuery()) {

            while (rs.next()) {
                UserBean user = new UserBean();
                user.setId(rs.getLong("id_utente"));
                user.setNome(rs.getString("nome"));
                user.setCognome(rs.getString("cognome"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password")); // attenzione: di solito non si manda la password alla vista
                user.setTipologia(UserBean.Role.valueOf(rs.getString("tipologia")));
                // eventualmente aggiungi altri campi come id o dataDiNascita se li hai
                users.add(user);
            }
        }
        return users;
    }

    @Override
    public UserBean doRetrieveById(long id) throws SQLException {
        String sql = "SELECT * FROM Utente WHERE id_utente = ?";
        try (Connection conn = DataSourceConnectionPool.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    UserBean u = new UserBean();
                    u.setId(rs.getLong("id_utente"));
                    u.setNome(rs.getString("nome"));
                    u.setCognome(rs.getString("cognome"));
                    u.setEmail(rs.getString("email"));
                    u.setPassword(rs.getString("password"));
                    u.setTipologia(UserBean.Role.valueOf(rs.getString("tipologia")));
                    u.setDataDiNascita(rs.getDate("data_nascita").toLocalDate());
                    return u;
                }
            }
        }
        return null;
    }

    public boolean emailExists(String email) throws SQLException {
        String sql = "SELECT 1 FROM utente WHERE email = ?";
        try (Connection con = DataSourceConnectionPool.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }


}
