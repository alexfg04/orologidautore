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
    <title><%= product.getNome() %> - Dettagli Prodotto</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
            <p class="price">€ <%= String.format("%.2f", product.getPrezzo()) %></p>
            <h2>Taglia</h2>
            <p class="one-size-box">ONE SIZE</p>
            <form action="<%= request.getContextPath() %>/cart" method="post" class="product-form">
                <input type="hidden" name="product_id" value="<%= product.getCodiceProdotto() %>">
                <div class="form-group">
                    <label for="quantity">Quantità:</label>
                    <input type="number" id="quantity" name="quantity" min="1" value="1">
                </div>
                <button type="submit" class="add-to-cart-button">Aggiungi al Carrello</button>
            </form>
            <form id="favForm"  action="${pageContext.request.contextPath}/favorite"  method="post" class="product-form">
                <input type="hidden" name="productId" value="<%= product.getCodiceProdotto() %>">
                <button type="submit" class="add-to-favorites-button">♡ Aggiungi ai Preferiti</button>
            </form>
            <br>
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
                    <li><strong>Genere:</strong> <%= product.getGenere() %>
                    </li>
                    <li><strong>Taglia:</strong> <%= product.getTaglia() %>
                    </li>
                    <li><strong>Materiale:</strong> <%= product.getMateriale() %>
                    </li>
                </ul>
            </div>

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

                <button type="submit" class="submit-button">Invia Recensione</button>
            </form>
            <%
                }
            %>
        </div>
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
<script src="assets/js/navbar.js"></script>
</body>
</html>
