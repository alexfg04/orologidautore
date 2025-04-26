package com.r1.ecommerceproject.servlet;

import com.r1.ecommerceproject.utils.UserSession;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/removeFromCart")
public class RemoveFromCart extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Long id = Long.parseLong(request.getParameter("productId"));
        UserSession userSession = new UserSession(request.getSession());
        userSession.removeProductFromCart(id);
        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
