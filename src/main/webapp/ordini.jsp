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
            <th>Info</th>
        </tr>
        </thead>
        <tbody>
        <% for (OrderBean ordine : ordini) { %>
        <% System.out.println(ordine.getIdOrder()); %>
        <tr>
            <td><%= ordine.getIdOrder() %></td>
            <td><%= ordine.getNumeroOrdine() %></td>
            <td><%= ordine.getDataOrdine() %></td>
            <td><%= ordine.getDataOrdine() %></td>
            <td><%= ordine.getTotale() %></td>
            <button onclick=mostraProdottiOrdine(<%= ordine.getIdOrder() %>)>Vedi Prodotti</button>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } else { %>
    <p class="no-orders">Nessun ordine trovato.</p>
    <% } %>
</div>
