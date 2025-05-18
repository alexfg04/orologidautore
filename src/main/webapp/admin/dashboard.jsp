<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dashboard</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Josefin+Sans:wght@300&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/admin/css/style.css" type="text/css">

    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>

    <style>
        /* Mostra solo la dashboard attiva */
        .dashboard-content { display: none; }
        .dashboard-content.active { display: block; }
    </style>
</head>
<body>

<section>
    <div class="left-div">
        <br>
        <h2 class="logo">M - <span style="font-weight:100;"></span></h2>
        <hr class="hr"/>
        <ul class="nav">
            <li data-dashboard="dashboard-home" class="active"><a href="#"><i class="fa fa-th-large"></i>Home</a></li>
            <li data-dashboard="dashboard-user"><a href="#"><i class="fa fa-user"></i>User</a></li>
            <li data-dashboard="dashboard-access"><a href="#"><i class="fa fa-key"></i>Access request</a></li>
            <li data-dashboard="dashboard-other1"><a href="#"><i class="fa fa-th-large"></i>Other 1</a></li>
            <li data-dashboard="dashboard-other2"><a href="#"><i class="fa fa-th-large"></i>Other 2</a></li>
        </ul>
        <br><br>
        <img src="${pageContext.request.contextPath}/admin/img/71218111_h.png" class="support" alt="Support Image">
    </div>

    <div class="right-div">
        <div id="main">
            <br>
            <div class="head">
                <div class="col-div-6">
                    <p>Dashboard</p>
                </div>
                <div class="col-div-6">
                    <div class="profile">
                        <img src="${pageContext.request.contextPath}/admin/img/ImgAdmin.png" class="pro-img" alt="Profile Image"/>
                        <p>${UtenteLoggato}&nbsp;<i class="fa fa-ellipsis-v dots"></i></p>
                        <div class="profile-div" style="display:none;">
                            <p><i class="fa fa-user"></i>&nbsp;&nbsp;Profile</p>
                            <p><i class="fa fa-cogs"></i>&nbsp;&nbsp;Settings</p>
                            <form action="${pageContext.request.contextPath}/logout" method="get" style="margin:0; padding:0;">
                                <button type="submit">&nbsp;&nbsp;Log Out</button>
                            </form>
                        </div>
                    </div>
                </div>

                <div class="clearfix"></div>
                <br><br><br>

                <!-- DASHBOARD HOME -->
                <div id="dashboard-home" class="dashboard-content active">
                    <!-- Contenuto della dashboard home come da file originale -->
                    <div class="col-div-4-1">
                        <div class="box">
                            <br>
                            <p class="head-1">Sales</p>
                            <p class="number">675847</p>
                            <p class="percent"><i class="fa fa-long-arrow-up"></i>5.674% <span>Since Last Months</span></p>
                            <i class="fa fa-line-chart box-icon"></i>
                        </div>
                    </div>

                    <div class="col-div-4-1">
                        <div class="box">
                            <br>
                            <p class="head-1">Purchases</p>
                            <p class="number">232342</p>
                            <p class="percent"><i class="fa fa-long-arrow-down"></i>12.674% <span>Since Last Months</span></p>
                            <i class="fa fa-circle-o-notch box-icon"></i>
                        </div>
                    </div>

                    <div class="col-div-4-1">
                        <div class="box">
                            <br>
                            <p class="head-1">Orders</p>
                            <p class="number">23244</p>
                            <p class="percent"><i class="fa fa-long-arrow-up"></i>5.674% <span>Since Last Months</span></p>
                            <i class="fa fa-shopping-bag box-icon"></i>
                        </div>
                    </div>

                    <div class="clearfix"></div>
                    <br><br>

                    <div class="col-div-4-1">
                        <div class="box-1">
                            <div class="content-box-1">
                                <p class="head-1">overview</p>
                                <br>
                                <div class="m-box active1">
                                    <p>Member Profit<br><span class="no-1">Last Months</span></p>
                                    <span class="no">+1133</span>
                                </div>

                                <div class="m-box">
                                    <p>Member Profit<br><span class="no-1">Last Months</span></p>
                                    <span class="no">+1133</span>
                                </div>

                                <div class="m-box">
                                    <p>Member Profit<br><span class="no-1">Last Months</span></p>
                                    <span class="no">+1133</span>
                                </div>

                                <div class="m-box">
                                    <p>Member Profit<br><span class="no-1">Last Months</span></p>
                                    <span class="no">+1133</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-div-4-1">
                        <div class="box-1">
                            <div class="content-box-1">
                                <p class="head-1">Total Sale<span>View All</span></p>

                                <div class="circle-wrap">
                                    <div class="circle">
                                        <div class="mask full">
                                            <div class="fill"></div>
                                        </div>
                                        <div class="mask half">
                                            <div class="fill"></div>
                                        </div>
                                        <div class="inside-circle">70%</div>
                                    </div>
                                </div>

                            </div>
                        </div>
                    </div>

                    <div class="col-div-4-1">
                        <div class="box-1">
                            <div class="content-box-1">
                                <p class="head-1">Activity <span>View All</span></p>
                                <br>
                                <p class="act-p"><i class="fa fa-circle"></i> Lorem Ipsum is simply dummy &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p>
                                <p class="act-p"><i class="fa fa-circle" style="color: red!important"></i> Lorem Ipsum is simply dummy &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p>
                                <p class="act-p"><i class="fa fa-circle" style="color: green!important"></i> Lorem Ipsum is simply dummy &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p>
                                <p class="act-p"><i class="fa fa-circle"></i> Lorem Ipsum is simply dummy &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</p>
                            </div>
                        </div>
                    </div>

                    <div class="clearfix"></div>
                </div>

                <!-- DASHBOARD USER -->
                <div id="dashboard-user" class="dashboard-content">
                    <h2>User Section</h2>
                    <p>Qui gestisci gli utenti.</p>
                    <!-- Puoi mettere altri contenuti o box simili -->
                </div>

                <!-- DASHBOARD ACCESS REQUEST -->
                <div id="dashboard-access" class="dashboard-content">
                    <h2>Access Request Section</h2>
                    <p>Gestione richieste di accesso.</p>
                    <!-- Contenuti simili o personalizzati -->
                </div>

                <!-- DASHBOARD OTHER 1 -->
                <div id="dashboard-other1" class="dashboard-content">
                    <h2>Other Section 1</h2>
                    <p>Contenuto alternativo per Other 1.</p>
                </div>

                <!-- DASHBOARD OTHER 2 -->
                <div id="dashboard-other2" class="dashboard-content">
                    <h2>Other Section 2</h2>
                    <p>Contenuto alternativo per Other 2.</p>
                </div>

            </div>
        </div>
    </div>

    <div class="clearfix"></div>
