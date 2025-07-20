<%@ page import="com.r1.ecommerceproject.utils.UserSession" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Dashboard</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fonts.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/style.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css" />


    <style>
        #filtro-date-container {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 10px;
            padding: 10px;
            background-color: #f0f4f8;
            border-radius: 8px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        #filtro-date-container label {
            font-weight: 500;
            color: #333;
        }

        #filtro-date-container input[type="date"],
        #filtro-date-container button {
            padding: 6px 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
        }

        #filtro-date-container button {
            background-color: #004d40;
            color: white;
            cursor: pointer;
            transition: background-color 0.2s ease-in-out;
        }

        #filtro-date-container button:hover {
            background-color: #00332c;
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
    <a href="#" class="active" onclick="showTable('table1', this)">Resoconto</a>
    <a href="#" onclick="showTable('table2', this)">Gestione Utenti</a>
    <a href="#" onclick="showTable('table3', this)">Ordini</a>
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
            <span class="user-name"><%= new UserSession(session).getFirstName() %></span>
            <div class="dropdown">
                <button onclick="toggleDropdown(this)">Menu &#x25BC;</button>
                <div class="dropdown-menu">
                    <form action="${pageContext.request.contextPath}/logout" method="get" style="margin:0; padding:0;">
                        <button type="submit">&nbsp;&nbsp;Log Out</button>
                    </form>
                    <button onclick="window.location.href='<%= request.getContextPath() %>/index.jsp'">Torna alla Home</button>
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
                <p class="percent"><i class="fa fa-long-arrow-up"></i>5.674% <span>Dagli ultimi mesi</span></p>
                <i class="fa fa-line-chart box-icon"></i>
            </div>
            <div class="box">
                <h3 style="text-align: left">Utenti</h3>
                <h1 style="text-align: left; margin-bottom: 1px;">450</h1>
                <p class="percent"><i class="fa fa-long-arrow-down"></i>12.674% <span>Dagli ultimi mesi</span></p>
                <i class="fa fa-circle-o-notch box-icon"></i>
            </div>
            <div class="box">
                <h3 style="text-align: left">Recensioni</h3>
                <h1 style="text-align: left; margin-bottom: 1px;">220</h1>
                <p class="percent"><i class="fa fa-long-arrow-up"></i>5.674% <span>Dagli ultimi mesi</span></p>
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

        <div id="filtro-date-container">
            <label for="start-date">Da:</label>
            <input type="date" id="start-date">

            <label for="end-date">A:</label>
            <input type="date" id="end-date">

            <button onclick="filtraOrdini()">Filtra</button>
        </div>

        <div id="dashboard-orders"></div>

    </section>



    <section id="tableProdotti" class="table-section">
        <h3>Tabella Prodotti</h3>
        <div id="dashboard-products"> <!-- Tabella prodotti caricata dinamicamente qui --></div>
    </section>

    <section id="tableAddProduct" class="table-section">
        <h3>Aggiungi Nuovo Prodotto</h3>
        <form id="formAddProduct" method="post" action="${pageContext.request.contextPath}/admin/add-product" enctype="multipart/form-data">
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
                <label for="tipo">Tipo</label>
                <input type="text" id="tipo" name="tipo" required>
            </div>
            <div>
                <label for="iva">Iva:</label>
                <input type="text" id="iva" name="iva" required />
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
                <input type="file" id="image" name="image" accept="image/*" />
            </div>
            <div>
                <button type="submit">Aggiungi Prodotto</button>
            </div>
        </form>
    </section>

