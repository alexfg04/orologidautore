<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.r1.ecommerceproject.model.ProductBean, com.r1.ecommerceproject.model.OrderBean" %>
<%
    OrderBean ordine = (OrderBean) request.getAttribute("ordine");
    Collection<ProductBean> prodotti = (Collection<ProductBean>) request.getAttribute("prodotti");
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Dettagli Ordine</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fonts.css">
    <style>
        body {
            font-family: 'Lato', Arial, sans-serif;
            background-color: #f9fafe;
            color: #333;
            padding: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            border-bottom: 1px solid #ccc;
        }
        th {
            background-color: #00796b;
            color: #fff;
        }
        tr:hover {background-color: #d6e9ff;}
        a {
            display: inline-block;
            margin-top: 20px;
            color: #00796b;
            text-decoration: none;
        }
    </style>
</head>
<body>
<h2>Ordine n° <%= ordine.getNumeroOrdine() %></h2>
<p><strong>Data ordine:</strong> <%= ordine.getDataOrdine() %></p>
<p><strong>Totale:</strong> <%= ordine.getTotale() %> €</p>
<table>
    <thead>
    <tr>
        <th>Prodotto</th>
        <th>Quantità</th>
        <th>Prezzo Unitario</th>
        <th>IVA %</th>
    </tr>
    </thead>
    <tbody>
    <% for(ProductBean p : prodotti) { %>
    <tr>
        <td><%= p.getNome() %></td>
        <td><%= p.getQuantity() %></td>
        <td><%= p.getPrezzoUnitario() %> €</td>
        <td><%= p.getIvaPercentuale() %></td>
    </tr>
    <% } %>
    </tbody>
</table>
<a href="<%= request.getContextPath() %>/admin/dashboard.jsp">Torna alla dashboard</a>
</body>
</html>
