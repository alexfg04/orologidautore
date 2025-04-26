<%@ page import="com.r1.ecommerceproject.utils.UserSession" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<link rel="stylesheet" href="assets/css/navbar.css">

<%
    UserSession userSession = new UserSession(request.getSession());
%>

<header>
    <nav class="navbar">
        <!-- Sinistra: Logo -->
        <div class="navbar-left">
            <img src="assets/img/Logo.png" alt="Logo">
        </div>

        <!-- Centro: Sezioni cliccabili -->
        <div class="navbar-center">
            <a href="index.jsp">Home</a>
            <a href="catalog.jsp">Novità</a>
            <a href="about.jsp">Uomo</a>
            <a href="contact.jsp">Donna</a>
        </div>

        <!-- Destra: Form di ricerca e icone outline -->
        <div class="navbar-right">
            <form action="search" method="get" class="search-form">
                <input type="text" name="query" placeholder="Cerca...">
                <button type="submit">
                    <i data-lucide="search"></i>
                </button>
            </form>

            <!-- Icona utente -->
            <a href="login.jsp">
                <i data-lucide="user" class="icon"></i>
            </a>

            <!-- Icona cuore -->
            <a href="favorites.jsp">
                <i data-lucide="heart" class="icon"></i>
                <span class="badge favorites-badge" data-count="0"></span>
            </a>

            <!-- Icona carrello -->
            <a href="cart.jsp" class="icon-with-badge">
                <i data-lucide="shopping-cart" class="icon"></i>
                <span class="badge cart-badge" data-count="<%= userSession.getCartSize()%>">
                    <%=userSession.getCartSize()%>
                </span>
            </a>
        </div>
    </nav>
</header>