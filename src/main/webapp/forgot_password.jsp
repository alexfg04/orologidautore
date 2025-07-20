<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Recupera Password</title>
    <link rel="stylesheet" href="assets/css/fonts.css">
</head>
<body>
 <h2>Password dimenticata</h2>
 <form action="ForgotPasswordServlet" method="post">
    <label>Email:</label>
    <input type="email" name="email" required />
    <button type="submit">Recupera</button>
</form>
</body>
</html>
