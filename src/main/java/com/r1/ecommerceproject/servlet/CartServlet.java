package com.r1.ecommerceproject.servlet;

import com.r1.ecommerceproject.dao.ProductDao;
import com.r1.ecommerceproject.dao.ProductDaoImpl;
import com.r1.ecommerceproject.model.ProductBean;
import com.r1.ecommerceproject.utils.UserSession;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private final ProductDao model = new ProductDaoImpl();

    // Implement methods to handle cart operations (add, remove, view, etc.)
    // For example:
    // - doGet: to view the cart
    // - doPost: to add items to the cart

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        UserSession userSession = new UserSession(request.getSession());
        try {
            // Retrieve the cart items from the session
            HashMap<ProductBean, Integer> cart = model.doGetCartAsProducts(userSession.getCart());
            request.setAttribute("cart", cart);
        } catch (SQLException e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving cart");
            return;
        }
        // Forward to the cart view page
        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession httpSession = request.getSession();
        try {
            // 1. Parse & validate parameters
            String pid = request.getParameter("product_id");
            String qty = request.getParameter("quantity");

            if (pid == null || qty == null) {
                throw new IllegalArgumentException("Missing product_id or quantity");
            }
            Long productId = Long.parseLong(pid);
            int quantity = Integer.parseInt(qty);
            if (quantity <= 0) {
                throw new IllegalArgumentException("La quantità deve essere maggiore di 0. . .");
            }

            // 2. Perform business logic
            UserSession userSession = new UserSession(httpSession);
            userSession.addProductToCart(productId, quantity);

            // 3. Store flash message in session
            httpSession.setAttribute("flashMessage", "Prodotto aggiunto al carrello con successo. .");

            // 4. Redirect to the product page (PRG)
            String context = request.getContextPath();
            response.sendRedirect(context + "/product?id=" + productId);

        } catch (IllegalArgumentException e) {
            // If parsing/validation fails, set an error message and forward back
            request.setAttribute("errorMessage", e.getMessage());
            // Forward back to the same form or product page
            request.getRequestDispatcher("/product.jsp?id=" + request.getParameter("product_id"))
                    .forward(request, response);
        }
    }
}
