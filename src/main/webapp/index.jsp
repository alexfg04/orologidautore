<%@ page contentType="text/html; charset=UTF-8" %>
<%

    List<ProductBean> products = (List<ProductBean>) request.getAttribute("products");

    if (products == null) {
        response.sendRedirect("./catalog");
        return;
    }
%>

<!DOCTYPE html>
<html>

<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*, com.r1.ecommerceproject.model.ProductBean" %>
<head>
    <title>Catalogo Prodotti</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
</head>
<body>
<%@ include file="navbar.jsp" %>

<div class="container">
    <img src="assets/img/omar-al-ghosson-N53-pozDwVE-unsplash%20(2).jpg" alt="Immagine" class="image">
    <div class="text-overlay">Compra un orologio di qualità!</div>
    <a href="FAQs.jsp"><button class="button">Aquista ora ➟</button></a>
</div>


<div class="container">
    <h2 style="display: flex; justify-content: space-between; align-items: center;">
        Catalogo Prodotti
        <a href="<%= request.getContextPath() %>/gestione">Gestione Prodotti →</a>
    </h2>
    <div class="catalog">
        <% if (products.isEmpty()) { %>
        <p>Nessun prodotto da visualizzare.</p>
        <% } else { %>
        <% for (ProductBean p : products) { %>
        <a href="product?id=<%= p.getCodiceProdotto() %>" class="product-card-link">
            <div class="product-card">
                <img src="<%= request.getContextPath() + "/" + p.getImmagine() %>" alt="Immagine di <%= p.getNome() %>">
                <h3><%= p.getNome() %></h3>
                <p><%= p.getDescrizione() %></p>
                <p class="price">€ <%= String.format("%.2f", p.getPrezzo()) %></p>
            </div>
        </a>
        <% } %>
    <% } %>
    </div>
</div>
<script src="https://unpkg.com/lucide@latest"></script>
<script>
    lucide.createIcons();
</script>
<%@ include file="footer.jsp" %>
</body>
</html>
