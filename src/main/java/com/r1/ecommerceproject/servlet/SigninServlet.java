package com.r1.ecommerceproject.servlet;

import com.r1.ecommerceproject.dao.UserDao;
import com.r1.ecommerceproject.dao.UserDaoImpl;
import com.r1.ecommerceproject.model.UserBean;
import com.r1.ecommerceproject.utils.Security;
import com.r1.ecommerceproject.utils.UserSession;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/signin")
public class SigninServlet extends HttpServlet {
    private final UserDao model = new UserDaoImpl();

    public SigninServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        UserBean user;
        UserSession userSession = new UserSession(request.getSession());

        if(userSession.getUserId() != -1) {
            request.getRequestDispatcher("/catalog").forward(request, response);
            return;
        }

        try {
            user = model.doRetrieveByEmail(email);
        } catch (SQLException e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;

        }
        if(!Security.verifyPassword(password, user.getPassword())) {
            request.setAttribute("errorMessage", "Email o password non validi");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }
        userSession.setUser(user.getId());
        userSession.setFirstName(user.getNome());
        response.sendRedirect(request.getContextPath() + "/catalog");
    }
}
