<%@ page import="java.util.Collection" %>
<%@ page import="com.r1.ecommerceproject.model.OrderBean" %>
<%@ page import="com.r1.ecommerceproject.model.ProductBean" %>
<%@ page import="com.r1.ecommerceproject.model.AddressBean" %>
<%@ page import="com.r1.ecommerceproject.dao.OrderDao" %>
<%@ page import="com.r1.ecommerceproject.dao.impl.OrderDaoImpl" %>
<%@ page import="com.r1.ecommerceproject.utils.UserSession" %>
<%@ page import="java.sql.SQLException" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    // Controllo login
    UserSession sessioneUtente = new UserSession(request.getSession());
    if (!sessioneUtente.isLoggedIn()) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    long userId = sessioneUtente.getUserId();

    // Carico tutti gli ordini dell'utente
    OrderDao orderDao = new OrderDaoImpl();
    Collection<OrderBean> orders;
    try {
        orders = orderDao.doRetrieveAllOrdersByUserId(userId);
    } catch (SQLException e) {
        throw new RuntimeException(e);
    }
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>I miei ordini</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/catalog.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <!-- Nuovo CSS per la pagina ordini -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/orders.css">
    <script src="https://unpkg.com/lucide@latest"></script>
</head>
<body>
<%@ include file="navbar.jsp" %>

<!-- Titolo fisso in alto a sinistra -->
<h1 class="page-title">I miei ordini</h1>

<%
    // Se non ci sono ordini, mostra messaggio e termina
    if (orders.isEmpty()) {
%>
<div class="empty-wrapper">
    <div class="no-orders">Non hai effettuato ancora nessun ordine.</div>
</div>
<%@ include file="footer.jsp" %>
<%
        return;
    }
%>

<!-- Wrapper che allinea verticalmente tutte le order-card -->
<div class="orders-wrapper">
    <% for (OrderBean order : orders) {
        AddressBean addr;
        Collection<ProductBean> prods;
        try {
            addr = orderDao.doRetrieveAddress(order.getNumeroOrdine());
            prods = orderDao.doRetrieveAllProductsInOrder(order.getNumeroOrdine());
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    %>
    <div class="order-card">
        <div class="order-info">
            <p><span class="label">Numero ordine:</span> <%= order.getNumeroOrdine() %></p>
            <p><span class="label">Data ordine:</span> <%= order.getDataOrdine() %></p>
            <% if (order.getDataArrivo() != null) { %>
            <p><span class="label">Data arrivo:</span> <%= order.getDataArrivo() %></p>
            <% } %>
            <p><span class="label">Totale:</span> €<%= String.format("%.2f", order.getTotale()) %></p>
            <% if (addr != null) { %>
            <p><span class="label">Indirizzo:</span>
                <%= addr.getVia() %>, <%= addr.getCitta() %> – CAP <%= addr.getCap() %></p>
            <% } %>
            <form action="${pageContext.request.contextPath}/receipt" method="get">
                <input type="hidden" name="orderNumber" value="<%= order.getNumeroOrdine() %>">
                <button type="submit" class="btn-receipt">Mostra ricevuta</button>
            </form>
        </div>

        <div class="products-in-order">
            <% for (ProductBean p : prods) { %>
            <div class="product-card">
                <img src="<%= p.getImmagine() %>" alt="<%= p.getNome() %>">
                <div class="prod-details">
                    <h4><%= p.getNome() %></h4>
                    <p class="price">€<%= String.format("%.2f", p.getPrezzo()) %></p>
                </div>
            </div>
            <% } %>
        </div>
    </div>
    <% } %>
</div>

<script>
    lucide.createIcons();
</script>
</body>
</html>
