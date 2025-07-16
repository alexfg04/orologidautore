<%@ page import="com.r1.ecommerceproject.model.ProductBean" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
    ProductBean product = (ProductBean) request.getAttribute("product");
    if (product == null) {
        response.sendRedirect(request.getContextPath() + "/catalog");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">

    <title><%= product.getNome() %> - Dettagli Prodotto</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/product-detail.css">
</head>
<style>
    .star-rating {
        font-size: 2rem;
        unicode-bidi: bidi-override;
        direction: ltr; /* normale */
        display: inline-flex;
        flex-direction: row-reverse; /* *importante* per fare il trucco */
    }

    .star-rating input[type="radio"] {
        display: none;
    }

    .star-rating label {
        color: #ccc;
        cursor: pointer;
        user-select: none;
        transition: color 0.2s ease-in-out;
    }

    /* Coloro la stella selezionata e tutte quelle "precedenti" usando flex-row-reverse + ~ */
    .star-rating input[type="radio"]:checked ~ label,
    .star-rating label:hover,
    .star-rating label:hover ~ label {
        color: #f5b301;
    }

    /* Quadrato semplice con notifiche */
    .error-notification {
        width: 350px;
        height: 75px;
        background-color: #009688; /* Colore per errore */
        color: white;
        font-size: 16px;
        font-weight: bold;
        display: flex;
        justify-content: center;
        align-items: center;
        text-align: center;
        position: absolute; /* Cambiato da fixed a absolute per tenerlo sopra il form */
        bottom: 24px;
        right: 12px;
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
            transform: scale(0.5);
        }
        100% {
            opacity: 1;
            transform: scale(1);
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
<body>
<%@ include file="navbar.jsp"%>
<%
    String flashMessage = (String) session.getAttribute("flashMessage");
    if ((flashMessage != null && !flashMessage.isEmpty())) {
%>
<div id="errorNotification" class="error-notification danger">
    <%= flashMessage %>
    <span class="close">×</span>
</div>
<%
        session.removeAttribute("flashMessage");
    }
%>
<div class="detail-container">
    <div class="detail-card">
        <div class="detail-img">
            <img src="<%= product.getImmagine() %>"
                 alt="Immagine di <%= product.getNome() %>">
        </div>






        <div class="detail-info">
            <h1><%= product.getNome() %>
            </h1>
            <p class="price">€ <%= String.format("%.2f", product.getPrezzo()) %>
            <p class="one-size-box">ONE SIZE</p>




            <div class="tabs">
                <button class="tab-link active" data-tab="desc">Descrizione</button>
                <button class="tab-link" data-tab="specs">Specifiche</button>
            </div>
            <div class="tab-content" id="desc">
                <p><%= product.getDescrizione() %></p>
            </div>
            <div class="tab-content" id="specs">

                <ul>
                    <li><strong>Marca:</strong> <%= product.getMarca() %>
                    </li>
                    <li><strong>Modello:</strong> <%= product.getModello() %>
                    </li>
                    <li><strong>Categoria:</strong> <%= product.getCategoria() %>
                    </li>
                    <li><strong>Taglia:</strong> <%= product.getTaglia() %>
                    </li>
                    <li><strong>Materiale:</strong> <%= product.getMateriale() %>
                    </li>
                </ul>
            </div>


            <form action="<%= request.getContextPath() %>/cart" method="post" class="product-form">
                <input type="hidden" name="product_id" value="<%= product.getCodiceProdotto() %>">
                <div class="form-group">
                    <label for="quantity">Quantità:</label>
                    <input type="number" id="quantity" name="quantity" min="1" value="1">
                </div>
                <button type="submit" class="add-to-cart-button">Aggiungi al Carrello</button>
            </form>

            <%
                // Recupera l'id utente dalla sessione
                Object userIdObj = session.getAttribute("userId");

                if (userIdObj == null) {
            %>
            <p>Devi essere <a href="<%= request.getContextPath() + "/login.jsp" %>">loggato</a> per lasciare una recensione.</p>
            <%
            } else {
            %>
            <!-- Form recensione visibile SOLO se l'utente è loggato -->
            <form action="<%= request.getContextPath() %>/submitReview" method="post" class="review-form">
                <input type="hidden" name="codiceProdotto" value="<%= product.getCodiceProdotto() %>">

                <label for="valutazione">Valutazione:</label>
                <div class="star-rating">
                    <input type="radio" id="star5" name="valutazione" value="5" required />
                    <label for="star5" title="5 stelle">★</label>

                    <input type="radio" id="star4" name="valutazione" value="4" />
                    <label for="star4" title="4 stelle">★</label>

                    <input type="radio" id="star3" name="valutazione" value="3" />
                    <label for="star3" title="3 stelle">★</label>

                    <input type="radio" id="star2" name="valutazione" value="2" />
                    <label for="star2" title="2 stelle">★</label>

                    <input type="radio" id="star1" name="valutazione" value="1" />
                    <label for="star1" title="1 stella">★</label>
                </div>

                <label for="commento">Commento:</label>
                <textarea id="commento" name="commento" rows="4" cols="50" required></textarea>

                <button type="submit">Invia Recensione</button>
            </form>
            <%
                }
            %>

            <form id="favForm"  action="${pageContext.request.contextPath}/favorite"  method="post" class="product-form">
                <input type="hidden" name="productId" value="<%= product.getCodiceProdotto() %>">
                <button type="submit" class="add-to-favorites-button">♡ Aggiungi ai Preferiti</button>
            </form>
        </div>
    </div>


</div>

<div class="review-box">
    <h3 class="review-title">Lascia una recensione</h3>

    <div class="star-rating">
        <span class="star" data-value="1">&#9733;</span>
        <span class="star" data-value="2">&#9733;</span>
        <span class="star" data-value="3">&#9733;</span>
        <span class="star" data-value="4">&#9733;</span>
        <span class="star" data-value="5">&#9733;</span>
    </div>

    <textarea class="review-text" placeholder="Scrivi qui la tua recensione..."></textarea>

    <button class="submit-review">Invia</button>
</div>

<h2 class="recensioni-titolo">Recensioni degli utenti</h2>
<div class="recensioni-lista">
    <div class="recensione-item">
        <div class="recensione-stars">
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
            <span class="star">&#9734;</span>
        </div>
        <p class="recensione-commento">Bellissimo orologio, qualità top!</p>
    </div>

    <div class="recensione-item">
        <div class="recensione-stars">
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
            <span class="star">&#9734;</span>
            <span class="star">&#9734;</span>
        </div>
        <p class="recensione-commento">Buon prodotto, ma la spedizione è stata lenta.</p>
    </div>

    <div class="recensione-item">
        <div class="recensione-stars">
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
            <span class="star">&#9734;</span>
            <span class="star">&#9734;</span>
            <span class="star">&#9734;</span>
        </div>
        <p class="recensione-commento">Carino ma più piccolo del previsto.</p>
    </div>

    <div class="recensione-item">
        <div class="recensione-stars">
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
        </div>
        <p class="recensione-commento">Perfetto in ogni dettaglio. Consigliatissimo!</p>
    </div>

    <div class="recensione-item">
        <div class="recensione-stars">
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
            <span class="star">&#9734;</span>
            <span class="star">&#9734;</span>
        </div>
        <p class="recensione-commento">Design elegante, ma il cinturino poteva essere più comodo.</p>
    </div>

    <div class="recensione-item">
        <div class="recensione-stars">
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
            <span class="star">&#9734;</span>
        </div>
        <p class="recensione-commento">Ottimo rapporto qualità-prezzo, funziona benissimo.</p>
    </div>

    <div class="recensione-item">
        <div class="recensione-stars">
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
            <span class="star">&#9734;</span>
            <span class="star">&#9734;</span>
            <span class="star">&#9734;</span>
        </div>
        <p class="recensione-commento">Mi aspettavo di più, le immagini sembravano migliori.</p>
    </div>

    <div class="recensione-item">
        <div class="recensione-stars">
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
        </div>
        <p class="recensione-commento">Arrivato in anticipo! Bellissimo e ben confezionato.</p>
    </div>

    <div class="recensione-item">
        <div class="recensione-stars">
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
            <span class="star">&#9734;</span>
            <span class="star">&#9734;</span>
        </div>
        <p class="recensione-commento">Buon acquisto, anche se il colore è leggermente diverso.</p>
    </div>

    <div class="recensione-item">
        <div class="recensione-stars">
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
            <span class="star">&#9733;</span>
        </div>
        <p class="recensione-commento">Semplicemente perfetto, super soddisfatto dell'acquisto!</p>
    </div>



</div>




<script src="https://unpkg.com/lucide@latest"></script>
<script src="${pageContext.request.contextPath}/assets/js/toast.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/product-script.js"></script>

<script>
    lucide.createIcons();
</script>
<script>
    // Tab switching
    document.querySelectorAll('.tab-link').forEach(btn => {
        btn.addEventListener('click', () => {
            document.querySelectorAll('.tab-link').forEach(b => b.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(c => c.style.display = 'none');
            btn.classList.add('active');
            document.getElementById(btn.getAttribute('data-tab')).style.display = 'block';
        });
    });
</script>
<script>
    const stars = document.querySelectorAll('.star');
    let selectedRating = 0;

    stars.forEach(star => {
        star.addEventListener('mouseover', () => {
            const val = parseInt(star.dataset.value);
            stars.forEach(s => s.classList.toggle('hovered', parseInt(s.dataset.value) <= val));
        });

        star.addEventListener('mouseout', () => {
            stars.forEach(s => s.classList.remove('hovered'));
        });

        star.addEventListener('click', () => {
            selectedRating = parseInt(star.dataset.value);
            stars.forEach(s => s.classList.toggle('selected', parseInt(s.dataset.value) <= selectedRating));
        });
    });
</script>

</body>
</html>
