<%--
  Created by IntelliJ IDEA.
  User: ALEFG
  Date: 15/04/2025
  Time: 4:30 pm
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, com.r1.ecommerceproject.model.ProductBean" %>
<%
    HashMap<ProductBean, Integer> cartItems = (HashMap<ProductBean, Integer>) request.getAttribute("cart");

    if (cartItems == null) {
        response.sendRedirect("./cart");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Carrello</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cart.css">
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
<% if (cartItems.isEmpty()) { %>
<div class="empty-cart">
    <h2>Il carrello è vuoto</h2>
    <p>Non hai ancora aggiunto nessun prodotto al carrello.</p>
</div>
<% } else { %>
<% double totalPrice = new UserSession(session).getCartTotal(); %>
<div class="cart-container">
    <div class="container product-container">
        <h2 style="display: flex; justify-content: space-between; align-items: center;">
            Carrello
        </h2>

        <div class="cart">
            <% for (ProductBean p : cartItems.keySet()) { %>
            <div class="cart-item" id="item_<%= p.getCodiceProdotto() %>">
                <img src="<%= request.getContextPath() + "/" + p.getImmagine() %>" alt="Immagine di <%= p.getNome() %>">
                <div class="item-details">
                    <h3><%= p.getNome() %>
                    </h3>
                    <p><%= p.getDescrizione() %>
                    </p>
                    <p class="price">€ <%= String.format("%.2f", p.getPrezzo()) %>
                    </p>
                </div>
                <div class="quantity-control">
                    <label for="quantity_<%= p.getCodiceProdotto() %>">Quantità:</label>
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
        <div class="total">
            <p><strong>€ <%= String.format("%.2f", totalPrice) %>
            </strong></p>
        </div>
        <button class="button">Acquista ➟</button>
    </div>
    <% } %>
</div>
<script>
    lucide.createIcons();
</script>
<script src="${pageContext.request.contextPath}/assets/js/cart.js"></script>
<%@ include file="footer.jsp" %>
</body>
</html>