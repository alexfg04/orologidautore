<%@ page contentType="text/html; charset=UTF-8" %>
<%
    UserSession sessioneUtente = new UserSession(request.getSession());
    if (!sessioneUtente.isLoggedIn()) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
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
    <a href="${pageContext.request.contextPath}/catalog"><button class="button">Acquista ora ➟</button></a>
</div>
<script src="https://unpkg.com/lucide@latest"></script>
<script>
    lucide.createIcons();
</script>
<jsp:include page="IndexProduct.jsp" />
<%@ include file="marche.jsp" %>
<%@ include file="body.jsp" %>
<%@ include file="previewFooter.jsp" %>
<%@ include file="footer.jsp" %>
</body>
</html>
