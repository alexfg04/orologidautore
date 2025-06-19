package com.r1.ecommerceproject.servlet;

import com.r1.ecommerceproject.dao.ProductDao;
import com.r1.ecommerceproject.dao.ProductDaoImpl;
import com.r1.ecommerceproject.model.ProductBean;
import com.r1.ecommerceproject.utils.ProductFilter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Collection;

@WebServlet("/catalog")
public class CatalogServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final ProductDao model = new ProductDaoImpl();
    private static final int PAGE_SIZE = 12;

    public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        // 1. Leggi parametri
        String[] types = req.getParameterValues("tipo");
        String[] colors = req.getParameterValues("colore");
        String[] sizes = req.getParameterValues("taglia");
        String priceParam = req.getParameter("prezzo");
        String sort = req.getParameter("sort");
        String pageParam = req.getParameter("page");

        int page;
        if(pageParam == null) {
            page = 1;
        } else {
            page = parseIntOr(req.getParameter("page"), 1);
        }

        ProductFilter filter = new ProductFilter();

        if (types != null) {
            filter.setTypes(types);
        }
        if (colors != null) {
            filter.setColors(colors);
        }
        if (sizes != null) {
            filter.setSizes(sizes);
        }
        if (priceParam != null && !priceParam.isEmpty()) {
            double maxPrice = Double.parseDouble(priceParam);
            if(maxPrice > 0) {
                filter.setPriceMax(maxPrice);
            }
        }
        if (sort != null && !sort.trim().isEmpty()) {
            filter.setOrderBy(sort);
        }

        try {
            Collection<ProductBean>products = model.doRetrievePageableProducts(page, PAGE_SIZE, filter);
            int prCount = model.doCountProducts(filter);
            int totalPages = prCount / PAGE_SIZE + (prCount % PAGE_SIZE == 0 ? 0 : 1);
            // set attributes
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("products", products);
        } catch (SQLException e) {
            res.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving products" + e.getMessage() );
            return;
        }

        req.getRequestDispatcher("/catalog.jsp")
                .forward(req, res);
    }

    private int parseIntOr(String s, int def) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return def;
        }
    }
}
