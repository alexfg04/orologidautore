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
