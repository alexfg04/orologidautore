package com.r1.ecommerceproject.servlet;



import com.r1.ecommerceproject.utils.UserSession;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserSession userSession = new UserSession(request.getSession());
        userSession.logout();

        // reindirizza al login o alla home pubblica
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}
