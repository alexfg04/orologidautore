
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Dashboard con Tabella Utenti AJAX</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/style.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />
    <style>
        /* Container form */
        #tableAddProduct form {
            max-width: 600px;
            margin: 20px auto;
            background: #f9f9f9;
            padding: 20px 30px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* Form fields */
        #tableAddProduct form div {
            margin-bottom: 15px;
            display: flex;
            flex-direction: column;
        }

        /* Label styling */
        #tableAddProduct label {
            font-weight: 600;
            margin-bottom: 6px;
            color: #004d40;
        }

        /* Inputs and textarea */
        #tableAddProduct input[type="text"],
        #tableAddProduct input[type="number"],
        #tableAddProduct input[type="file"],
        #tableAddProduct textarea {
            padding: 8px 12px;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }

        #tableAddProduct input[type="text"]:focus,
        #tableAddProduct input[type="number"]:focus,
        #tableAddProduct input[type="file"]:focus,
        #tableAddProduct textarea:focus {
            border-color: #00796b;
            outline: none;
        }

        /* Textarea resize */
        #tableAddProduct textarea {
            resize: vertical;
            min-height: 80px;
        }

        /* Submit button */
        #tableAddProduct button[type="submit"] {
            background-color: #00796b;
            color: white;
            padding: 10px 20px;
            font-weight: 700;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 1.1rem;
            transition: background-color 0.3s ease;
        }

        #tableAddProduct button[type="submit"]:hover {
            background-color: #004d40;
        }

        /* Responsive */
        @media (max-width: 640px) {
            #tableAddProduct form {
                padding: 15px 20px;
            }
        }
    </style>
</head>
<body>

<button class="hamburger" aria-label="Apri menu" aria-expanded="false">&#9776;</button>

<nav class="sidebar" id="sidebar">
    <h2>Menu</h2>
    <a href="#" class="active" onclick="showTable('table1', this)">Tabella 1</a>
    <a href="#" onclick="showTable('table2', this)">Tabella 2</a>
    <a href="#" onclick="showTable('table3', this)">Tabella 3</a>
    <a href="#" onclick="showTable('tableProdotti', this)">Prodotti</a>
    <a href="#" onclick="showTable('tableAddProduct', this)">Aggiungi Prodotto</a>


</nav>

<div class="overlay" id="overlay"></div>

<main class="content" id="content">
    <div class="header-container">
        <div class="user-logo">
            <img src="${pageContext.request.contextPath}/admin/Admin_IMG/logon.png" alt="Logo" />
        </div>
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
    </div>

    <section id="table1" class="table-section active">
        <!-- Box informativi -->
        <div class="dashboard-boxes">
            <div class="box">
                <h3 style="text-align: left">Vendite</h3>
                <h1 style="text-align: left; margin-bottom: 1px;">1000</h1>
                <p class="percent"><i class="fa fa-long-arrow-up"></i>5.674% <span>Since Last Months</span></p>
                <i class="fa fa-line-chart box-icon"></i>
            </div>
            <div class="box">
                <h3 style="text-align: left">Vendite</h3>
                <h1 style="text-align: left; margin-bottom: 1px;">1000</h1>
                <p class="percent"><i class="fa fa-long-arrow-down"></i>12.674% <span>Since Last Months</span></p>
                <i class="fa fa-circle-o-notch box-icon"></i>
            </div>
            <div class="box">
                <h3 style="text-align: left">Vendite</h3>
                <h1 style="text-align: left; margin-bottom: 1px;">1000</h1>
                <p class="percent"><i class="fa fa-long-arrow-up"></i>5.674% <span>Since Last Months</span></p>
                <i class="fa fa-shopping-bag box-icon"></i>
            </div>
        </div>

        <!-- Grafico -->
        <div class="chart-container">
            <canvas id="myChart"></canvas>
        </div>
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

    <section id="tableProdotti" class="table-section">
        <h3>Tabella Prodotti</h3>
        <div id="dashboard-products"> <!-- Tabella prodotti caricata dinamicamente qui --></div>
    </section>

    <section id="tableAddProduct" class="table-section">
        <h3>Aggiungi Nuovo Prodotto</h3>
        <form id="formAddProduct" method="post" action="${pageContext.request.contextPath}/admin/gestione" enctype="multipart/form-data">
            <div>
                <label for="nome">Nome:</label>
                <input type="text" id="nome" name="nome" required />
            </div>
            <div>
                <label for="marca">Marca:</label>
                <input type="text" id="marca" name="marca" required />
            </div>
            <div>
                <label for="categoria">Categoria:</label>
                <input type="text" id="categoria" name="categoria" required />
            </div>
            <div>
                <label for="modello">Modello:</label>
                <input type="text" id="modello" name="modello" required />
            </div>
            <div>
                <label for="descrizione">Descrizione:</label>
                <textarea id="descrizione" name="descrizione" rows="3" required></textarea>
            </div>
            <div>
                <label for="taglia">Taglia:</label>
                <input type="text" id="taglia" name="taglia" />
            </div>
            <div>
                <label for="materiale">Materiale:</label>
                <input type="text" id="materiale" name="materiale" />
            </div>
            <div>
                <label for="prezzo">Prezzo (€):</label>
                <input type="number" id="prezzo" name="prezzo" step="0.01" min="0" required />
            </div>
            <div>
                <label for="image">Immagine:</label>
                <input type="file" id="image" name="image" accept="image/*" required />
            </div>
            <div>
                <button type="submit">Aggiungi Prodotto</button>
            </div>
        </form>
    </section>

