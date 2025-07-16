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
            <th>Numero Ordine</th>
            <th>Data Ordine</th>
            <th>Data Arrivo</th>
            <th>Totale (€)</th>
            <th>Info</th>
        </tr>
        </thead>
        <tbody>
        <% for (OrderBean ordine : ordini) { %>
        <tr>
            <td><%= ordine.getNumeroOrdine() %></td>
            <td><%= ordine.getDataOrdine() %></td>
            <td><%= ordine.getDataOrdine() %></td> <%-- Sostituisci se hai getDataArrivo() --%>
            <td><%= ordine.getTotale() %></td>
            <td><button>Info</button></td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <% } else { %>
    <p class="no-orders">Nessun ordine trovato.</p>
    <% } %>
</div>
