<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.r1.ecommerceproject.model.ProductBean" %>
<%@ page import="java.math.BigDecimal" %>

<%
    // Simulazione prodotto
    String orderNumber = (String)request.getAttribute("orderNumber");
    if(orderNumber == null) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Order ID non valido");
        return;
    }

    String amountAttribute = (String) request.getAttribute("amount");
    BigDecimal amount = new BigDecimal(amountAttribute);
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Acquisto completato</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/navbar.css">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
            color: #333;
        }

        .container {
            width: 85%;
            margin: 0 auto;
            padding: 40px 0;
        }

        .verified-box {
            display: flex;
            justify-content: center;
            align-items: center;
            background-color: #e9fbe9;
            border: 3px solid #28a745;
            border-radius: 50%;
            width: 130px;
            height: 130px;
            margin: 30px auto;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
            animation: pulse 0.6s ease-out;
        }

        @keyframes pulse {
            0% { transform: scale(0.7); opacity: 0; }
            100% { transform: scale(1); opacity: 1; }
        }

        .order-summary {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-top: 30px;
        }

        .order-summary h2 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #2c3e50;
        }
        .total-section {
            margin-top: 20px;
            font-size: 18px;
            font-weight: bold;
            text-align: center;
            color: #2c3e50;
        }

        .order-id {
            text-align: center;
            margin-top: 10px;
            font-size: 16px;
            color: #555;
        }

        .btn-home {
            display: block;
            margin: 30px auto 0;
            background-color: #28a745;
            color: white;
            padding: 12px 25px;
            font-size: 16px;
            border: none;
            border-radius: 6px;
            text-decoration: none;
            text-align: center;
            width: fit-content;
        }

        .btn-home:hover {
            background-color: #218838;
        }

        @media (max-width: 768px) {
            .container {
                width: 90%;
            }

            .product-row p {
                font-size: 14px;
            }

            .order-summary h2 {
                font-size: 20px;
            }
        }
    </style>
</head>
<body>
<%@ include file="navbar.jsp" %>
<!-- CONTENUTO PRINCIPALE -->
<div class="container">
    <div class="verified-box">
        <svg width="70" height="70" viewBox="0 0 24 24" fill="none" stroke="#28a745" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round">
            <path d="M20 6L9 17l-5-5" />
        </svg>
    </div>

    <p class="order-id">Numero ordine: <%= orderNumber %></p>

    <div class="order-summary">
        <div class="total-section">
            Totale pagato: € <%= String.format("%.2f", amount) %>
        </div>
    </div>

    <a class="btn-home" href="<%= request.getContextPath() %>/">Torna alla Home</a>
</div>

<%@ include file="footer.jsp" %>

<!-- Script per icone -->
<script src="https://unpkg.com/lucide@latest"></script>
<script>lucide.createIcons();</script>

</body>
</html>
