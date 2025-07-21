package com.r1.ecommerceproject.servlet.admin;

import com.r1.ecommerceproject.model.OrderBean;
import com.r1.ecommerceproject.model.OrderDao;
import com.r1.ecommerceproject.model.ProductBean;
import com.r1.ecommerceproject.model.impl.OrderDaoImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Collection;

@WebServlet("/admin/orderDetails")
public class OrderDetailsServlet extends HttpServlet {

    private final OrderDao orderDao = new OrderDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String numeroOrdine = request.getParameter("numeroOrdine");
        if (numeroOrdine == null || numeroOrdine.isBlank()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Numero ordine mancante");
            return;
        }

        try {
            OrderBean ordine = orderDao.doRetrieveById(numeroOrdine);
            if (ordine == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Ordine non trovato");
                return;
            }

            Collection<ProductBean> prodotti = orderDao.doRetrieveAllProductsInOrder(numeroOrdine);
            request.setAttribute("ordine", ordine);
            request.setAttribute("prodotti", prodotti);
            request.getRequestDispatcher("/WEB-INF/views/admin/orderDetails.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Errore durante il recupero dell'ordine");
        }
    }
}
