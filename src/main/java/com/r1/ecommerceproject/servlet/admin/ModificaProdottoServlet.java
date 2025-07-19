package com.r1.ecommerceproject.servlet.admin;

import com.r1.ecommerceproject.dao.ProductDao;
import com.r1.ecommerceproject.dao.impl.ProductDaoImpl;
import com.r1.ecommerceproject.model.ProductBean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/modificaProdotto")
public class ModificaProdottoServlet extends HttpServlet {

    private ProductDao productDao;

    @Override
    public void init() throws ServletException {
        productDao = new ProductDaoImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            long id = Long.parseLong(request.getParameter("id"));
            ProductBean prodotto = productDao.doRetrieveById(id);
            if (prodotto == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Prodotto non trovato");
                return;
            }
            request.setAttribute("prodotto", prodotto);
            request.getRequestDispatcher("/admin/gestioneProdotto.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Parametri errati");
        }
    }
}

