<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Password Recuperata</title>
    <link rel="stylesheet" href="assets/css/fonts.css">
</head>
<body>
<% String password = (String) request.getAttribute("passwordRecuperata"); %>
<% String errore = (String) request.getAttribute("errore"); %>

<% if (password != null) { %>
<p>La tua password è: <strong><%= password %></strong></p>
<% } else if (errore != null) { %>
<p style="color:red;"><%= errore %></p>
<% } %>

<a href="login.jsp">Torna al login</a>
</body>
</html>
