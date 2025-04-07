<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	Collection<?> products = (Collection<?>) request.getAttribute("products");
	if(products == null) {
	response.sendRedirect("./product");	
		return;
	}
	ProductBean product = (ProductBean) request.getAttribute("product");
%>

<!DOCTYPE html>
<html>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="java.util.*, com.r1.ecommerceproject.model.ProductBean" %>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<link href="${pageContext.request.contextPath}/assets/css/ProductStyle.css" rel="stylesheet" type="text/css">
	<title>Storage DS/BF</title>
</head>

<body>
	<div class="container">
		<h2>Products</h2>
		<table>
			<tr>
				<th>Codice <a href="product?sort=codice_prodotto">Sort</a></th>
				<th>Nome <a href="product?sort=nome">Sort</a></th>
				<th>Descrizione <a href="product?sort=descrizione">Sort</a></th>
				<th>Modello <a href="product?sort=modello">Sort</a></th>
				<th>Prezzo <a href="product?sort=prezzo">Sort</a></th>
				<th>Stato <a href="product?sort=stato">Sort</a></th>
				<th>Action</th>
			</tr>
			<%
				if (products != null && !products.isEmpty()) {
					Iterator<?> it = products.iterator();
					while (it.hasNext()) {
						ProductBean bean = (ProductBean) it.next();
			%>
			<tr>
				<td><%=bean.getCodiceProdotto()%></td>
				<td><%=bean.getNome()%></td>
				<td><%=bean.getModello()%></td>
				<td><%=bean.getDescrizione()%></td>
				<td><%=bean.getPrezzo()%></td>
				<td><%= bean.getStato()%></td>
				<td><a href="product?action=delete&id=<%=bean.getCodiceProdotto()%>">Delete</a><br>
					<a href="product?action=read&id=<%=bean.getCodiceProdotto()%>">Details</a></td>
			</tr>
			<%
					}
				} else {
			%>
			<tr>
				<td colspan="6">No products available</td>
			</tr>
			<%
				}
			%>
		</table>
		
		<h2>Details</h2>
		<%
			if (product != null) {
		%>
		<table>
			<tr>
				<th>Codice</th>
				<th>Nome</th>
				<th>Modello</th>
				<th>Marca</th>
				<th>Descrizione</th>
				<th>Prezzo</th>
				<th>Taglia</th>
				<th>Categoria</th>
				<th>Materiale</th>

			</tr>
			<tr>
				<td><%=product.getCodiceProdotto()%></td>
				<td><%=product.getNome()%></td>
				<td><%=product.getModello()%></td>
				<td><%=product.getMarca()%></td>
				<td><%=product.getDescrizione()%></td>
				<td><%=product.getPrezzo()%></td>
				<td><%=product.getTaglia()%></td>
				<td><%=product.getCategoria()%></td>
				<td><%=product.getMateriale()%></td>
			</tr>
		</table>
		<%
			}
		%>
		<h2>Insert</h2>
		<form action="product" method="post">
			<input type="hidden" name="action" value="insert">
			
			<label for="name">Name:</label>
			<input id="name" name="nome" type="text" maxlength="20" required placeholder="inserisci nome...">
			
			<label for="description">Description:</label>
			<textarea id="description" name="descrizione" maxlength="100" rows="3" required placeholder="inserisci descrizione..."></textarea>
			
			<label for="price">Prezzo:</label>
			<input id="price" name="prezzo" type="number" min="0" value="0" required>

			<label for="model">Modello</label>
			<input id="model" name="modello" type="text" maxlength="20" required>

			<label for="brand">Marca</label>
			<input id="brand" name="marca" type="text" maxlength="20" required>
	
			<label for="category">Categoria</label>
			<input id="category" name="categoria" type="text" maxlength="20" required>

			<label for="size">Taglia</label>
			<input id="size" name="taglia" type="text" maxlength="20" required>

			<label for="material">Materiale</label>
			<input id="material" name="materiale" type="text" maxlength="20" required>
	
			<input type="submit" value="Add">
			<input type="reset" value="Reset">
	
		</form>
		</div>
</body>
</html>