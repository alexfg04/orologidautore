<%--
  Created by IntelliJ IDEA.
  User: ALEFG
  Date: 15/04/2025
  Time: 4:30 pm
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, com.r1.ecommerceproject.model.ProductBean" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.math.RoundingMode" %>
<%
    HashMap<ProductBean, Integer> cartItems = (HashMap<ProductBean, Integer>) request.getAttribute("cart");

    if (cartItems == null) {
        response.sendRedirect("./cart");
        return;
    }

    // Definisco l'aliquota IVA del 22%
    final BigDecimal VAT_RATE = new BigDecimal("0.22");
    UserSession user = new UserSession(session);
    // Totale netto già calcolato dalla sessione
    BigDecimal totalNet = user.getCartTotaleNetto();
    // Totale lordo = netto * (1 + VAT_RATE)
    BigDecimal totalGross = user.getCartTotaleLordo();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Carrello</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fonts.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cart.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <script src="https://unpkg.com/lucide@latest"></script>
</head>
<body>
<%@ include file="navbar.jsp" %>
<%
    String errorMessage = (String) request.getAttribute("errorMessage");
    if ((errorMessage != null && !errorMessage.isEmpty())) {
%>
<div id="errorNotification" class="error-notification danger">
    <%= errorMessage %>
    <span class="close">×</span>
</div>
<%
        session.removeAttribute("flashMessage");
    }
%>
<main class="content">
<% if (cartItems.isEmpty()) { %>
<div class="empty-cart">
    <h2>Il carrello è vuoto</h2>
    <p>Non hai ancora aggiunto nessun prodotto al carrello.</p>
</div>
<% } else { %>
<div class="cart-container">
    <div class="container product-container">
        <h2 style="display: flex; justify-content: space-between; align-items: center;">
            Carrello (<%= cartItems.size() %> articoli)

        </h2>

        <div class="cart">
            <% for (ProductBean p : cartItems.keySet()) { %>
            <div class="cart-item" id="item_<%= p.getCodiceProdotto() %>">
                <img src="<%= p.getImmagine() %>" alt="Immagine di <%= p.getNome() %>">
                <div class="item-details">
                    <h3><%= p.getNome() %>
                    </h3>
                    <p><%= p.getDescrizione() %>
                    </p>
                    <p class="price">€ <%= String.format("%.2f", p.getPrezzo()) %>
                    </p>
                </div>
                <div class="quantity-control">
                    <label for="quantity_<%= p.getCodiceProdotto() %>"></label>
                    <input type="number" id="quantity_<%= p.getCodiceProdotto() %>"
                           class="quantity-input" min="1" value="<%= cartItems.get(p) %>"
                           data-product-id="<%= p.getCodiceProdotto() %>">
                    <input type="hidden" id="price_<%= p.getCodiceProdotto() %>" value="<%= p.getPrezzo() %>">
                    <div class="spinner" id="spinner-<%= p.getCodiceProdotto() %>"></div>
                </div>
                <div class="remove-icon" data-product-id="<%= p.getCodiceProdotto() %>">
                    <i data-lucide="trash-2"></i>
                </div>

            </div>
            <% } %>
        </div>
    </div>
    <div class="container checkout">
        <h1>Totale: </h1>
        <table class="total-summary">
            <tr>
                <td>Totale netto:</td>
                <td class="amount">€ <%= String.format("%.2f", totalNet.setScale(2, RoundingMode.HALF_UP)) %></td>
            </tr>
            <tr>
                <td>IVA (22%):</td>
                <td class="amount">
                    € <%= String.format("%.2f", totalNet.multiply(VAT_RATE).setScale(2, RoundingMode.HALF_UP)) %>
                </td>
            </tr>
            <tr class="grand-total">
                <td><strong>Totale lordo:</strong></td>
                <td class="amount"><strong>€ <%= String.format("%.2f", totalGross) %></strong></td>
            </tr>
        </table>
        <form action="${pageContext.request.contextPath}/checkout" method="post">
            <button type="submit" class="button">Acquista ➟</button>
        </form>
        <div class="payment-methods">
            <p>Modalità di pagamento disponibili:</p>
            <div class="payment-logos">
                <div class="payment-logo">
                    <img src="${pageContext.request.contextPath}/assets/img/logo-paypal.png"
                         alt="PayPal">
                </div>
                <!-- Se in futuro vorrai aggiungere altre modalità, duplica questo blocco -->
            </div>
        </div>
    </div>
    <% } %>
</div>
</main>
<script>
    lucide.createIcons();
</script>
<script src="${pageContext.request.contextPath}/assets/js/cart.js"></script>
<%@ include file="footer.jsp" %>
</body>
</html>