package com.r1.ecommerceproject.servlet;



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

        HttpSession session = request.getSession(false); // prendi la sessione, se esiste
        if (session != null) {
            session.invalidate(); // elimina la sessione, quindi logout
        }

        // reindirizza al login o alla home pubblica
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}
