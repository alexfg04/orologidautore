package com.r1.ecommerceproject.servlet;

import com.r1.ecommerceproject.model.ProductBean;
import com.r1.ecommerceproject.dao.ProductDaoImpl; // Importa la tua implementazione DAO
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException; // Importa SQLException per la gestione degli errori del DAO
import java.util.HashMap;
import java.util.Map; // Usiamo Map per il tipo generico

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    @SuppressWarnings("unchecked")
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 1. Recupera il carrello dalla sessione (HashMap<Long, Integer>)
        HashMap<Long, Integer> cartItemsFromSession =
                (HashMap<Long, Integer>) session.getAttribute("cart");

        // Assicurati che il carrello non sia nullo o vuoto prima di procedere
        if (cartItemsFromSession == null || cartItemsFromSession.isEmpty()) {
            // Reindirizza alla pagina del carrello se vuoto
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        // 2. Utilizza il tuo ProductDaoImpl per ottenere i ProductBean completi
        ProductDaoImpl productDAO = new ProductDaoImpl(); // Istanzia la tua DAO
        Map<ProductBean, Integer> productQuantitiesForJSP; // Useremo Map come tipo generico

        try {
            // Chiamiamo il metodo doGetCartAsProducts della tua DAO
            productQuantitiesForJSP = productDAO.doGetCartAsProducts(cartItemsFromSession);

            // Se dopo la conversione il carrello risulta vuoto (es. prodotti non trovati)
            if (productQuantitiesForJSP.isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

            // 3. Calcola il totale basandoti sulla Map con ProductBean
            double totalPrice = 0.0;
            for (Map.Entry<ProductBean, Integer> entry : productQuantitiesForJSP.entrySet()) {
                totalPrice += entry.getKey().getPrezzo() * entry.getValue();
            }

            // 4. Imposta gli attributi nella request per il JSP
            // Passiamo la HashMap con i ProductBean completi
            request.setAttribute("cartItems", productQuantitiesForJSP);
            // Passiamo il totale calcolato
            request.setAttribute("totalPrice", totalPrice);

            // 5. Inoltra alla pagina di completamento ordine
            request.getRequestDispatcher("/completa_ordine.jsp").forward(request, response);

        } catch (SQLException e) {
            // Gestione dell'errore se qualcosa va storto con il database
            e.printStackTrace(); // Stampa lo stack trace per debug
            request.setAttribute("errorMessage", "Errore durante il recupero dei prodotti del carrello. Riprova più tardi.");
            // Potresti voler reindirizzare l'utente a una pagina di errore o al carrello con il messaggio
            response.sendRedirect(request.getContextPath() + "/cart?error=db");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}