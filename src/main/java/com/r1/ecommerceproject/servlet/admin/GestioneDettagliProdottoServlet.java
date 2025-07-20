package com.r1.ecommerceproject.servlet.admin;

import com.r1.ecommerceproject.model.ProductDao;
import com.r1.ecommerceproject.model.impl.ProductDaoImpl;
import com.r1.ecommerceproject.model.ProductBean;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/gestioneDettagliProdotto")
public class GestioneDettagliProdottoServlet extends HttpServlet {

    private ProductDao productDao = new ProductDaoImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Long codiceProdotto = Long.parseLong(request.getParameter("codiceProdotto"));
            ProductBean prodotto = productDao.doRetrieveById(codiceProdotto);

            request.setAttribute("prodotto", prodotto);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/admin/gestioneProdotto.jsp");
            dispatcher.forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("messaggioErrore", "Errore durante il recupero dei dettagli del prodotto.");
            request.getRequestDispatcher("/errore.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.setAttribute("messaggioErrore", "Codice prodotto non valido.");
            request.getRequestDispatcher("/errore.jsp").forward(request, response);
        }
    }
}
