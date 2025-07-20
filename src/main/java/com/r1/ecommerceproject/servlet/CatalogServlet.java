package com.r1.ecommerceproject.servlet;

import com.r1.ecommerceproject.model.ProductDao;
import com.r1.ecommerceproject.model.impl.ProductDaoImpl;
import com.r1.ecommerceproject.model.ProductBean;
import com.r1.ecommerceproject.utils.GenderFilter;
import com.r1.ecommerceproject.utils.GenericFilter;
import com.r1.ecommerceproject.utils.PriceMaxFilter;
import com.r1.ecommerceproject.utils.ProductFilter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.*;

@WebServlet("/catalog")
public class CatalogServlet extends HttpServlet {
    private static final ProductDao model = new ProductDaoImpl();
    private static final int PAGE_SIZE = 12;

    public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
        // 1. Leggi parametri
        String[] typesParam = req.getParameterValues("tipo");
        String[] brandsParam = req.getParameterValues("brand");
        String[] materialsParam = req.getParameterValues("materiale");
        String genderParam = req.getParameter("gender");
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
        List<String> types     = typesParam     != null ? Arrays.asList(typesParam)     : Collections.emptyList();
        List<String> brands    = brandsParam   != null ? Arrays.asList(brandsParam)    : Collections.emptyList();
        List<String> materials = materialsParam != null ? Arrays.asList(materialsParam) : Collections.emptyList();

        // Inizializzazione del Builder con i filtri
        ProductFilter.Builder basedFilter = new ProductFilter.Builder()
                .addFilter(new GenericFilter(types, "tipo"))
                .addFilter(new GenericFilter(brands,"marca"))
                .addFilter(new GenericFilter(materials, "materiale"))
                .addFilter(new PriceMaxFilter(new BigDecimal(priceParam == null ? "0" : priceParam)))
                .addFilter(new GenderFilter(genderParam));

        // Filtro senza limit e offset
        ProductFilter filter = basedFilter.build();

        // Filtro completo
        ProductFilter pagedFilter = basedFilter
                .orderBy(sort)
                .limit(PAGE_SIZE)
                .offset(PAGE_SIZE * (page - 1))
                .build();

        // Recupera i prodotti divisi in pagine
        try {
            // Il metodo doRetrievePageableProducts restuisce i prodotti filtrati
            Collection<ProductBean>products = model.doRetrievePageableProducts(pagedFilter);

            // Il metodo doCountProducts il numero totale di prodotti
            int prCount = model.doCountProducts(filter);

            // totale delle pagine dei prodotti da visualizzare nel catalogo
            int totalPages = prCount / PAGE_SIZE + (prCount % PAGE_SIZE == 0 ? 0 : 1);
            // set attributes
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("products", products);
        } catch (SQLException e) {
            res.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving products: " + e.getMessage());
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
