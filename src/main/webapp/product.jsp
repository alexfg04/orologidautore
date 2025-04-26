<%@ page import="com.r1.ecommerceproject.model.ProductBean" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    ProductBean product = (ProductBean) request.getAttribute("product");
    if (product == null) {
        response.sendRedirect(request.getContextPath() + "/catalog");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= product.getNome() %> - Dettagli Prodotto</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/product-detail.css">
</head>
<style>
    /* Quadrato semplice con notifiche */
    .error-notification {
        width: 350px;
        height: 75px;
        background-color: #009688; /* Colore per errore */
        color: white;
        font-size: 16px;
        font-weight: bold;
        display: flex;
        justify-content: center;
        align-items: center;
        text-align: center;
        position: absolute; /* Cambiato da fixed a absolute per tenerlo sopra il form */
        bottom: 24px;
        right: 12px;
        box-shadow: 0 3px 8px rgba(0, 0, 0, 0.3);
        opacity: 0; /* Inizia invisibile */
        animation: showNotification 0.5s forwards;
        transition: opacity 0.5s ease;
        padding: 10px;
        border-radius: 10px; /* Rende i bordi leggermente arrotondati */
        z-index: 1000; /* Assicurati che la notifica sia sopra gli altri elementi */
    }

    /* Animazione di apparizione */
    @keyframes showNotification {
        0% {
            opacity: 0;
            transform: scale(0.5);
        }
        100% {
            opacity: 1;
            transform: scale(1);
        }
    }

    /* X di chiusura */
    .error-notification .close {
        position: absolute;
        top: 10px;
        right: 10px;
        color: #000000;
        font-size: 20px;
        cursor: pointer;
    }

    /* Colori per il tipo di messaggio */
    .error-notification.danger { background-color: #009688;}
</style>
<body>
<%@ include file="navbar.jsp"%>
<%
    String flashMessage = (String) session.getAttribute("flashMessage");
    if ((flashMessage != null && !flashMessage.isEmpty())) {
%>
<div id="errorNotification" class="error-notification danger">
    <%= flashMessage %>
    <span class="close">×</span>
</div>
<%
        session.removeAttribute("flashMessage");
    }
%>
<div class="detail-container">
    <div class="detail-card">
        <div class="detail-img">
            <img src="<%= request.getContextPath() + "/" + product.getImmagine() %>"
                 alt="Immagine di <%= product.getNome() %>">
        </div>
        <div class="detail-info">
            <h1><%= product.getNome() %>
            </h1>
            <p class="price">€ <%= String.format("%.2f", product.getPrezzo()) %>
            </p>
            <p class="description"><%= product.getDescrizione() %>
            </p>

            <ul class="extra-info">
                <li><strong>Marca:</strong> <%= product.getMarca() %>
                </li>
                <li><strong>Modello:</strong> <%= product.getModello() %>
                </li>
                <li><strong>Categoria:</strong> <%= product.getCategoria() %>
                </li>
                <li><strong>Taglia:</strong> <%= product.getTaglia() %>
                </li>
                <li><strong>Materiale:</strong> <%= product.getMateriale() %>
                </li>
            </ul>
            <br>

            <form action="<%= request.getContextPath() %>/cart" method="post" class="product-form">
                <input type="hidden" name="product_id" value="<%= product.getCodiceProdotto() %>">
                <div class="form-group">
                    <label for="quantity">Quantità:</label>
                    <input type="number" id="quantity" name="quantity" min="1" value="1">
                </div>
                <button type="submit" class="add-to-cart-button">Aggiungi al Carrello</button>
            </form>
        </div>
    </div>
</div>
<script src="https://unpkg.com/lucide@latest"></script>
<script src="assets/js/toast.js"></script>
<script>
    lucide.createIcons();
</script>
</body>
</html>
