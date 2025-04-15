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
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private final ProductDao model = new ProductDaoImpl();

    public CartServlet() {
        super();
    }

    // Implement methods to handle cart operations (add, remove, view, etc.)
    // For example:
    // - doGet: to view the cart
    // - doPost: to add items to the cart
    // - doDelete: to remove items from the cart

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
        UserSession userSession = new UserSession(request.getSession());

        Long productId = Long.parseLong(request.getParameter("product_id"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        userSession.addProductToCart(productId, quantity);
        request.setAttribute("message", "Product added to cart successfully.");
        response.sendRedirect(request.getContextPath() + "/product?id=" + productId);
    }
}
