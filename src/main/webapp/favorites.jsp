<%@ page import="java.util.Collection" %>
<%@ page import="com.r1.ecommerceproject.dao.ProductDaoImpl" %>
<%@ page import="com.r1.ecommerceproject.model.ProductBean" %>
<%@ page import="com.r1.ecommerceproject.utils.UserSession" %>
<%@ page contentType="text/html; charset=UTF-8" %>


<%
    // 1) Prendo l'ID utente
    UserSession userSessione = new UserSession(request.getSession());
    long userId = userSessione.getUserId();

    // 2) Recupero i preferiti
    ProductDaoImpl dao = new ProductDaoImpl();
    Collection<ProductBean> favorites;
    try {
        favorites = dao.doRetrieveAllPreferiti("codice_prodotto", userId);
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
    <style>

        body {
            height: 100%;
            margin: 0;
            display: flex;
            flex-direction: column;
        }
        /* Container generale */
        .favorites-container {
            max-width: 1200px;
            margin: 20px auto;
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 20px;
        }
        /* Card prodotto */
        .favorite-card {
            width: 250px;
            border: 1px solid #eee;
            border-radius: 6px;
            overflow: hidden;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            display: flex;
            flex-direction: column;
        }
        .favorite-card img {
            width: 100%;
            height: auto;
            display: block;
        }
        .favorite-info {
            padding: 12px;
            flex: 1;
        }
        .favorite-info h3 {
            margin: 0 0 8px;
            font-size: 1.1rem;
        }
        .favorite-info .price {
            color: #00695C;
            margin-bottom: 8px;
        }
        .favorite-info .description {
            font-size: 0.9rem;
            color: #555;
            margin-bottom: 12px;
        }
        /* Pulsanti */
        .favorite-actions {
            display: flex;
            border-top: 1px solid #eee;
        }
        .favorite-actions form {
            flex: 1;
            margin: 0;
        }
        .favorite-actions button {
            width: 100%;
            padding: 10px;
            border: none;
            background: #00695C;
            color: #fff;
            cursor: pointer;
            font-weight: 500;
            transition: background 0.2s;
        }
        .favorite-actions button.remove {
            background: #ff3366;
        }
        .favorite-actions button:hover {
            opacity: 0.9;
        }
    </style>
</head>
<body>
<%@ include file="navbar.jsp" %>

<!-- Flash notification (toast.js si occupa dello stile e dell'animazione) -->
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
             src="<%= request.getContextPath() + "/" + prod.getImmagine() %>"
             alt="Immagine di <%= prod.getNome() %>">
        <div class="favorite-info">
            <h3 class="favorite-name"><%= prod.getNome() %></h3>
            <p class="favorite-price">€ <%= String.format("%.2f", prod.getPrezzo()) %></p>
            <p class="favorite-description"><%= prod.getDescrizione() %></p>
        </div>
        <div class="favorite-actions">
            <form action="<%= request.getContextPath() %>/cart" method="post">
                <input type="hidden" name="product_id" value="<%= prod.getCodiceProdotto() %>">
                <input type="hidden" name="quantity" value="1">
                <button type="submit" class="btn add-to-cart">Aggiungi al Carrello</button>
            </form>
            <form action="<%= request.getContextPath() %>/favorite" method="post">
                <input type="hidden" name="product_id" value="<%= prod.getCodiceProdotto() %>">
                <button type="submit" class="btn remove-favorite">Rimuovi</button>
            </form>
        </div>
    </div>
    <%
            }
        }
    %>
</div>

<%@ include file="footer.jsp" %>
<script src="https://unpkg.com/lucide@latest"></script>
<script src="<%= request.getContextPath() %>/assets/js/toast.js"></script>
<script>
    lucide.createIcons();
</script>
</body>
</html>


