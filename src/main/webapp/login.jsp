<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login / Registrazione</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.14.0/css/all.min.css">
    <link rel="stylesheet" href="assets/css/login-page.css">
    <style>
        /* Quadrato semplice con notifiche */
        .error-notification {
            width: 350px;
            height: 100px;
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
        .error-notification.danger {
            background-color: #009688;
        }
    </style>
</head>
<body>
<%
    String errorMessage = (String) request.getAttribute("errorMessage");
    String flashMessage = (String) session.getAttribute("flashMessage");
    if ((errorMessage != null && !errorMessage.isEmpty()) || (flashMessage != null && !flashMessage.isEmpty())) {
%>
<div id="errorNotification" class="error-notification danger">
    <%= errorMessage != null ? errorMessage : flashMessage %>
    <span class="close">×</span>
</div>
<%
        session.removeAttribute("flashMessage");
    }
%>

<div class="container <%=request.getAttribute("rp") != null ? "right-panel-active no-animation" : ""%>"
     id="container">
    <div class="form-container sign-up-container">
        <form id="signup-form" action="${pageContext.request.contextPath}/signup" method="post">
            <h1>Crea il tuo Account</h1>
            <br>
            <span>o accedi ad un profilo esistente</span>
            <input type="text" name="name" placeholder="Nome"/>
            <input type="text" name="surname" placeholder="Cognome"/>
            <input type="date" name="birthDate" placeholder="Data di nascita"/>
            <input type="email" id="email" name="email" placeholder="email" onblur="checkEmailExists(this.value)"/>
            <input type="password" name="password" placeholder="Password"/>
            <button type="submit">Crea!</button>
        </form>
    </div>

    <div class="form-container sign-in-container">
        <form action="${pageContext.request.contextPath}/signin" method="post">
            <h1>Accedi</h1>
            <br>
            <span>o crea un nuovo account</span>
            <input type="email" name="email" placeholder="Email" required/>
            <input type="password" name="password" placeholder="Password" required/>
            <a href="forgot_password.jsp">Non ricordi la password?</a>
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
                <h1>Ciao, Utente!</h1>
                <p>Per rimanere in contatto con noi accedi con i tuoi dati personali</p>
                <button class="ghost" id="signUp">Crea</button>
                <button onclick="location.href='index.jsp'">Vai alla Home</button>
            </div>
        </div>
    </div>
</div>

<script src="assets/js/login_page.js"></script>
<script src="assets/js/toast.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        const AUTO_CLOSE_DELAY = 5000;

        const fadeOutAndRemove = (el, duration = 500) => {
            el.style.transition = `opacity ${duration}ms`;
            el.style.opacity = '0';
            setTimeout(() => el.remove(), duration);
        };

        const showNotification = (message) => {
            const notification = document.createElement('div');
            notification.className = 'error-notification danger';
            notification.innerHTML = message + '<span class="close">&times;</span>';
            document.body.appendChild(notification);
            const closeBtn = notification.querySelector('.close');
            closeBtn.addEventListener('click', () => fadeOutAndRemove(notification));
            setTimeout(() => fadeOutAndRemove(notification), AUTO_CLOSE_DELAY);
        };

        const signupForm = document.getElementById('signup-form');
        if (signupForm) {
            signupForm.addEventListener('submit', async (e) => {
                e.preventDefault();
                const formData = new FormData(signupForm);
                try {
                    const resp = await fetch(signupForm.action, {
                        method: 'POST',
                        headers: {'X-Requested-With': 'XMLHttpRequest'},
                        body: new URLSearchParams(formData)
                    });
                    const data = await resp.json();
                    if (data.success) {
                        showNotification(data.message);
                        document.getElementById('signIn').click();
                    } else {
                        showNotification(data.message);
                    }
                } catch (err) {
                    console.error(err);
                    showNotification('Errore durante la registrazione');
                }
            });
        }
    });
</script>

</body>
</html>
