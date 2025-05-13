package com.r1.ecommerceproject.utils;

import com.r1.ecommerceproject.dao.ProductDao;
import com.r1.ecommerceproject.dao.ProductDaoImpl;

import javax.servlet.http.HttpSession;
import java.util.HashMap;

public class UserSession {
    private final String SESSION_CART_ATTRIBUTE = "cart";
    private final String SESSION_ADMIN_ATTRIBUTE = "admin";
    private final String SESSION_USER_ID_ATTRIBUTE = "userId";
    private final String SESSION_CART_TOTAL_ATTRIBUTE = "cartTotal";
    private final HttpSession session;

    public UserSession(HttpSession session) {
        this.session = session;
    }

    public HashMap<Long, Integer> getCart() {
        if (session.getAttribute(SESSION_CART_ATTRIBUTE) == null) {
            session.setAttribute(SESSION_CART_ATTRIBUTE, new HashMap<Long, Integer>());
            //
        }
        return (HashMap<Long, Integer>) session.getAttribute(SESSION_CART_ATTRIBUTE);
    }

    public void addProductToCart(Long productId, int quantity) {
        HashMap<Long, Integer> cart = getCart();
        // If the product is already in the cart, update the quantity
        cart.merge(productId, quantity, Integer::sum);
        session.setAttribute(SESSION_CART_ATTRIBUTE, cart);
        computeTotal();
    }

    public void updateProductInCart(Long productId, int quantity) {
        HashMap<Long, Integer> cart = getCart();
        if (quantity > 0) {
            cart.put(productId, quantity);
        } else {
            cart.remove(productId);
        }
        computeTotal();
    }

    public void removeProductFromCart(Long productId) {
        if (session.getAttribute(SESSION_CART_ATTRIBUTE) != null) {
            HashMap<Long, Integer> cart = getCart();
            cart.remove(productId);
            session.setAttribute(SESSION_CART_ATTRIBUTE, cart);
        }
        computeTotal();
    }

    public void logout() {
        session.removeAttribute(SESSION_USER_ID_ATTRIBUTE);
    }

    public long getUserId() {
        return session.getAttribute(SESSION_USER_ID_ATTRIBUTE) != null ? (long) session.getAttribute(SESSION_USER_ID_ATTRIBUTE) : -1;
    }

    public void setUser(long id) {
        session.setAttribute(SESSION_USER_ID_ATTRIBUTE, id);
    }

    public boolean isAdmin() {
        return session.getAttribute(SESSION_ADMIN_ATTRIBUTE) != null;
    }

    public void setAdmin(boolean admin) {
        session.setAttribute(SESSION_ADMIN_ATTRIBUTE, admin);
    }

    public void clearCart() {
        session.removeAttribute(SESSION_CART_ATTRIBUTE);
    }

    public long getCartSize() {
        return session.getAttribute(SESSION_CART_ATTRIBUTE) != null ? ((HashMap<Long, Integer>) session.getAttribute(SESSION_CART_ATTRIBUTE)).size() : 0;
    }

    public void computeTotal() {
        ProductDao model = new ProductDaoImpl();
        double total = 0.0;

        if (session.getAttribute(SESSION_CART_ATTRIBUTE) != null) {
            HashMap<Long, Integer> cart = getCart();
            for (Long productId : cart.keySet()) {
                try {
                    total += model.doRetrieveById(productId).getPrezzo() * cart.get(productId);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        this.setCartTotal(total);
    }

    public void setCartTotal(double total) {
        session.setAttribute(SESSION_CART_TOTAL_ATTRIBUTE, total);
    }

    public double getCartTotal() {
        return session.getAttribute(SESSION_CART_TOTAL_ATTRIBUTE) != null ? (double) session.getAttribute(SESSION_CART_TOTAL_ATTRIBUTE) : 0;
    }
}


