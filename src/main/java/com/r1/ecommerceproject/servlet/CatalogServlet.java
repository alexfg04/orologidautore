package com.r1.ecommerceproject.servlet;

import com.r1.ecommerceproject.dao.ProductDao;
import com.r1.ecommerceproject.dao.ProductDaoImpl;
import com.r1.ecommerceproject.model.ProductBean;
import com.r1.ecommerceproject.utils.ProductFilter;

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

        // Se la pagina non è specificata, di default è la prima
        int page;
        if(pageParam == null) {
            page = 1;
        } else {
            page = parseIntOr(req.getParameter("page"));
        }

        // Creazione dell'istanza della classe Filtro
        ProductFilter filter = new ProductFilter();

        // Imposta i filtri in base a ciò che riceve la servlet
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

        // Recupera i prodotti divisi in pagine
        try {
            // Il metodo doRetrievePageableProducts restuisce i prodotti filtrati
            Collection<ProductBean>products = model.doRetrievePageableProducts(page, PAGE_SIZE, filter);

            // Il metodo doCountProducts il numero totale di prodotti
            int prCount = model.doCountProducts(filter);

            // totale delle pagine dei prodotti da visualizzare nel catalogo
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

    private int parseIntOr(String s) {
        try {
            return Integer.parseInt(s);
        } catch (Exception e) {
            return 1;
        }
    }
}
