<%@ page import="com.r1.ecommerceproject.model.ProductBean, com.r1.ecommerceproject.dao.ProductDaoImpl" %>
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
<body>
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

            <form action="<%= request.getContextPath() %>/cart" method="post">
                <input type="hidden" name="product_id" value="<%= product.getCodiceProdotto() %>">
                <label for="quantity">Quantità:</label>
                <input type="number" id="quantity" name="quantity" min="1" value="1">
                <button type="submit" class="add-to-cart-button">Aggiungi al Carrello</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>
