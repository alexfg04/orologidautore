<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Dashboard con Tabella Utenti AJAX</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/style.css"/>
</head>
<body>

<button class="hamburger" aria-label="Apri menu" aria-expanded="false">&#9776;</button>

<nav class="sidebar" id="sidebar">
    <h2>Menu</h2>
    <a href="#" class="active" onclick="showTable('table1', this)">Tabella 1</a>
    <a href="#" onclick="showTable('table2', this)">Tabella 2</a>
    <a href="#" onclick="showTable('table3', this)">Tabella 3</a>
</nav>

<div class="overlay" id="overlay"></div>

<main class="content" id="content">

    <div class="user-header">
        <img src="https://i.pravatar.cc/40?img=5" alt="Avatar" class="avatar" />
        <span class="user-name">${UtenteLoggato}</span>
        <div class="dropdown">
            <button onclick="toggleDropdown(this)">Menu &#x25BC;</button>
            <div class="dropdown-menu">
                <a href="#">Profilo</a>
                <a href="#">Impostazioni</a>
                <form action="${pageContext.request.contextPath}/logout" method="get" style="margin:0; padding:0;">
                    <button type="submit">&nbsp;&nbsp;Log Out</button>
                </form>
            </div>
        </div>
    </div>

    <section id="table1" class="table-section active">
        <h3>Tabella 1 - Prodotti</h3>
        <table>
            <thead>
            <tr><th>ID</th><th>Nome</th><th>Prezzo</th><th>Disponibilità</th></tr>
            </thead>
            <tbody>
            <tr><td>1</td><td>Mouse</td><td>25€</td><td>Disponibile</td></tr>
            <tr><td>2</td><td>Tastiera</td><td>45€</td><td>Esaurito</td></tr>
            <tr><td>3</td><td>Monitor</td><td>150€</td><td>Disponibile</td></tr>
            </tbody>
        </table>
    </section>

    <section id="table2" class="table-section">
        <h3>Tabella 2 - Utenti Registrati</h3>
        <div id="dashboard-user"> <!-- Qui sarà caricata la tabella dinamica --></div>
    </section>

    <section id="table3" class="table-section">
        <h3>Tabella 3 - Ordini</h3>
        <table>
            <thead>
            <tr><th>ID Ordine</th><th>Cliente</th><th>Data</th><th>Totale</th></tr>
            </thead>
            <tbody>
            <tr><td>5001</td><td>Mario Rossi</td><td>2025-06-15</td><td>200€</td></tr>
            <tr><td>5002</td><td>Luisa Bianchi</td><td>2025-06-16</td><td>150€</td></tr>
            </tbody>
        </table>
    </section>

</main>

<script>
    const sidebar = document.getElementById('sidebar');
    const hamburger = document.querySelector('.hamburger');
    const overlay = document.getElementById('overlay');
    const content = document.getElementById('content');

    function toggleMenu() {
        const isOpen = sidebar.classList.toggle('open');
        hamburger.setAttribute('aria-expanded', isOpen);
        overlay.classList.toggle('show', isOpen);
        content.classList.toggle('menu-open', isOpen);
    }

    hamburger.addEventListener('click', toggleMenu);
    overlay.addEventListener('click', toggleMenu);

    function showTable(id, link) {
        document.querySelectorAll('section.table-section').forEach(s => s.classList.remove('active'));
        document.getElementById(id).classList.add('active');
        document.querySelectorAll('nav.sidebar a').forEach(a => a.classList.remove('active'));
        link.classList.add('active');
        if (window.innerWidth <= 600) {
            toggleMenu();
        }
        if(id === "table2"){
            loadUserList();
        }
    }

    function toggleDropdown(button) {
        const dropdown = button.parentElement;
        const isOpen = dropdown.classList.toggle('open');
        document.querySelectorAll('.dropdown.open').forEach(d => {
            if (d !== dropdown) d.classList.remove('open');
        });
    }

    window.addEventListener('resize', () => {
        if(window.innerWidth > 600) {
            sidebar.classList.remove('open');
            overlay.classList.remove('show');
            hamburger.setAttribute('aria-expanded', false);
            content.classList.remove('menu-open');
        }
    });

    window.addEventListener('click', (e) => {
        if (!e.target.closest('.dropdown')) {
            document.querySelectorAll('.dropdown.open').forEach(d => d.classList.remove('open'));
        }
    });

    // Funzione AJAX per caricare utenti con paginazione
    function loadUserList() {
        console.log("✅ [JS] Inizio chiamata AJAX a /admin/users");

        var xhr = new XMLHttpRequest();
        xhr.open("GET", "${pageContext.request.contextPath}/admin/users", true);

        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    try {
                        var utenti = JSON.parse(xhr.responseText);
                        var utentiPerPagina = 10;
                        var paginaCorrente = 1;

                        function mostraPagina(pagina) {
                            paginaCorrente = pagina;
                            var start = (pagina - 1) * utentiPerPagina;
                            var end = start + utentiPerPagina;
                            var paginaUtenti = utenti.slice(start, end);

                            var html = "<table><thead><tr><th>Nome</th><th>Cognome</th><th>Email</th><th>Ruolo</th></tr></thead><tbody>";

                            paginaUtenti.forEach(function(user) {
                                html += "<tr>" +
                                    "<td>" + user.nome + "</td>" +
                                    "<td>" + user.cognome + "</td>" +
                                    "<td>" + user.email + "</td>" +
                                    "<td>" + user.tipologia + "</td>" +
                                    "</tr>";
                            });

                            html += "</tbody></table>";

                            // Paginazione
                            html += "<div id='paginazione' style='margin-top:10px;'>";

                            if (paginaCorrente > 1) {
                                html += "<button class='btn-paginazione' onclick='mostraPagina(" + (paginaCorrente - 1) + ")'>&#8592; Precedente</button> ";
                            }
                            var totalePagine = Math.ceil(utenti.length / utentiPerPagina);
                            html += " Pagina " + paginaCorrente + " di " + totalePagine + " ";

                            if (paginaCorrente < totalePagine) {
                                html += "<button class='btn-paginazione' onclick='mostraPagina(" + (paginaCorrente + 1) + ")'>Successivo &#8594;</button>";
                            }


                            html += "</div>";

                            document.getElementById("dashboard-user").innerHTML = html;
                        }

                        mostraPagina(1);

                        window.mostraPagina = mostraPagina;

                    } catch (e) {
                        document.getElementById("dashboard-user").innerHTML = "<p>Errore nel formato dei dati ricevuti dal server.</p>";
                    }
                } else {
                    document.getElementById("dashboard-user").innerHTML = "<p>Errore server: codice " + xhr.status + "</p>";
                }
            }
        };
        xhr.send();
    }

    // Se la seconda tab è già attiva all'apertura, carica subito
    if(document.querySelector('section.table-section.active').id === "table2"){
        loadUserList();
    }
</script>

</body>
</html>
