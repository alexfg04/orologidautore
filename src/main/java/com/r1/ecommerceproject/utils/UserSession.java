package com.r1.ecommerceproject.utils;

import com.r1.ecommerceproject.model.ProductDao;
import com.r1.ecommerceproject.model.impl.ProductDaoImpl;
import com.r1.ecommerceproject.model.ProductBean;

import javax.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.util.Collection;
import java.util.HashMap;
import java.util.Set;
import java.util.HashSet;

public class UserSession {
    private final String SESSION_CART_ATTRIBUTE = "cart";
    private final String SESSION_ADMIN_ATTRIBUTE = "admin";
    private final String SESSION_USER_ID_ATTRIBUTE = "userId";
    private final String SESSION_CART_TOTALE_NETTO_ATTRIBUTE = "cartTotalNet";
    private final String SESSION_CART_TOTALE_LORDO_ATTRIBUTE = "cartTotalGross";
    private final HttpSession session;
    private final String FAVORITES_ATTRIBUTE = "favorites";
    private final String SESSION_FIRSTNAME_ATTRIBUTE = "firstName";
    private final String SESSION_LASTNAME_ATTRIBUTE = "lastName";

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
        session.removeAttribute(SESSION_FIRSTNAME_ATTRIBUTE);
        session.removeAttribute(SESSION_LASTNAME_ATTRIBUTE);
    }

    public long getUserId() {
        return session.getAttribute(SESSION_USER_ID_ATTRIBUTE) != null ? (long) session.getAttribute(SESSION_USER_ID_ATTRIBUTE) : -1L;
    }

    public boolean isLoggedIn() {
        return session.getAttribute(SESSION_USER_ID_ATTRIBUTE) != null;
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
        BigDecimal totaleNetto = BigDecimal.ZERO;
        BigDecimal totaleLordo = BigDecimal.ZERO;

        if (session.getAttribute(SESSION_CART_ATTRIBUTE) != null) {
            HashMap<Long, Integer> cart = getCart();
            for (Long productId : cart.keySet()) {
                try {
                    ProductBean product = model.doRetrieveById(productId);
                    product.setQuantity(cart.get(productId));
                    totaleNetto = totaleNetto.add(product.getSubtotaleNetto());
                    totaleLordo = totaleLordo.add(product.getSubtotale());
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        }
        this.setCartTotaleNetto(totaleNetto);
        this.setCartTotaleLordo(totaleLordo);
    }

    public void setCartTotaleNetto(BigDecimal total) {
        session.setAttribute(SESSION_CART_TOTALE_NETTO_ATTRIBUTE, total);
    }

    public BigDecimal getCartTotaleNetto() {
        return session.getAttribute(SESSION_CART_TOTALE_NETTO_ATTRIBUTE) != null ? (BigDecimal) session.getAttribute(SESSION_CART_TOTALE_NETTO_ATTRIBUTE) : BigDecimal.ZERO;
    }

    public void setCartTotaleLordo(BigDecimal total) {
        session.setAttribute(SESSION_CART_TOTALE_LORDO_ATTRIBUTE, total);
    }

    public BigDecimal getCartTotaleLordo() {
        return session.getAttribute(SESSION_CART_TOTALE_LORDO_ATTRIBUTE) != null ? (BigDecimal) session.getAttribute(SESSION_CART_TOTALE_LORDO_ATTRIBUTE) : BigDecimal.ZERO;
    }


    @SuppressWarnings("unchecked")
    public Set<Long> getFavorites() {
        Set<Long> fav = (Set<Long>) session.getAttribute(FAVORITES_ATTRIBUTE);
        if (fav == null) {
            fav = new HashSet<>();
            session.setAttribute(FAVORITES_ATTRIBUTE, fav);
        }
        return fav;
    }

    /*Aggiunge un prodotto ai preferiti in sessione.
     Se il prodotto è già presente, non viene duplicato*/
    public void addFavorite(long productId) {
        Set<Long> fav = getFavorites();
        if (fav.add(productId)) {
            session.setAttribute(FAVORITES_ATTRIBUTE, fav);
        }
    }

    /* Rimuove un prodotto dai preferiti in sessione.*/
    public void removeFavorite(long productId) {
        Set<Long> fav = getFavorites();
        if (fav.remove(productId)) {
            session.setAttribute(FAVORITES_ATTRIBUTE, fav);
        }
    }

    public boolean isFavorite(long productId) {
        Set<Long> fav = getFavorites();
        return fav.contains(productId);
    }

    /*Rimuove tutti i preferiti*/
    public void clearFavorites() {
        session.removeAttribute(FAVORITES_ATTRIBUTE);
    }

    /*Restituisce il numero di preferiti.*/
    public int getFavoritesCount() {
        return getFavorites().size();
    }

    public void putAllFavoritesToSession() {
        ProductDao favoriteDao = new ProductDaoImpl();
        try {
            Collection<ProductBean> all = favoriteDao.doRetrieveAllFavorites(null, this.getUserId());

            for (ProductBean product : all) {                                     //aggiungiamo tutti i preferiti associati all'utente nella sessione
                this.addFavorite(product.getCodiceProdotto());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    //metodo di set per firstName
    public void setFirstName(String firstName) {
        session.setAttribute(SESSION_FIRSTNAME_ATTRIBUTE, firstName);
    }

    //metodo di get per firstName
    public String getFirstName() {
        Object attr = session.getAttribute(SESSION_FIRSTNAME_ATTRIBUTE);
        return attr != null ? (String) attr : null;
    }

    //metodo di set per lastName
    public void setLastName(String lastName) {
        session.setAttribute(SESSION_LASTNAME_ATTRIBUTE, lastName);
    }

    //metodo di get per lastName
    public String getLastName() {
        Object attr = session.getAttribute(SESSION_LASTNAME_ATTRIBUTE);
        return attr != null ? (String) attr : null;
    }

    public void setEmail(String email) {
        session.setAttribute("email", email);
    }

    public String getEmail() {
        Object attr = session.getAttribute("email");
        return attr != null ? (String) attr : null;
    }
}


