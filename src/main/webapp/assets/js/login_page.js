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

const signUpButton = document.getElementById('signUp');
const signInButton = document.getElementById('signIn');
const container = document.getElementById('container');

signUpButton.addEventListener('click', () => {
    container.classList.add("right-panel-active");
});

signInButton.addEventListener('click', () => {
    container.classList.remove("right-panel-active");
});