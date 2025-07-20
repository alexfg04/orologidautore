package com.r1.ecommerceproject.servlet.admin;

import com.r1.ecommerceproject.model.impl.UserDaoImpl;
import com.r1.ecommerceproject.model.UserBean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import static com.r1.ecommerceproject.utils.Utils.escapeJson;

@WebServlet("/admin/users")
public class UserListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("✅ [SERVLET] Richiesta ricevuta su /admin/users");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        List<UserBean> users;
        try {
            users = new UserDaoImpl().getAllUsers();
            System.out.println("✅ [SERVLET] Utenti recuperati dal database: " + users.size());
        } catch (SQLException e) {
            System.err.println("❌ [SERVLET] Errore durante l'accesso al database:");
            e.printStackTrace();

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"DB_ERROR\",\"message\":\"Errore accesso database\"}");
            return;
        }

        try {
            StringBuilder json = new StringBuilder();
            json.append("[");

            for (int i = 0; i < users.size(); i++) {
                UserBean user = users.get(i);
                json.append("{")
                        .append("\"id\":").append(user.getId()).append(",")
                        .append("\"nome\":\"").append(escapeJson(user.getNome())).append("\",")
                        .append("\"cognome\":\"").append(escapeJson(user.getCognome())).append("\",")
                        .append("\"email\":\"").append(escapeJson(user.getEmail())).append("\",")
                        .append("\"tipologia\":\"").append(user.getTipologia()).append("\"")
                        .append("}");


                if (i < users.size() - 1) json.append(",");
            }

            json.append("]");
            System.out.println("📤 [SERVLET] Risposta JSON generata: " + json);

            response.getWriter().write(json.toString());

        } catch (Exception e) {
            System.err.println("❌ [SERVLET] Errore nella costruzione della risposta JSON:");
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"JSON_ERROR\",\"message\":\"Errore nel generare JSON\"}");
        }
    }
}
