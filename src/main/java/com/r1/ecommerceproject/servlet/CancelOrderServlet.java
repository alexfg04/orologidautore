package com.r1.ecommerceproject.servlet;

import com.r1.ecommerceproject.model.OrderDao;
import com.r1.ecommerceproject.model.impl.OrderDaoImpl;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/cancel")
public class CancelOrderServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String orderIdParam = request.getParameter("orderId");
        if (orderIdParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Order ID mancante");
            return;
        }
        try {
            long orderId = Integer.parseInt(request.getParameter("orderId"));
            OrderDao orderDao = new OrderDaoImpl();
            orderDao.doDelete(orderId);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Order ID non valido");
            return;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        response.sendRedirect(request.getContextPath() + "/checkout_failure.jsp");
    }
}
