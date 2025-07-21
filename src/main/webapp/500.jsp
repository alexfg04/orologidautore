<%--
  Created by IntelliJ IDEA.
  User: alessioforgione
  Date: 21/07/25
  Time: 08:16
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" contentType="text/html;charset=UTF-8" %>
<%
    // Recupera attributi di errore
    Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
    String errorMessage = (String) request.getAttribute("javax.servlet.error.message");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 Not Found</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Lato:wght@400;700&family=Playfair+Display:wght@400;700&display=swap');

        body {
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f5f5f5;
        }

        img {
            max-width: 300px;
            height: auto;
        }

        .message {
            margin-top: 16px;
            font-family: 'Playfair Display', serif;
            font-size: 16px;
            font-weight: 500;
            color: #000000;
            text-align: center;
        }

        .message h2 {
            font-size: 24px;
            margin-bottom: 10px;
        }
        .message h3 {
            font-size: 18px;
            margin-bottom: 10px;
        }

        .home-button {
            margin-top: 30px;
            padding: 12px 24px;
            font-family: 'Lato', Arial, sans-serif;
            font-size: 18px;
            font-weight: 500;
            color: #ffffff;
            background-color: #00695C;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            cursor: pointer;
        }

        .home-button:hover {
            opacity: 0.9;
        }
    </style>
</head>
<body>
<img src="assets/img/500.png" alt="Logo">
<div class="message">
    <h2>Errore interno del server</h2>
    <h3>Messaggio di errore:</h3>
    <%
        if (errorMessage != null && !errorMessage.isEmpty()) {
            out.print(errorMessage);
        } else {
            out.print("Nessun messaggio disponibile");
        }
    %>
    <%
        if (exception != null) {
    %>
    <h3>Dettagli della eccezione:</h3>
    <pre>
<%
    exception.printStackTrace(new java.io.PrintWriter(out));
%>
        </pre>
    <%
        }
    %>
</div>
<a href="index.jsp" class="home-button">Ritorna al Home</a>
</body>
</html>

