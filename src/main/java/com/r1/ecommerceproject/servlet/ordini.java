package com.r1.ecommerceproject.servlet;

import com.r1.ecommerceproject.model.OrderDao;
import com.r1.ecommerceproject.model.impl.OrderDaoImpl;
import com.r1.ecommerceproject.model.OrderBean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Collection;

@WebServlet("/ordini")
public class ordini extends HttpServlet {

    private OrderDao orderDAO = new OrderDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Collection<OrderBean> ordini = orderDAO.doRetrieveAll("data_ordine DESC");
            request.setAttribute("ordini", ordini);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errore", "Errore nel recupero degli ordini.");
        }

        request.getRequestDispatcher("/ordini.jsp").forward(request, response);
    }
}

