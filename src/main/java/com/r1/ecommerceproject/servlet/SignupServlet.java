package com.r1.ecommerceproject.servlet;

import com.r1.ecommerceproject.model.UserDao;
import com.r1.ecommerceproject.model.impl.UserDaoImpl;
import com.r1.ecommerceproject.model.UserBean;
import com.r1.ecommerceproject.utils.Security;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.Optional;


@WebServlet("/signup")
public class SignupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final UserDao userDao = new UserDaoImpl();

    public SignupServlet() {
        super();
    }


    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String surname = request.getParameter("surname");
        String birthdateStr = request.getParameter("birthDate");

        Gson gson = new Gson();
        JsonObject json = new JsonObject();
        response.setContentType("application/json");

        Optional<String> hashedPassword = Security.hashPassword(password);

        boolean hasEmptyFields = email == null || email.trim().isEmpty() ||
                hashedPassword.isEmpty() ||
                name == null || name.trim().isEmpty() ||
                surname == null || surname.trim().isEmpty() ||
                birthdateStr == null || birthdateStr.trim().isEmpty();

        if (hasEmptyFields || !Security.validateEmail(email)) {
            json.addProperty("success", false);
            json.addProperty("message", "I campi vuoti o non validi");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(gson.toJson(json));
            return;
        }

        LocalDate birthdate = LocalDate.parse(birthdateStr);

        try {
            if (userDao.userExist(email)) {
                json.addProperty("success", false);
                json.addProperty("message", "Email già registrata, effettua il login.");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(gson.toJson(json));
                return;
            }
        } catch (SQLException e) {
            json.addProperty("success", false);
            json.addProperty("message", "Errore interno riprova più tardi");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(json));
            return;
        }

        UserBean user = new UserBean();
        user.setEmail(email);
        user.setPassword(hashedPassword.get());
        user.setNome(name);
        user.setCognome(surname);
        user.setDataDiNascita(birthdate);
        user.setTipologia(UserBean.Role.UTENTE);

        try {
            if (userDao.doSave(user)) {
                long userId = user.getId();
                if (userId <= 0) {
                    throw new SQLException("Registrazione fallita: ID utente non valorizzato.");
                }

                json.addProperty("success", true);
                json.addProperty("message", "Registrazione avvenuta con successo.");
                response.getWriter().write(gson.toJson(json));
            }
        } catch (SQLException e) {
            json.addProperty("success", false);
            json.addProperty("message", "Errore interno riprova più tardi");
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(gson.toJson(json));
        }
    }
}
