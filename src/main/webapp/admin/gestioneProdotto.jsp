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
            background-color: #f4f4f4;
            padding: 20px;
        }

        h2 {
            margin-top: 0;
        }

        .container {
            display: flex;
            gap: 30px;
            flex-wrap: wrap;
        }

        .section {
            flex: 1;
            min-width: 300px;
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
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
            max-height: 400px; /* Limita l'altezza massima */
            border: 1px solid #ccc;
            border-radius: 5px;
            object-fit: contain; /* Evita deformazioni */
            border: none;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        label {
            margin-top: 10px;
            font-weight: 500;
        }

        input[type="text"],
        input[type="number"],
        textarea {
            padding: 8px;
            margin-top: 5px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 15px;
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
            background-color: #2ecc71;
            color: #fff;
        }

        .delete-btn {
            background-color: #e74c3c;
            color: #fff;
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

        <form action="salvaModificheProdotto" method="post">
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

    </div>
</div>

</div>

</body>
</html>
