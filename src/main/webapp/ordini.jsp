<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.r1.ecommerceproject.model.OrderBean" %>
<%
    Collection<OrderBean> ordini = (Collection<OrderBean>) request.getAttribute("ordini");
%>

</style>
<div class="ordini-wrapper">
    <% if (ordini != null && !ordini.isEmpty()) { %>
    <table>
        <thead>
        <tr>
            <th>Id</th>
            <th>Numero Ordine</th>
            <th>Data Ordine</th>
            <th>Data Arrivo</th>
            <th>Totale (€)</th>
        </tr>
        </thead>
        <tbody>
        <% for (OrderBean ordine : ordini) { %>
        <tr class='clickable-row' onclick="window.location.href='<%= request.getContextPath() %>/admin/orderDetails?numeroOrdine=<%= ordine.getNumeroOrdine() %>'" style="cursor:pointer">
            <td><%= ordine.getIdOrder() %></td>
            <td><%= ordine.getNumeroOrdine() %></td>
            <td><%= ordine.getDataOrdine() %></td>
            <td><%= ordine.getDataArrivo() %></td>
            <td><%= ordine.getTotale() %></td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } else { %>
    <p class="no-orders">Nessun ordine trovato.</p>
    <% } %>
</div>
