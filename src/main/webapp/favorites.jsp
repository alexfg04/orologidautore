<%@ page import="java.util.Collection" %>
<%@ page import="com.r1.ecommerceproject.model.impl.ProductDaoImpl" %>
<%@ page import="com.r1.ecommerceproject.model.ProductBean" %>
<%@ page import="com.r1.ecommerceproject.utils.UserSession" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    UserSession sessioneUtente = new UserSession(request.getSession());
    if (!sessioneUtente.isLoggedIn()) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    long userId = sessioneUtente.getUserId();  // recupero id utente

    ProductDaoImpl dao = new ProductDaoImpl();
    Collection<ProductBean> favorites;
    try {
        favorites = dao.doRetrieveAllFavorites("codice_prodotto", userId);
    } catch (Exception e) {
        favorites = java.util.Collections.emptyList();
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>I miei preferiti</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/navbar.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/footer.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/layout.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/assets/css/favorites.css">

</head>
<body>
<%@ include file="navbar.jsp" %>

<main class="content">
    <!-- Flash notification -->
    <%
        String flash = (String) session.getAttribute("flashMessage");
        if (flash != null && !flash.isEmpty()) {
    %>
    <div id="errorNotification" class="error-notification danger">
        <%= flash %><span class="close">×</span>
    </div>
    <%
            session.removeAttribute("flashMessage");
        }
    %>

    <div class="favorites-container">
        <%
            if (favorites.isEmpty()) {
        %>
        <p class="empty">Non hai ancora aggiunto prodotti ai preferiti.</p>
        <%
        } else {
            for (ProductBean prod : favorites) {
        %>
        <div class="favorite-card">
            <img class="favorite-img"
                 src="<%= prod.getImmagine()%>"
                 alt="Immagine di <%= prod.getNome() %>">
            <div class="favorite-info">
                <h3 class="favorite-name"><%= prod.getNome() %></h3>
                <p class="favorite-price">€ <%= String.format("%.2f", prod.getPrezzo()) %></p>
                <p class="favorite-description"><%= prod.getDescrizione() %></p>

            <div class="favorite-actions">
                <form action="<%= request.getContextPath() %>/cart" method="post">
                    <input type="hidden" name="product_id" value="<%= prod.getCodiceProdotto() %>">
                    <input type="hidden" name="quantity" value="1">
                    <button type="submit" class="btn add-to-cart">Aggiungi al Carrello</button>
                </form>
                <form action="<%= request.getContextPath() %>/favorite" method="post">
                    <input type="hidden" name="productId" value="<%= prod.getCodiceProdotto() %>">
                    <button type="submit" class="btn remove-favorite">Rimuovi</button>
                </form>
            </div>
            </div>
        </div>
        <%
                }
            }
        %>
    </div>
</main>

<%@ include file="footer.jsp" %>
<script src="https://unpkg.com/lucide@latest"></script>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/product-script.js"></script>
<script>lucide.createIcons();</script>
</body>
</html>