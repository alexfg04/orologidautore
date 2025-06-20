<%@ page import="com.r1.ecommerceproject.utils.UserSession" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<link rel="stylesheet" href="assets/css/navbar.css">

<%
    UserSession userSession = new UserSession(request.getSession());
    String firstName = userSession.getFirstName();  // modifica: recupero nome
    boolean loggedIn = (firstName != null);

    String loginUrl = request.getContextPath() + "/login.jsp";
    String href      = loggedIn ? "#" : loginUrl;
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



            <!-- Icona registrazione/utente con dropdown -->
            <div class="user-dropdown<% if(loggedIn){ %> logged-in<% } %>">
                <%if(!loggedIn) { %>
                <a href="<%= href %>" class="user-icon">
                    <i data-lucide="user"></i>
                </a>
                <%} %>
                <% if (loggedIn) { %>
                <!-- modifica: visualizzo nome utente sotto icona -->
                <span class="user-name"><%= firstName%> </span>
                <% } %>
                <ul class="dropdown-menu">
                    <li><a href="orders.jsp">I miei ordini</a></li>
                    <li><a href="account.jsp">Account</a></li>
                </ul>
            </div>

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