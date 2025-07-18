<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.r1.ecommerceproject.model.OrderBean" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Ordini utente</title>
    <style>
        /* Reset base */
        * {
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f9fafe;
            color: #333;
            margin: 20px;
            padding: 0;
        }

        h2 {
            color: #2c3e50;
            margin-bottom: 20px;
            font-weight: 700;
            font-size: 1.8rem;
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 8px;
            background-color: #fff;
            box-shadow: 0 4px 8px rgba(0,0,0,0.05);
            border-radius: 8px;
            overflow: hidden;
        }

        thead tr {
            background-color: #2980b9;
            color: white;
            text-transform: uppercase;
            font-size: 0.9rem;
            letter-spacing: 0.05em;
        }

        thead th {
            padding: 14px 20px;
        }

        tbody tr {
            background-color: #fff;
            transition: background-color 0.3s ease;
            cursor: default;
        }

        tbody tr:hover {
            background-color: #d6e9ff;
        }

        tbody td {
            padding: 14px 20px;
            border-bottom: 1px solid #eee;
            font-size: 1rem;
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        /* Link per tornare indietro */
        a {
            display: inline-block;
            margin-top: 30px;
            text-decoration: none;
            color: #2980b9;
            font-weight: 600;
            transition: color 0.2s ease;
        }

        a:hover {
            color: #1c5980;
        }

        /* Messaggio nessun ordine */
        p {
            font-size: 1.1rem;
            color: #555;
            margin-top: 20px;
            font-style: italic;
        }
    </style>
</head>
<body>
<h2>Ordini dell'utente con ID: <%= request.getAttribute("idUtente") %></h2>

<%
    List<OrderBean> ordini = (List<OrderBean>) request.getAttribute("ordini");

    if (ordini == null || ordini.isEmpty()) {
%>
<p>Nessun ordine trovato per questo utente.</p>
<%
} else {
%>
<table>
    <thead>
    <tr>
        <th>ID</th>
        <th>Numero Ordine</th>
        <th>Data Ordine</th>
        <th>Data Arrivo</th>
        <th>Totale</th>
        <th>Note</th>
    </tr>
    </thead>
    <tbody>
    <%
        for (OrderBean ordine : ordini) {
    %>
    <tr>
        <td><%= ordine.getIdOrder() %></td>
        <td><%= ordine.getNumeroOrdine() %></td>
        <td><%= ordine.getDataOrdine() %></td>
        <td><%= ordine.getDataArrivo() != null ? ordine.getDataArrivo() : "Non disponibile" %></td>
        <td><%= ordine.getTotale() %> €</td>
        <td><%= ordine.getNote() != null ? ordine.getNote() : "-" %></td>
    </tr>
    <%
        }
    %>
    </tbody>
</table>
<%
    }
%>

<br>
<a href="<%= request.getContextPath() %>/admin/dashboard.jsp">🔙 Torna alla dashboard</a>
</body>
</html>