</main>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    const ctx = document.getElementById('myChart').getContext('2d');

    const myChart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Gennaio', 'Febbraio', 'Marzo', 'Aprile', 'Maggio', 'Giugno',
                'Luglio', 'Agosto', 'Settembre', 'Ottobre', 'Novembre', 'Dicembre'],
            datasets: [{
                label: 'Ordini per mese',
                data: [], // dati caricati dinamicamente
                backgroundColor: 'rgba(0,77,64,0.52)',
                borderColor: 'rgb(0,77,64)',
                borderWidth: 1
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

    // Carica dati dinamicamente dalla servlet
    fetch('<%= request.getContextPath() %>/admin/dati-ordini-mensili')
        .then(response => response.json())
        .then(data => {
            myChart.data.datasets[0].data = data;
            myChart.update();
        })
        .catch(error => {
            console.error('Errore nel caricamento dati:', error);
            // fallback dati esempio
            myChart.data.datasets[0].data = [10, 12, 9, 14, 18, 20, 25, 22, 17, 15, 13, 11];
            myChart.update();
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
        if(id === "table3"){
            loadOrderList();
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

                            var html = "<table><thead><tr><th>ID Utente</th><th>Nome</th><th>Cognome</th><th>Email</th><th>Ruolo</th><th>Info</th></tr></thead><tbody>";


                            paginaUtenti.forEach(function(user) {
                                html += "<tr>" +
                                    "<td>" + user.id + "</td>" +
                                    "<td>" + user.nome + "</td>" +
                                    "<td>" + user.cognome + "</td>" +
                                    "<td>" + user.email + "</td>" +
                                    "<td>" + user.tipologia + "</td>" +
                                    "<td>" +
                                    "<button onclick=\"vaiAllaPaginaOrdini(" + user.id + ")\">Info</button>" +
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
        var contextPath = "${pageContext.request.contextPath}";

        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    try {
                        var prodotti = JSON.parse(xhr.responseText);

                        var html = "<table><thead><tr>" +
                            "<th>Nome</th><th>Marca</th><th>Genere</th><th>Prezzo</th><th>Modello</th>" +
                            "<th>Descrizione</th><th>Taglia</th><th>Materiale</th><th>Immagine</th>" +
                            "</tr></thead><tbody>";

                        prodotti.forEach(function(prodotto) {
                                html += "<tr class='clickable-row' onclick='window.location.href=\"" + contextPath + "/admin/modificaProdotto?id=" + prodotto.codiceProdotto + "\"'>" +
                                "<td>" + prodotto.nome + "</td>" +
                                "<td>" + prodotto.marca + "</td>" +
                                "<td>" + prodotto.categoria + "</td>" +
                                "<td>" + prodotto.prezzo + "€</td>" +
                                "<td>" + prodotto.modello + "</td>" +
                                "<td>" + prodotto.descrizione + "</td>" +
                                "<td>" + prodotto.taglia + "</td>" +
                                "<td>" + prodotto.materiale + "</td>" +
                                "<td><img src='" + prodotto.image_url + "' alt='immagine prodotto' style='max-width:50px; max-height:50px;'/></td>" +
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
    function vaiAllaPaginaOrdini(idUtente) {
        window.location.href = '${pageContext.request.contextPath}/admin/ordiniUtente?idUtente=' + idUtente;
    }

    let ordiniCaricati = false;

    function loadOrderList() {
        if (ordiniCaricati) return;
        ordiniCaricati = true;

        console.log("✅ [JS] Inizio chiamata AJAX a /ordini");

        var xhr = new XMLHttpRequest();
        xhr.open("GET", "${pageContext.request.contextPath}/ordini", true);

        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4) {
                const container = document.getElementById("dashboard-orders");

                if (xhr.status === 200) {
                    try {
                        var parser = new DOMParser();
                        var doc = parser.parseFromString(xhr.responseText, "text/html");
                        var tabella = doc.querySelector("table");

                        if (tabella) {
                            container.innerHTML = ""; // svuota prima di inserire
                            container.appendChild(tabella);
                        } else {
                            container.innerHTML = "<p>Nessun ordine disponibile.</p>";
                        }
                    } catch (e) {
                        container.innerHTML = "<p>Errore nel parsing della risposta.</p>";
                        console.error("Errore parsing:", e);
                    }
                } else {
                    container.innerHTML = "<p>Errore server: codice " + xhr.status + "</p>";
                }
            }
        };

        xhr.send();
    }

    function filtraOrdini() {
        const startDate = document.getElementById("start-date").value;
        const endDate = document.getElementById("end-date").value;

        const rows = document.querySelectorAll("#dashboard-orders table tbody tr");
        let visibili = 0;

        rows.forEach(row => {
            const cellDate = row.querySelector("td:nth-child(3)");
            if (!cellDate) return;

            const orderDate = cellDate.textContent.trim().substring(0, 10); // "YYYY-MM-DD"
            let mostra = true;

            if (startDate && orderDate < startDate) mostra = false;
            if (endDate && orderDate > endDate) mostra = false;

            row.style.display = mostra ? "" : "none";
            if (mostra) visibili++;
        });

        const noResults = document.getElementById("no-results-message");
        if (noResults) noResults.remove();
        if (visibili === 0) {
            const msg = document.createElement("p");
            msg.id = "no-results-message";
            msg.textContent = "Nessun ordine trovato nel range selezionato.";
            msg.style.padding = "10px";
            msg.style.fontStyle = "italic";
            document.querySelector("#dashboard-orders").appendChild(msg);
        }
    }
</script>

</body>
</html>