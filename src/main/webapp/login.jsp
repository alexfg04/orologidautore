<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login / Registrazione</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.14.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">
    <style>
        /* Quadrato semplice con notifiche */
        .error-notification {
            width: 350px;
            height: 150px;
            background-color: #009688; /* Colore per errore */
            color: white;
            font-size: 16px;
            font-weight: bold;
            display: flex;
            justify-content: center;
            align-items: center;
            text-align: center;
            position: absolute; /* Cambiato da fixed a absolute per tenerlo sopra il form */
            top: 10px; /* Distanza dal top per renderlo visibile sopra il form */
            left: 50%;
            transform: translateX(-50%);
            box-shadow: 0 3px 8px rgba(0, 0, 0, 0.3);
            opacity: 0; /* Inizia invisibile */
            animation: showNotification 0.5s forwards;
            transition: opacity 0.5s ease;
            padding: 10px;
            border-radius: 10px; /* Rende i bordi leggermente arrotondati */
            z-index: 1000; /* Assicurati che la notifica sia sopra gli altri elementi */
        }

        /* Animazione di apparizione */
        @keyframes showNotification {
            0% {
                opacity: 0;
                transform: translateX(-50%) scale(0.5);
            }
            100% {
                opacity: 1;
                transform: translateX(-50%) scale(1);
            }
        }

        /* X di chiusura */
        .error-notification .close {
            position: absolute;
            top: 10px;
            right: 10px;
            color: #000000;
            font-size: 20px;
            cursor: pointer;
        }

        /* Colori per il tipo di messaggio */
        .error-notification.danger { background-color: #009688;}
    </style>
</head>
<body>

<!-- ✅ NOTIFICA ERRORE (senza JSTL) -->
<%
    String errorMessage = (String) request.getAttribute("errorMessage");
    if (errorMessage != null && !errorMessage.isEmpty()) {
%>
<div id="errorNotification" class="error-notification danger">
    <%= errorMessage %>
    <span class="close">×</span>
</div>
<%
    }
%>

<div class="container" id="container">
    <div class="form-container sign-up-container">
        <form action="RegisterServlet" method="post">
            <h1>Crea il tuo Account</h1>
            <br>
            <span>o accedi ad un profilo esistente</span>
            <input type="text" name="name" placeholder="Nome" required />
            <input type="email" name="email" placeholder="Email" required />
            <input type="password" name="password" placeholder="Password" required />
            <button type="submit">Crea!</button>
        </form>
    </div>

    <div class="form-container sign-in-container">
        <form action="LoginServlet" method="post">
            <h1>Accedi</h1>
            <br>
            <span>o crea un nuovo account</span>
            <input type="email" name="email" placeholder="Email" required />
            <input type="password" name="password" placeholder="Password" required />
            <a href="#">Non ricordi la password?</a>
            <button type="submit">Accedi</button>
        </form>
    </div>

    <div class="overlay-container">
        <div class="overlay">
            <div class="overlay-panel overlay-left">
                <h1>Benvenuto!</h1>
                <p>Inserisci i tuoi dati personali e inizia il tuo viaggio con noi.</p>
                <button class="ghost" id="signIn">Accedi</button>
            </div>
            <div class="overlay-panel overlay-right">
                <h1>Ciao, Boss!</h1>
                <p>Per rimanere in contatto con noi accedi con i tuoi dati personali</p>
                <button class="ghost" id="signUp">Crea</button>
            </div>
        </div>
    </div>
</div>

<script>
    window.onload = function () {
        var errorNotification = document.getElementById("errorNotification");

        // Mostra la notifica se c'è un messaggio
        if (errorNotification) {
            setTimeout(function () {
                // Nascondi la notifica dopo 4 secondi
                errorNotification.style.opacity = 0;
                setTimeout(function() {
                    errorNotification.style.display = "none"; // Nasconde completamente il div dopo che è sparita
                }, 500); // Attendi 500ms prima di nasconderlo
            }, 4000); // 4000ms = 4 secondi

            // Funzione per chiudere la notifica quando si clicca sulla X
            document.querySelector(".close").addEventListener("click", function () {
                errorNotification.style.opacity = 0;
                setTimeout(function() {
                    errorNotification.style.display = "none";
                }, 500); // Nasconde completamente il div dopo che è sparita
            });
        }
    };
</script>

<script src="js/script.js"></script>

</body>
</html>
