<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.r1.ecommerceproject.model.OrderBean" %>
<%
    Collection<OrderBean> ordini = (Collection<OrderBean>) request.getAttribute("ordini");
%>

<% if (ordini != null && !ordini.isEmpty()) { %>
<table>
    <thead>
    <tr>
        <th>Numero Ordine</th>
        <th>Data Ordine</th>
        <th>Data Arrivo</th>
        <th>Totale (€)</th>
    </tr>
    </thead>
    <tbody>
    <% for (OrderBean ordine : ordini) { %>
    <tr>
        <td><%= ordine.getNumeroOrdine() %></td>
        <td><%= ordine.getDataOrdine() %></td>
        <td><%= ordine.getDataOrdine() %></td>
        <td><%= ordine.getTotale() %></td>
    </tr>
    <% } %>
    </tbody>
</table>
<% } else { %>
<p>Nessun ordine trovato.</p>
<% } %>