</section>

<script>
    function loadUserList() {
        console.log("✅ [JS] Inizio chiamata AJAX a /admin/users");

        var xhr = new XMLHttpRequest();
        xhr.open("GET", "/ecommerce_project_war_exploded/admin/users", true); // cambia /ecommerce col tuo context path

        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
                if (xhr.status === 200) {
                    try {
                        var utenti = JSON.parse(xhr.responseText);

                        var html = "<h2>Utenti registrati</h2>";
                        html += "<table border='1'><tr><th>Nome</th><th>Cognome</th><th>Email</th><th>Ruolo</th></tr>";

                        utenti.forEach(function(user) {
                            html += "<tr>" +
                                "<td>" + user.nome + "</td>" +
                                "<td>" + user.cognome + "</td>" +
                                "<td>" + user.email + "</td>" +
                                "<td>" + user.tipologia + "</td>" +
                                "</tr>";
                        });

                        html += "</table>";
                        document.getElementById("dashboard-user").innerHTML = html;
                    } catch (e) {
                        document.getElementById("dashboard-user").innerHTML = "<p>Errore nel formato dei dati ricevuti dal server.</p>";
                    }
                } else {
                    document.getElementById("dashboard-user").innerHTML = "<p>Errore server: codice " + xhr.status + "</p>";
                }
            }
        };

        xhr.onerror = function() {
            document.getElementById("dashboard-user").innerHTML = "<p>Errore di rete durante la richiesta AJAX.</p>";
        };

        xhr.send();
    }

    document.addEventListener("DOMContentLoaded", function() {
        // Gestione menu laterale
        var navItems = document.querySelectorAll("ul.nav li");
        navItems.forEach(function(item) {
            item.addEventListener("click", function(e) {
                e.preventDefault();

                // Cambia la voce attiva nel menu
                navItems.forEach(i => i.classList.remove("active"));
                this.classList.add("active");

                // Mostra/nascondi sezioni
                var dashboardId = this.getAttribute("data-dashboard");
                document.querySelectorAll(".dashboard-content").forEach(div => {
                    div.classList.remove("active");
                    div.style.display = "none";
                });

                var selectedDiv = document.getElementById(dashboardId);
                selectedDiv.classList.add("active");
                selectedDiv.style.display = "block";

                // Se è la sezione utenti, carica i dati
                if (dashboardId === "dashboard-user") {
                    loadUserList();
                }
            });
        });

        // Carica subito gli utenti alla prima apertura
        loadUserList();

        // Gestione apertura/chiusura menu profilo (dots)
        var dots = document.querySelector(".dots");
        var profileDiv = document.querySelector(".profile-div");

        if (dots && profileDiv) {
            dots.addEventListener("click", function(e) {
                e.stopPropagation();  // evita che il click si propaga e chiuda subito il menu
                if (profileDiv.style.display === "block") {
                    profileDiv.style.display = "none";
                } else {
                    profileDiv.style.display = "block";
                }
            });

            // Chiudi il menu profilo cliccando fuori
            document.addEventListener("click", function() {
                profileDiv.style.display = "none";
            });
        }
    });
</script>


</body>
</html>
