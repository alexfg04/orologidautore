<%--
  Created by IntelliJ IDEA.
  User: ALEFG
  Date: 15/04/2025
  Time: 4:30 pm
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
  HashMap<ProductBean, Integer> cartItems = (HashMap<ProductBean, Integer>) request.getAttribute("cart");
%>

<!DOCTYPE html>
<html>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*, com.r1.ecommerceproject.model.ProductBean" %>
<head>
  <title>Carrello</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/cartStyle.css">
</head>
<body>
<div class="container">
  <h2 style="display: flex; justify-content: space-between; align-items: center;">
    Carrello
    <a href="<%= request.getContextPath() %>/catalog">Vai al Catalogo →</a>
  </h2>

  <div class="cart">
    <% if (cartItems.isEmpty()) { %>
    <p>Il tuo carrello è vuoto.</p>
    <% } else { %>
    <% double totalPrice = 0; %>
    <% for (ProductBean p : cartItems.keySet()) { %>
    <div class="cart-item">
      <img src="<%= request.getContextPath() + "/" + p.getImmagine() %>" alt="Immagine di <%= p.getNome() %>">
      <div class="item-details">
        <h3><%= p.getNome() %></h3>
        <p><%= p.getDescrizione() %></p>
        <p class="price">€ <%= String.format("%.2f", p.getPrezzo()) %></p>
      </div>
      <form action="<%= request.getContextPath() %>/updateQuantity" method="post">
        <input type="hidden" name="productId" value="<%= p.getCodiceProdotto() %>">
        <label for="quantity_<%= p.getCodiceProdotto() %>">Quantità:</label>
        <input type="number" id="quantity_<%= p.getCodiceProdotto() %>" name="quantity" min="1" value="<%= cartItems.get(p) %>">
        <button type="submit" class="update-button">Aggiorna Quantità</button>
      </form>
      <form action="<%= request.getContextPath() %>/removeFromCart" method="post">
        <input type="hidden" name="productId" value="<%= p.getCodiceProdotto() %>">
        <button type="submit" class="remove-button">Rimuovi</button>
      </form>
    </div>
    <% totalPrice += p.getPrezzo() * cartItems.get(p); %>
    <% } %>

    <div class="total">
      <p><strong>Totale: € <%= String.format("%.2f", totalPrice) %></strong></p>
    </div>
    <% } %>
  </div>
</div>

<%@ include file="footer.jsp" %>
</body>
</html>
