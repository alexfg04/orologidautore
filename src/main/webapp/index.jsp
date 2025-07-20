<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Catalogo Prodotti</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/home.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/body.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/marche.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/PreviewFooter.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/IndexProduct.css">
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="container">
    <img src="assets/img/header_image.jpg" alt="Immagine" class="image">
    <div class="text-overlay">Compra un orologio di qualità!</div>
    <a href="${pageContext.request.contextPath}/catalog"><button class="button">Acquista ora ➟</button></a>
</div>
<%@ include file="IndexProduct.jsp" %>
<%@ include file="marche.jsp" %>
<%@ include file="body.jsp" %>
<%@ include file="previewFooter.jsp" %>
<%@ include file="footer.jsp" %>
<script src="https://unpkg.com/lucide@latest"></script>
<script src="assets/js/navbar.js"></script>
<script>
    lucide.createIcons();
</script>
</body>
</html>
