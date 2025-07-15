<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="it">
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>FAQ - Domande Frequenti</title>
    <link rel="stylesheet" href="assets/css/Faq.css" /> 
</head>

<body>

<jsp:include page="navbar.jsp" />

<div class="faq-container">
    <nav class="faq-sidebar">
        <ul id="faq-categories">
            <li data-target="general">Generale</li>
            <li data-target="ordini">Consegna e Ritiro</li>
            <li data-target="pagamenti">Ordini e Pagamenti</li>
            <li data-target="spedizioni">Resi e Rimborsi</li>
            <li data-target="account">Il Mio Account</li>
            <li data-target="politiche">Politiche del Sito</li>
            <li data-target="about">About Us</li>
        </ul>
    </nav>

    <div class="faq-content">


        <section id="general" class="faq-section">
            <h2>Domande Generali</h2>
            <div>
                <div class="faq-question">Come posso contattarvi?</div>
                <div class="faq-answer">Puoi contattarci tramite email all'indirizzo email OrologiDautore@gmail.com o chiamando il numero 334734893.</div>

                <div class="faq-question">Quali sono gli orari di apertura?</div>
                <div class="faq-answer">Siamo aperti dal lunedì al venerdì, dalle 9:00 alle 18:00.</div>

                <div class="faq-question">Dove si trova la vostra sede?</div>
                <div class="faq-answer">La nostra sede è a Milano, Via degli Artisti 10.</div>

                <div class="faq-question">Posso ricevere assistenza anche nei giorni festivi?</div>
                <div class="faq-answer">No, l'assistenza non è disponibile nei giorni festivi nazionali.</div>
            </div>
        </section>

        <section id="ordini" class="faq-section">
            <h2>Domande su Consegna e Ritiro</h2>
            <div>
                <div class="faq-question">Come posso tracciare il mio ordine?</div>
                <div class="faq-answer">Accedi al tuo account e clicca su "I miei ordini" per tracciare lo stato.</div>

                <div class="faq-question">Oneri doganali e dazzi all'importazione</div>
                <div class="faq-answer">Se ordini da fuori dell'UE, potrebbero esserci dazi e tasse di importazione da pagare. Contatta la dogana locale.</div>

                <div class="faq-question">Cosa succede se non sono a casa alla consegna?</div>
                <div class="faq-answer">Il corriere tenterà una nuova consegna oppure lascerà un avviso per il ritiro in deposito.</div>

                <div class="faq-question">Posso scegliere una data precisa per la consegna?</div>
                <div class="faq-answer">No, ma puoi indicare preferenze nel campo note dell’ordine. Faremo il possibile per accontentarti.</div>
            </div>
        </section>

        <section id="pagamenti" class="faq-section">
            <h2>Domande su Ordini e Pagamenti</h2>
            <div>
                <div class="faq-question">Quali metodi di pagamento accettate?</div>
                <div class="faq-answer">Carte di credito, PayPal e bonifico bancario.</div>

                <div class="faq-question">Il pagamento è sicuro?</div>
                <div class="faq-answer">Sì, utilizziamo protocolli di crittografia SSL e partner certificati per garantire la sicurezza.</div>

                <div class="faq-question">È possibile pagare alla consegna?</div>
                <div class="faq-answer">No, al momento non offriamo il contrassegno come metodo di pagamento.</div>
            </div>
        </section>

        <section id="spedizioni" class="faq-section">
            <h2>Domande su Resi e Rimborsi</h2>
            <div>
                <div class="faq-question">Come posso richiedere un rimborso?</div>
                <div class="faq-answer">Contatta l'assistenza entro 14 giorni dalla ricezione dell’ordine.</div>

                <div class="faq-question">Quanto tempo ci vuole per ricevere il rimborso?</div>
                <div class="faq-answer">Una volta approvato, il rimborso viene emesso entro 5-7 giorni lavorativi.</div>

                <div class="faq-question">Chi paga le spese di spedizione del reso?</div>
                <div class="faq-answer">Le spese di reso sono a carico del cliente, salvo prodotti difettosi o errati.</div>

                <div class="faq-question">Posso cambiare un prodotto invece di restituirlo?</div>
                <div class="faq-answer">Sì, puoi richiedere una sostituzione invece del rimborso, contattando il nostro supporto.</div>
            </div>
        </section>

        <section id="account" class="faq-section">
            <h2>Domande sull'Account</h2>
            <div>
                <div class="faq-question">Come faccio a registrarmi per un account?</div>
                <div class="faq-answer">Registrati tramite la pagina dedicata, usando un'email valida.</div>
            </div>
            <div>
                <div class="faq-question">Come faccio a comprare online?</div>
                <div class="faq-answer">Cerca articoli, aggiungili al carrello e completa il checkout.</div>
            </div>
        </section>

        <section id="politiche" class="faq-section">
            <h2>Politiche del Sito</h2>
            <div>
                <div class="faq-question">Chi siamo</div>
                <div class="faq-answer">Siamo un'azienda impegnata a offrire prodotti di qualità e un'esperienza d'acquisto eccellente.</div>
            </div>
            <div>
                <div class="faq-question">Effettuare un ordine</div>
                <div class="faq-answer">Puoi effettuare un ordine online selezionando i prodotti e completando il checkout.</div>
            </div>
            <div>
                <div class="faq-question">Descrizione e prezzo delle merci</div>
                <div class="faq-answer">I prodotti sono descritti accuratamente. I prezzi includono IVA, salvo diversa indicazione.</div>
            </div>
            <div>
                <div class="faq-question">Reclami</div>
                <div class="faq-answer">Contatta il servizio clienti via email o telefono per presentare un reclamo.</div>
            </div>
            <div>
                <div class="faq-question">Carte regalo</div>
                <div class="faq-answer">Valide 12 mesi. Utilizzabili solo sul nostro sito.</div>
            </div>
            <div>
                <div class="faq-question">Prevenzione delle frodi</div>
                <div class="faq-answer">Usiamo misure di sicurezza avanzate per prevenire attività fraudolente.</div>
            </div>
            <div>
                <div class="faq-question">Prodotti non ammissibili alla restituzione</div>
                <div class="faq-answer">Articoli personalizzati o igienici non possono essere restituiti.</div>
            </div>
            <div>
                <div class="faq-question">Offerte, promozioni e concorsi</div>
                <div class="faq-answer">Soggetti a condizioni specifiche, indicate caso per caso sul sito.</div>
            </div>
        </section>
        <section id="about" class="faq-section">
            <h2>About Us</h2>
            <div>
                <div class="faq-question">Carriere</div>
                <div class="faq-answer">Consulta la nostra pagina Lavora con noi per scoprire le posizioni aperte e candidarti.</div>
            </div>
            <div>
                <div class="faq-question">Promotion Terms</div>
                <div class="faq-answer">Le promozioni sono soggette a disponibilità e condizioni indicate per ciascuna offerta.</div>
            </div>
            <div>
                <div class="faq-question">Terms and Conditions</div>
                <div class="faq-answer">Utilizzando il sito accetti i nostri termini e condizioni disponibili nella pagina legale.</div>
            </div>
            <div>
                <div class="faq-question">Sitemap</div>
                <div class="faq-answer">La mappa del sito fornisce una panoramica organizzata delle sezioni e delle pagine disponibili.</div>
            </div>
        </section>
    </div>
</div>

<script>
    const categories = document.querySelectorAll('#faq-categories li');
    const sections = document.querySelectorAll('.faq-section');

    categories.forEach(cat => {
        cat.addEventListener('click', () => {
            const target = cat.getAttribute('data-target');
            activateSection(target);
            history.replaceState(null, null, '#' + target);
        });
    });

    function activateSection(targetId) {
        categories.forEach(c => {
            c.classList.toggle('active', c.getAttribute('data-target') === targetId);
        });
        sections.forEach(sec => {
            sec.classList.toggle('active', sec.id === targetId);
        });
    }

    window.addEventListener('DOMContentLoaded', () => {
        const hash = window.location.hash.replace('#', '') || 'general';
        activateSection(hash);
    });

    const questions = document.querySelectorAll('.faq-question');
    questions.forEach(q => {
        q.addEventListener('click', () => {
            const isActive = q.classList.contains('active');
            questions.forEach(item => {
                item.classList.remove('active');
                item.nextElementSibling.classList.remove('open');
            });
            if (!isActive) {
                q.classList.add('active');
                q.nextElementSibling.classList.add('open');
            }
        });
    });
</script>

</body>
</html>
