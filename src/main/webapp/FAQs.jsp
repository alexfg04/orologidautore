<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>FAQ - Domande Frequenti con Accordion</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0; padding: 0;
            background: #f4f4f4;
        }
        .faq-container {
            display: flex;
            max-width: 90%;
            margin: 30px auto;
            background: #fff;
            border-radius: 6px;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
            min-height: 400px;
        }
        .faq-sidebar {
            width: 220px;
            border-right: 1px solid #ddd;
            background: #f9f9f9;
        }
        .faq-sidebar ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .faq-sidebar li {
            padding: 15px 20px;
            cursor: pointer;
            border-bottom: 1px solid #ddd;
            transition: background-color 0.3s ease;
        }
        .faq-sidebar li:hover {
            background-color: #e0f7fa;
        }
        .faq-sidebar li.active {
            background-color: #00796b;
            color: white;
            font-weight: bold;
        }
        .faq-content {
            flex: 1;
            padding: 25px 30px;
            overflow-y: auto;
        }
        .faq-section {
            display: none;
        }
        .faq-section.active {
            display: block;
        }
        /* Accordion style */
        .faq-question {
            font-weight: bold;
            color: #004d40;
            padding: 12px 15px;
            background-color: #e0f2f1;
            margin: 10px 0 0 0;
            border-radius: 4px;
            cursor: pointer;
            position: relative;
            user-select: none;
            transition: background-color 0.3s ease;
        }
        .faq-question:hover {
            background-color: #b2dfdb;
        }
        .faq-question::after {
            content: '+';
            position: absolute;
            right: 20px;
            font-size: 20px;
            line-height: 20px;
            top: 50%;
            transform: translateY(-50%);
            transition: transform 0.3s ease;
        }
        .faq-question.active::after {
            content: '-';
            transform: translateY(-50%);
        }
        .faq-answer {
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.35s ease;
            background: #fafafa;
            padding: 0 15px;
            border-left: 3px solid #00796b;
            border-radius: 0 4px 4px 0;
            color: #333;
            line-height: 1.5;
        }
        .faq-answer.open {
            padding: 15px;
            max-height: 500px; /* abbastanza per contenere la risposta */
        }
        /* Responsive */
        @media (max-width: 700px) {
            .faq-container {
                flex-direction: column;
                max-width: 100%;
                margin: 10px;
                min-height: auto;
            }
            .faq-sidebar {
                width: 100%;
                border-right: none;
                border-bottom: 1px solid #ddd;
            }
            .faq-content {
                padding: 15px 20px;
            }
        }
    </style>
</head>
<body>
<jsp:include page="navbar.jsp"></jsp:include>
<div class="faq-container">
    <nav class="faq-sidebar">
        <ul id="faq-categories">
            <li class="active" data-target="general">Generale</li>
            <li data-target="ordini">Consegna e Ritiro</li>
            <li data-target="pagamenti">Ordini e Pagamenti</li>
            <li data-target="spedizioni">Resi e Rimborsi</li>
            <li data-target="account">Il Mio Account</li>
            <li data-target="account">Politiche del Sito</li>
            <li data-target="account">Contattaci</li>
        </ul>
    </nav>

    <div class="faq-content">
        <section id="general" class="faq-section active">
            <h2>Domande Generali</h2>
            <div>
                <div class="faq-question">Come posso contattarvi?</div>
                <div class="faq-answer">Puoi contattarci tramite email all'indirizzo support@example.com o chiamando il numero 123-456-789.</div>
            </div>
            <div>
                <div class="faq-question">Quali sono gli orari di apertura?</div>
                <div class="faq-answer">Siamo aperti dal lunedì al venerdì, dalle 9:00 alle 18:00.</div>
            </div>
        </section>

        <section id="ordini" class="faq-section">
            <h2>Domande sugli Ordini</h2>
            <div>
                <div class="faq-question">Come posso tracciare il mio ordine?</div>
                <div class="faq-answer">Puoi tracciare il tuo ordine accedendo al tuo account e cliccando sulla sezione "I miei ordini".</div>
            </div>
            <div>
                <div class="faq-question">Posso modificare un ordine dopo averlo effettuato?</div>
                <div class="faq-answer">Le modifiche sono possibili solo entro 2 ore dall'acquisto contattando il nostro supporto.</div>
            </div>
        </section>

        <section id="pagamenti" class="faq-section">
            <h2>Domande sui Pagamenti</h2>
            <div>
                <div class="faq-question">Quali metodi di pagamento accettate?</div>
                <div class="faq-answer">Accettiamo carte di credito, PayPal e bonifico bancario.</div>
            </div>
            <div>
                <div class="faq-question">È sicuro pagare con carta di credito?</div>
                <div class="faq-answer">Sì, utilizziamo sistemi di pagamento sicuri e criptati per proteggere i tuoi dati.</div>
            </div>
        </section>

        <section id="spedizioni" class="faq-section">
            <h2>Domande sulle Spedizioni</h2>
            <div>
                <div class="faq-question">Quanto tempo impiega la spedizione?</div>
                <div class="faq-answer">Le spedizioni standard impiegano 3-5 giorni lavorativi.</div>
            </div>
            <div>
                <div class="faq-question">Posso cambiare l'indirizzo di consegna?</div>
                <div class="faq-answer">Puoi modificare l'indirizzo solo prima della spedizione contattando l'assistenza.</div>
            </div>
        </section>

        <section id="account" class="faq-section">
            <h2>Domande sull'Account</h2>
            <div>
                <div class="faq-question">Come posso recuperare la password?</div>
                <div class="faq-answer">Usa la funzione "Password dimenticata" nella pagina di login per reimpostare la password.</div>
            </div>
            <div>
                <div class="faq-question">Come posso cancellare il mio account?</div>
                <div class="faq-answer">Contatta il nostro supporto per richiedere la cancellazione del tuo account.</div>
            </div>
        </section>
    </div>
</div>

<script>
    // Cambio sezione lato sinistro
    const categories = document.querySelectorAll('#faq-categories li');
    const sections = document.querySelectorAll('.faq-section');

    categories.forEach(cat => {
        cat.addEventListener('click', () => {
            categories.forEach(c => c.classList.remove('active'));
            cat.classList.add('active');

            sections.forEach(sec => sec.classList.remove('active'));
            const target = cat.getAttribute('data-target');
            document.getElementById(target).classList.add('active');
        });
    });

    // Accordion domande
    const questions = document.querySelectorAll('.faq-question');
    questions.forEach(q => {
        q.addEventListener('click', () => {
            const isActive = q.classList.contains('active');
            // Chiudo tutte le risposte aperte
            questions.forEach(item => {
                item.classList.remove('active');
                item.nextElementSibling.classList.remove('open');
            });
            // Se non era attiva la apro
            if (!isActive) {
                q.classList.add('active');
                q.nextElementSibling.classList.add('open');
            }
        });
    });
</script>
</body>
</html>
