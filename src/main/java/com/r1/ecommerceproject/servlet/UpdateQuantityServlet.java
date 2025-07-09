package com.r1.ecommerceproject.servlet;

import com.r1.ecommerceproject.utils.UserSession;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/updateQuantity")
public class UpdateQuantityServlet extends HttpServlet  {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        HttpSession httpSession = request.getSession();
        try {
            // 1. Parse & validate parameters
            String pid = request.getParameter("productId");
            String qty = request.getParameter("quantity");
            if (pid == null || qty == null) {
                throw new IllegalArgumentException("Missing product_id or quantity");
            }
            Long productId = Long.parseLong(pid);
            int quantity = Integer.parseInt(qty);
            if (quantity <= 0) {
                throw new IllegalArgumentException("La quantità deve essere maggiore di 0. . .");
            }

            // 2. Perform business logic
            UserSession userSession = new UserSession(httpSession);
            userSession.updateProductInCart(productId, quantity);
            BigDecimal total = userSession.getCartTotal();

            // return json
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": \"true\", \"total\": " + total + "}");
            response.getWriter().flush();

        } catch (IllegalArgumentException e) {
            response.setContentType("application/json");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"status\": \"error\", \"message\": \"" + e.getMessage() + "\"}");
        }
    }
}
