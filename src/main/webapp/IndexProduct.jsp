<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Prodotti</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/IndexProduct.css">
</head>
<body>

<div class="container-product">

    <!-- Card cliccabile che chiama la servlet /product?id=1 -->
    <a href="${pageContext.request.contextPath}/product?id=21" class="card">
        <img src="https://www.watchshop.com/images/products/75729103_l.jpg" alt="Orologio 1">
        <div class="container-text">
            <h3>Orologio Classico</h3>
            <p>Elegante orologio da polso in pelle</p>
        </div>
    </a>

    <!-- Puoi duplicare questa card e cambiare l'id per altri prodotti -->
    <a href="${pageContext.request.contextPath}/product?id=10" class="card">
        <img src="https://www.watchshop.com/images/products/41498790_l.jpg" alt="Orologio 2">
        <div class="container-text">
            <h3>Orologio Sportivo</h3>
            <p>Design moderno e resistente all’acqua</p>
        </div>
    </a>

</div>

</body>
</html>