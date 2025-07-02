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
    xhr.open("GET", window.location.origin + "/admin/users", true);

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
                                "<form method='post' action='/ecommerce_project_war_exploded/servlet/admin/product'>" +
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
    xhr.open("GET", window.location.origin + contextPath + "/servlet/admin/users", true);

    xhr.onreadystatechange = function() {
        if (xhr.readyState === 4) {
            if (xhr.status === 200) {
                try {
                    var prodotti = JSON.parse(xhr.responseText);

                    var html = "<table><thead><tr>" +
                        "<th>Nome</th><th>Marca</th><th>Categoria</th><th>Prezzo</th><th>Modello</th>" +
                        "<th>Descrizione</th><th>Taglia</th><th>Materiale</th><th>Immagine</th>" +
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
