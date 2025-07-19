<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.r1.ecommerceproject.model.ProductBean" %>
<%
    ProductBean prodotto = (ProductBean) request.getAttribute("prodotto");
    if(prodotto == null){
        out.println("Prodotto non trovato.");
        return;
    }
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8" />
    <title>Modifica Prodotto</title>
</head>
<body>A
<h2>Modifica Prodotto: <%= prodotto.getNome() %></h2>
<form action="<%= request.getContextPath() %>/admin/salvaModificheProdotto" method="post">
    <input type="hidden" name="id" value="<%= prodotto.getCodiceProdotto() %>"/>

    Nome: <input type="text" name="nome" value="<%= prodotto.getNome() %>" required /><br/>
    Marca: <input type="text" name="marca" value="<%= prodotto.getMarca() %>" required /><br/>
    Categoria (Genere): <input type="text" name="categoria" value="<%= prodotto.getGenere() %>" /><br/>
    Prezzo: <input type="number" step="0.01" name="prezzo" value="<%= prodotto.getPrezzo() %>" required /><br/>
    Modello: <input type="text" name="modello" value="<%= prodotto.getModello() %>" /><br/>
    Descrizione: <textarea name="descrizione"><%= prodotto.getDescrizione() %></textarea><br/>
    Taglia: <input type="text" name="taglia" value="<%= prodotto.getTaglia() %>" /><br/>
    Materiale: <input type="text" name="materiale" value="<%= prodotto.getMateriale() %>" /><br/>

    <input type="submit" value="Salva Modifiche" />
</form>
</body>
</html>