</main>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // Chart.js
    function getDatiMensili() {
        return [10, 12, 9, 14, 18, 20, 25, 22, 17, 15, 13, 11]; // dati esempio
    }

    const ctx = document.getElementById('myChart').getContext('2d');

    const myChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio', 'Giugno',
                'Luglio', 'Agosto', 'Settembre', 'Ottobre', 'Novembre', 'Dicembre'],
            datasets: [{
                label: 'Vendite mensili',
                data: getDatiMensili(),
                backgroundColor: 'rgba(0,77,64,0.52)',
                borderColor: 'rgb(0,77,64)',
                borderWidth: 0
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });

    // Menu hamburger e overlay
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
        if(id === "tableProdotti"){
            loadProductList();
        }
    }


    // Dropdown utente
    function toggleDropdown(button) {
        const dropdown = button.parentElement;
        const isOpen = dropdown.classList.toggle('open');
        // Chiude altri dropdown aperti
        document.querySelectorAll('.dropdown.open').forEach(d => {
            if (d !== dropdown) d.classList.remove('open');
        });
    }

    // Chiude menu se ridimensionamento viewport grande
    window.addEventListener('resize', () => {
        if(window.innerWidth > 600) {
            sidebar.classList.remove('open');
            overlay.classList.remove('show');
            hamburger.setAttribute('aria-expanded', false);
            content.classList.remove('menu-open');
        }
    });

    // Chiude dropdown se click esterno
    window.addEventListener('click', (e) => {
        if (!e.target.closest('.dropdown')) {
            document.querySelectorAll('.dropdown.open').forEach(d => d.classList.remove('open'));
        }
    });

    // Carica lista utenti via AJAX con paginazione
    let utentiCaricati = false;
    function loadUserList() {
        if(utentiCaricati) return; // evita chiamate ripetute inutili
        utentiCaricati = true;

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

                            var html = "<table><thead><tr><th>Nome</th><th>Cognome</th><th>Email</th><th>Ruolo</th><th>Info</th></tr></thead><tbody>";

                            paginaUtenti.forEach(function(user) {
                                html += "<tr>" +
                                    "<td>" + user.nome + "</td>" +
                                    "<td>" + user.cognome + "</td>" +
                                    "<td>" + user.email + "</td>" +
                                    "<td>" + user.tipologia + "</td>" +
                                    "<td>" +
                                    "<form method='post' action='/ecommerce_project_war_exploded/admin/userInfo'>" +
                                    "<input type='hidden' name='email' value='" + user.email + "' />" +
                                    "<button type='submit'>Info</button>" +
                                    "</form>" +
                                    "</td>" +
                                    "</tr>";
                            });

                            html += "</tbody></table>";

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

    // Caricamento iniziale se sezione utenti è attiva
    window.onload = () => {
        if(document.querySelector('section.table-section.active').id === "table2"){
            loadUserList();
        }
    };

    function loadProductList() {
        console.log("✅ [JS] Inizio chiamata AJAX a /admin/products");

        var xhr = new XMLHttpRequest();
        xhr.open("GET", "${pageContext.request.contextPath}/admin/products", true);

        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    try {
                        var prodotti = JSON.parse(xhr.responseText);

                        var html = "<table><thead><tr>" +
                            "<th>Nome</th><th>Marca</th><th>Categoria</th><th>Prezzo</th><th>Modello</th>" +
                            "<th>Descrizione</th><th>Taglia</th><th>Materiale</th><th>Immagine</th><th>Azione</th>" +
                            "</tr></thead><tbody>";

                        prodotti.forEach(function(prodotto) {
                            html += "<tr>" +

                                "<td>" + prodotto.nome + "</td>" +
                                "<td>" + prodotto.marca + "</td>" +
                                "<td>" + prodotto.categoria + "</td>" +
                                "<td>" + prodotto.prezzo + "€</td>" +
                                "<td>" + prodotto.modello + "</td>" +
                                "<td>" + prodotto.descrizione + "</td>" +
                                "<td>" + prodotto.taglia + "</td>" +
                                "<td>" + prodotto.materiale + "</td>" +
                                "<td><img src='" + prodotto.image_url + "' alt='immagine prodotto' style='max-width:50px; max-height:50px;'/></td>" +
                                "<td>" +
                                "<a href='gestione?action=delete&product_id=" + prodotto.codiceProdotto + "'>Elimina</a>" +
                                "</td>"
                            "</tr>";
                        });

                        html += "</tbody></table>";
                        document.getElementById("dashboard-products").innerHTML = html;

                    } catch (e) {
                        document.getElementById("dashboard-products").innerHTML = "<p>Errore nel formato dati prodotti.</p>";
                    }
                } else {
                    document.getElementById("dashboard-products").innerHTML = "<p>Errore server: codice " + xhr.status + "</p>";
                }
            }
        };
        xhr.send();
    }

</script>

</body>
</html>