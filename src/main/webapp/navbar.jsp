<%@ page import="com.r1.ecommerceproject.utils.UserSession" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<link rel="stylesheet" href="assets/css/navbar.css">

<%
    UserSession userSession = new UserSession(request.getSession());// modifica: recupero nome
    boolean loggedIn = userSession.isLoggedIn();

    String firstName = userSession.getFirstName();
    String lastName = userSession.getLastName();
%>

<header class="navbar-wrapper">
    <nav class="navbar">
        <div class="navbar-left">
            <img src="assets/img/Logo.png" alt="Logo">
        </div>


        <div class="navbar-center">
            <a href="index.jsp">Home</a>
            <a href="${pageContext.request.contextPath}/catalog">Catalogo</a>
            <a href="${pageContext.request.contextPath}/catalog?gender=uomo">Uomo</a>
            <a href="${pageContext.request.contextPath}/catalog?gender=donna">Donna</a>
        </div>


        <div class="navbar-right">
            <!--
            <form action="search" method="get" class="search-form">
                <input type="text" name="query" placeholder="Cerca...">
                <button type="submit">
                    <i data-lucide="search"></i>
                </button>
            </form>
            -->

            <!-- Icona registrazione/utente con dropdown -->
            <button id="mobile-menu-toggle" class="mobile-toggle" aria-expanded="false">
            <i data-lucide="menu" class="icon"></i></button>
            <div class="user-dropdown">
                <% if (loggedIn) { %>
                <span class="user-name">
                    <%= ("" + firstName.charAt(0) + lastName.charAt(0)).toUpperCase()%>
                    <i data-lucide="chevron-down"></i>
                </span>
                <% } else { %>
                <span class="user-icon icon">
                    <i data-lucide="user"></i>
                </span>
                <% } %>
                <ul class="dropdown-menu">
                    <% if (loggedIn) { %>
                    <li><a href="orders.jsp">I miei ordini</a></li>
                    <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
                    <% } else { %>
                    <li><a href="login.jsp">Accedi</a></li>
                    <% } %>
                </ul>
            </div>

            <!-- Icona cuore -->
            <a href="favorites.jsp">
                <i data-lucide="heart" class="icon"></i>
                <span class="badge favorites-badge" data-count="<%= userSession.getFavoritesCount() %>">
                    <%= userSession.getFavoritesCount() %>
                </span>
            </a>

            <!-- Icona carrello -->
            <a href="cart.jsp" class="icon-with-badge">
                <i data-lucide="shopping-cart" class="icon"></i>
                <span class="badge cart-badge" data-count="<%= userSession.getCartSize()%>">
                    <%= userSession.getCartSize() %>
                </span>
            </a>
        </div>

        <div class="mobile-menu">
            <a href="index.jsp">Home</a>
            <a href="${pageContext.request.contextPath}/catalog">Catalogo</a>
            <a href="${pageContext.request.contextPath}/catalog?gender=uomo">Uomo</a>
            <a href="${pageContext.request.contextPath}/catalog?gender=donna">Donna</a>
        </div>
    </nav>
</header>
<div class="navbar-offset"></div>