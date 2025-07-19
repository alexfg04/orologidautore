<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.r1.ecommerceproject.model.ProductBean" %>
<%
    ProductBean prodotto = (ProductBean) request.getAttribute("prodotto");
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Gestione Prodotto</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background-color: #e0f2f1;
            padding: 20px;
            color: #004d40;
        }

        h2 {
            margin-top: 0;
            color: #004d40;
        }

        .container {
            display: flex;
            gap: 30px;
            flex-wrap: wrap;
        }

        .section {
            flex: 1;
            min-width: 300px;
            background: #ffffff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 77, 64, 0.2);
            border: 2px solid #004d40;
        }

        ul {
            list-style: none;
            padding: 0;
        }

        ul li {
            margin-bottom: 10px;
        }

        img {
            max-width: 100%;
            height: auto;
            max-height: 400px;
            border-radius: 5px;
            object-fit: contain;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        label {
            margin-top: 10px;
            font-weight: 600;
            color: #004d40;
        }

        input[type="text"],
        input[type="number"],
        textarea {
            padding: 8px;
            margin-top: 5px;
            border-radius: 6px;
            border: 1px solid #004d40;
            font-size: 15px;
            background-color: #f1f8f6;
            color: #004d40;
        }

        textarea {
            resize: vertical;
            min-height: 70px;
        }

        .buttons {
            display: flex;
            gap: 15px;
            margin-top: 20px;
            flex-wrap: wrap;
        }

        input[type="submit"] {
            padding: 10px 16px;
            border: none;
            border-radius: 6px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s ease;
        }

        .save-btn {
            background-color: #00796b;
            color: #fff;
        }

        .save-btn:hover {
            background-color: #004d40;
        }

        .delete-btn {
            background-color: #d32f2f;
            color: #fff;
        }

        .delete-btn:hover {
            background-color: #b71c1c;
        }

        @media screen and (max-width: 600px) {
            .container {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>

<div class="container">

    <!-- SEZIONE DETTAGLI -->
    <div class="section">
        <h2>📋 Dettagli Prodotto</h2>
        <ul>
            <li><strong>Nome:</strong> <%= prodotto.getNome() %></li>
            <li><strong>Marca:</strong> <%= prodotto.getMarca() %></li>
            <li><strong>Genere:</strong> <%= prodotto.getGenere() %></li>
            <li><strong>Prezzo:</strong> <%= prodotto.getPrezzo() %> €</li>
            <li><strong>Modello:</strong> <%= prodotto.getModello() %></li>
            <li><strong>Descrizione:</strong> <%= prodotto.getDescrizione() %></li>
            <li><strong>Taglia:</strong> <%= prodotto.getTaglia() %></li>
            <li><strong>Materiale:</strong> <%= prodotto.getMateriale() %></li>
            <li><strong>Immagine:</strong><br>
                <img src="<%= prodotto.getImmagine() %>" alt="Immagine prodotto">
            </li>
        </ul>
    </div>

    <!-- SEZIONE MODIFICA -->
    <div class="section">
        <h2>🛠️ Modifica Prodotto</h2>

        <form action="${pageContext.request.contextPath}/admin/salvaModificheProdottoServlet" method="post">
            <input type="hidden" name="id" value="<%= prodotto.getCodiceProdotto() %>">

            <label for="nome">Nome:</label>
            <input type="text" id="nome" name="nome" value="<%= prodotto.getNome() %>">

            <label for="marca">Marca:</label>
            <input type="text" id="marca" name="marca" value="<%= prodotto.getMarca() %>">

            <label for="categoria">Categoria:</label>
            <input type="text" id="categoria" name="categoria" value="<%= prodotto.getGenere() %>">

            <label for="prezzo">Prezzo:</label>
            <input type="number" id="prezzo" name="prezzo" value="<%= prodotto.getPrezzo() %>" step="0.01">

            <label for="modello">Modello:</label>
            <input type="text" id="modello" name="modello" value="<%= prodotto.getModello() %>">

            <label for="descrizione">Descrizione:</label>
            <textarea id="descrizione" name="descrizione"><%= prodotto.getDescrizione() %></textarea>

            <label for="taglia">Taglia:</label>
            <input type="text" id="taglia" name="taglia" value="<%= prodotto.getTaglia() %>">

            <label for="materiale">Materiale:</label>
            <input type="text" id="materiale" name="materiale" value="<%= prodotto.getMateriale() %>">

            <div class="buttons">
                <input type="submit" class="save-btn" value="💾 Salva Modifiche">
        </form>

        <form action="${pageContext.request.contextPath}/admin/gestione" method="get"
              onsubmit="return confirm('Sei sicuro di voler eliminare questo prodotto?');">
            <input type="hidden" name="action" value="delete">
            <input type="hidden" name="product_id" value="<%= prodotto.getCodiceProdotto() %>">
            <input type="submit" class="delete-btn" value="🗑️ Elimina">
        </form>
        <form action="${pageContext.request.contextPath}/admin/dashboard.jsp" method="get">
            <input type="submit" class="home-btn" value="🏠 Torna alla Home">
        </form>

    </div>
</div>

</body>
</html>