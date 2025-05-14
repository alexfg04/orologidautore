<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.*, com.r1.ecommerceproject.model.ProductBean" %>
<%

    List<ProductBean> products = (List<ProductBean>) request.getAttribute("products");

    if (products == null) {
        response.sendRedirect("./catalog");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Catalogo Prodotti</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/body.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/marche.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/PreviewFooter.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
</head>
<body>
<%@ include file="navbar.jsp" %>

<div class="container">
    <img src="assets/img/header_image.jpg" alt="Immagine" class="image">
    <div class="text-overlay">Compra un orologio di qualità!</div>
    <a href="FAQs.jsp"><button class="button">Aquista ora ➟</button></a>
</div>


<div class="container">
    <h1 style="color: black">I nostri prodotti preferiti</h1>
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
<%@ include file="marche.jsp" %>
<%@ include file="body.jsp" %>
<%@ include file="previewFooter.jsp" %>
<%@ include file="footer.jsp" %>
</body>
</html>
