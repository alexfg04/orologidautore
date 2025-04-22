package com.r1.ecommerceproject.servlet;

import com.r1.ecommerceproject.dao.UserDAO;
import com.r1.ecommerceproject.model.User;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Impostare la codifica dei caratteri
        request.setCharacterEncoding("UTF-8");

        // Recupera i parametri dalla request
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // Verifica se i parametri sono presenti
        if (email == null || email.isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("errorMessage", "Email e password sono obbligatori.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // Chiamata al DAO per autenticare l'utente
        User user = UserDAO.authenticate(email, password);

        // Se l'utente è autenticato
        if (user != null) {
            // Crea una sessione per l'utente
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            // Redirige alla pagina principale (index.jsp)
            response.sendRedirect("index.jsp");
        } else {
            // Se le credenziali sono errate, mostra un messaggio di errore
                request.setAttribute("errorMessage", "Credenziali errate! Controlla email e password.");
                request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
