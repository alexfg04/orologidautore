package com.r1.ecommerceproject.servlet;

import com.r1.ecommerceproject.model.UserDao;
import com.r1.ecommerceproject.model.impl.UserDaoImpl;
import com.r1.ecommerceproject.model.UserBean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/ForgotPasswordServlet")
public class RecoverPasswordServlet extends HttpServlet {
    private final UserDao userDao = new UserDaoImpl();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");

        try {
            UserBean user = userDao.doRetrieveByEmail(email);
            if (user != null) {
                request.setAttribute("passwordRecuperata", user.getPassword());
            } else {
                request.setAttribute("errore", "Utente non trovato.");
            }
        } catch (Exception e) {
            request.setAttribute("errore", "Errore durante il recupero.");
        }

        request.getRequestDispatcher("password-recovery-result.jsp").forward(request, response);
    }
}
