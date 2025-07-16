package com.r1.ecommerceproject.servlet.admin;

import com.r1.ecommerceproject.dao.impl.ProductDaoImpl;
import com.r1.ecommerceproject.model.ProductBean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Collection;

import static com.r1.ecommerceproject.utils.Utils.escapeJson;

@WebServlet("/admin/products")
public class ProductListServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("✅ [SERVLET] Richiesta ricevuta su /admin/products");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String orderBy = request.getParameter("orderBy");
        if (orderBy == null || orderBy.trim().isEmpty()) {
            orderBy = "nome ASC"; // default order
        }

        Collection<ProductBean> products;
        try {
            products = new ProductDaoImpl().doRetrieveAll(orderBy);
            System.out.println("✅ [SERVLET] Prodotti recuperati dal database: " + products.size());
        } catch (SQLException e) {
            System.err.println("❌ [SERVLET] Errore durante l'accesso al database:");
            e.printStackTrace();

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"DB_ERROR\",\"message\":\"Errore accesso database\"}");
            return;
        }

        try {
            StringBuilder json = new StringBuilder();
            json.append("[");

            int i = 0;
            for (ProductBean p : products) {
                json.append("{")
                        .append("\"codiceProdotto\":").append(p.getCodiceProdotto()).append(",") // <--- qui
                        .append("\"nome\":\"").append(escapeJson(p.getNome())).append("\",")
                        .append("\"marca\":\"").append(escapeJson(p.getMarca())).append("\",")
                        .append("\"categoria\":\"").append(escapeJson(p.getGenere())).append("\",")
                        .append("\"taglia\":\"").append(escapeJson(p.getTaglia())).append("\",")
                        .append("\"prezzo\":").append(p.getPrezzo()).append(",")
                        .append("\"modello\":\"").append(escapeJson(p.getModello())).append("\",")
                        .append("\"descrizione\":\"").append(escapeJson(p.getDescrizione())).append("\",")
                        .append("\"materiale\":\"").append(escapeJson(p.getMateriale())).append("\",")
                        .append("\"image_url\":\"").append(escapeJson(p.getImmagine())).append("\"")
                        .append("}");
                i++;
                if (i < products.size()) {
                    json.append(",");
                }
            }

            json.append("]");
            System.out.println("📤 [SERVLET] Risposta JSON generata: " + json);

            response.getWriter().write(json.toString());

        } catch (Exception e) {
            System.err.println("❌ [SERVLET] Errore nella costruzione della risposta JSON:");
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"JSON_ERROR\",\"message\":\"Errore nel generare JSON\"}");
        }
    }
}
