package com.r1.ecommerceproject.servlet.admin;

import com.r1.ecommerceproject.dao.OrderDao;
import com.r1.ecommerceproject.dao.impl.OrderDaoImpl;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet("/admin/dati-ordini-mensili")
public class DatiOrdiniMensiliServlet extends HttpServlet {

    private OrderDao orderDao;

    @Override
    public void init() throws ServletException {
        orderDao = new OrderDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        out.print("[");
        for (int mese = 1; mese <= 12; mese++) {
            try {
                int count = orderDao.countOrdersByMonth(mese);
                out.print(count);
            } catch (SQLException e) {
                e.printStackTrace();
                out.print("0");
            }
            if (mese < 12) out.print(", ");
        }
        out.print("]");
        out.flush();
    }
}
