package com.r1.ecommerceproject.utils;

import javax.servlet.http.HttpSession;
import java.util.HashMap;

public class UserSession {
    private final String SESSION_CART_ATTRIBUTE = "cart";
    private final String SESSION_USER_ATTRIBUTE = "user";
    private final String SESSION_ADMIN_ATTRIBUTE = "admin";
    private final String SESSION_USER_ID_ATTRIBUTE = "userId";
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
    }

    public void removeProductFromCart(Long productId) {
        if (session.getAttribute(SESSION_CART_ATTRIBUTE) != null) {
            HashMap<Long, Integer> cart = getCart();
            // If the product is in the cart, remove it, otherwise decrease the quantity
            cart.computeIfPresent(productId, (k, v) -> v - 1 <= 0 ? null : v - 1);
            session.setAttribute(SESSION_CART_ATTRIBUTE, cart);
        }
    }

    public void logout() {
        session.invalidate();
    }

    public long getUserId() {
        return session.getAttribute(SESSION_USER_ID_ATTRIBUTE) != null ? (long) session.getAttribute(SESSION_USER_ID_ATTRIBUTE) : -1;
    }
}
