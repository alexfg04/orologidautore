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
<% if (cartItems.isEmpty()) { %>
<div class="empty-cart">
    <h2>Il carrello è vuoto</h2>
    <p>Non hai ancora aggiunto nessun prodotto al carrello.</p>
</div>
<% } else { %>
<% double totalPrice = 0; %>
<div class="cart-area">
    <div class="container">
        <h2 style="display: flex; justify-content: space-between; align-items: center;">
            Carrello
        </h2>

        <div class="cart">
            <% for (ProductBean p : cartItems.keySet()) { %>
            <div class="cart-item">
                <img src="<%= request.getContextPath() + "/" + p.getImmagine() %>" alt="Immagine di <%= p.getNome() %>">
                <div class="item-details">
                    <h3><%= p.getNome() %>
                    </h3>
                    <p><%= p.getDescrizione() %>
                    </p>
                    <p class="price">€ <%= String.format("%.2f", p.getPrezzo()) %>
                    </p>
                </div>
                <form action="<%= request.getContextPath() %>/updateQuantity" method="post">
                    <input type="hidden" name="productId" value="<%= p.getCodiceProdotto() %>">
                    <label for="quantity_<%= p.getCodiceProdotto() %>">Quantità:</label>
                    <input type="number" id="quantity_<%= p.getCodiceProdotto() %>" name="quantity" min="1"
                           value="<%= cartItems.get(p) %>">
                    <button type="submit" class="update-button">Aggiorna Quantità</button>
                </form>
                <form action="<%= request.getContextPath() %>/removeFromCart" method="post">
                    <input type="hidden" name="productId" value="<%= p.getCodiceProdotto() %>">
                    <button type="submit" class="remove-button">Rimuovi</button>
                </form>
            </div>
            <% totalPrice += p.getPrezzo() * cartItems.get(p); %>
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
<%@ include file="footer.jsp" %>
</body>
</html>