package com.r1.ecommerceproject.servlet;

import com.r1.ecommerceproject.dao.UserDAO;
import com.r1.ecommerceproject.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Controlli base
        if (name == null || name.isEmpty() ||
                email == null || email.isEmpty() ||
                password == null || password.isEmpty()) {

            request.setAttribute("errorMessage", "Tutti i campi sono obbligatori.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Crea oggetto utente
        User user = new User();
        user.setUsername(name);
        user.setEmail(email);
        user.setPassword(password); // in futuro: hash della password

        // Prova registrazione
        boolean success = UserDAO.registerUser(user);

        if (success) {
            response.sendRedirect("index.jsp"); // login o home page
        } else {
            request.setAttribute("errorMessage", "Email già registrata o errore del database.");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}
