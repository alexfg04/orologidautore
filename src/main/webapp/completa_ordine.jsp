<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*, java.math.*, com.r1.ecommerceproject.model.ProductBean" %>

<%
    String nomeUtente = "Mario Rossi";
    String email = "mario.rossi@email.com";
    String telefono = "+39 345 678 9012";
    String indirizzo = "Via Milano 12, Roma";
    String metodoPagamento = "Mastercard **** 3456";

    ProductBean prodottoFinto = new ProductBean();
    prodottoFinto.setNome("Rolex Submariner");
    prodottoFinto.setPrezzo(new BigDecimal("8999.99"));
    prodottoFinto.setCodiceProdotto(1);
    String imgPath = "assets/img/orologi/rolex_submariner.jpg";

    HashMap<ProductBean, Integer> cartItems = new HashMap<>();
    cartItems.put(prodottoFinto, 1);

    BigDecimal totalPrice = BigDecimal.ZERO;
    for (ProductBean p : cartItems.keySet()) {
        totalPrice = totalPrice.add(p.getPrezzo().multiply(BigDecimal.valueOf(cartItems.get(p))));
    }
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Completamento Ordine</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/navbar.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #16a085;
            --primary-dark: #138d75;
            --success-color: #27ae60;
            --success-dark: #229954;
            --text-primary: #1f2937;
            --text-secondary: #6b7280;
            --bg-primary: #f9fafb;
            --bg-card: #ffffff;
            --border-color: #e5e7eb;
            --shadow-light: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
            --shadow-medium: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-large: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --gradient-primary: linear-gradient(135deg, #16a085 0%, #138d75 100%);
            --gradient-success: linear-gradient(135deg, #27ae60 0%, #229954 100%);
        }

        * {
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: var(--bg-primary);
            margin: 0;
            padding: 0;
            color: var(--text-primary);
            line-height: 1.6;
        }

        .checkout-header {
            background: var(--gradient-primary);
            color: white;
            padding: 3rem 0;
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .checkout-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1000 100" fill="rgba(255,255,255,0.1)"><polygon points="0,0 1000,0 1000,100"/></svg>');
            background-size: 100% 100%;
        }

        .checkout-header h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin: 0;
            text-shadow: 0 2px 4px rgba(0,0,0,0.1);
            position: relative;
            z-index: 1;
        }

        .checkout-header p {
            font-size: 1.1rem;
            margin: 0.5rem 0 0 0;
            opacity: 0.9;
            position: relative;
            z-index: 1;
        }

        .progress-bar {
            background: white;
            padding: 1rem 0;
            box-shadow: var(--shadow-light);
        }

        .progress-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 0 2rem;
        }

        .progress-steps {
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: relative;
        }

        .progress-steps::before {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            right: 0;
            height: 2px;
            background: var(--border-color);
            z-index: 1;
        }

        .progress-steps::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 0;
            width: 100%;
            height: 2px;
            background: var(--primary-color);
            z-index: 2;
            transform: translateY(-50%);
        }

        .progress-step {
            background: var(--primary-color);
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 0.9rem;
            position: relative;
            z-index: 3;
            box-shadow: var(--shadow-medium);
        }

        .container {
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: 2rem;
            max-width: 1200px;
            margin: 2rem auto;
            padding: 0 2rem;
        }

        .col-left, .col-right {
            background: var(--bg-card);
            border-radius: 16px;
            box-shadow: var(--shadow-light);
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .col-left:hover, .col-right:hover {
            box-shadow: var(--shadow-large);
            transform: translateY(-2px);
        }

        .section {
            padding: 2rem;
            border-bottom: 1px solid var(--border-color);
        }

        .section:last-child {
            border-bottom: none;
        }

        .section-header {
            display: flex;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .section-icon {
            width: 24px;
            height: 24px;
            margin-right: 0.75rem;
            color: var(--primary-color);
        }

        .section h3 {
            margin: 0;
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
        }

        .info-grid {
            display: grid;
            gap: 0.75rem;
        }

        .info-item {
            display: flex;
            align-items: center;
            padding: 0.75rem;
            background: #f8fafc;
            border-radius: 8px;
            border-left: 4px solid var(--primary-color);
        }

        .info-item .label {
            font-weight: 500;
            color: var(--text-secondary);
            min-width: 80px;
        }

        .info-item .value {
            color: var(--text-primary);
            font-weight: 500;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            background: var(--gradient-primary);
            color: white;
            padding: 0.75rem 1.5rem;
            font-size: 0.9rem;
            font-weight: 500;
            border: none;
            border-radius: 8px;
            text-decoration: none;
            cursor: pointer;
            box-shadow: var(--shadow-medium);
            transition: all 0.3s ease;
            margin-top: 1rem;
        }

        .btn:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-large);
        }

        .btn svg {
            width: 16px;
            height: 16px;
            margin-left: 0.5rem;
        }

        .product-row {
            display: flex;
            align-items: center;
            padding: 1.5rem;
            border-bottom: 1px solid var(--border-color);
            transition: background-color 0.3s ease;
        }

        .product-row:hover {
            background: #f8fafc;
        }

        .product-row:last-child {
            border-bottom: none;
        }

        .product-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 12px;
            margin-right: 1rem;
            box-shadow: var(--shadow-medium);
        }

        .product-info {
            flex: 1;
        }

        .product-name {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--text-primary);
            margin: 0 0 0.5rem 0;
        }

        .product-details {
            color: var(--text-secondary);
            font-size: 0.9rem;
            margin: 0.25rem 0;
        }

        .product-price {
            font-size: 1.1rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-top: 0.5rem;
        }

        .order-summary {
            background: #f8fafc;
            padding: 1.5rem;
            border-radius: 12px;
            margin-top: 1rem;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.75rem;
            font-size: 0.9rem;
        }

        .summary-row.total {
            font-size: 1.2rem;
            font-weight: 700;
            color: var(--success-color);
            border-top: 2px solid var(--border-color);
            padding-top: 0.75rem;
            margin-top: 1rem;
        }

        .checkout-button {
            background: var(--gradient-success);
            color: white;
            padding: 1rem 2rem;
            font-size: 1.1rem;
            font-weight: 600;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            width: 100%;
            box-shadow: var(--shadow-medium);
            transition: all 0.3s ease;
            margin-top: 1.5rem;
            position: relative;
            overflow: hidden;
        }

        .checkout-button:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-large);
        }

        .checkout-button::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.2), transparent);
            transition: left 0.5s;
        }

        .checkout-button:hover::before {
            left: 100%;
        }

        .secure-badge {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-top: 1rem;
            font-size: 0.85rem;
            color: var(--text-secondary);
        }

        .secure-badge svg {
            width: 16px;
            height: 16px;
            margin-right: 0.5rem;
            color: var(--success-color);
        }

        @media (max-width: 1024px) {
            .container {
                grid-template-columns: 1fr;
                gap: 1.5rem;
            }

            .col-right {
                order: -1;
            }
        }

        @media (max-width: 768px) {
            .checkout-header h1 {
                font-size: 2rem;
            }

            .container {
                margin: 1rem auto;
                padding: 0 1rem;
            }

            .section {
                padding: 1.5rem;
            }

            .product-row {
                flex-direction: column;
                align-items: flex-start;
                text-align: left;
            }

            .product-image {
                margin-bottom: 1rem;
                margin-right: 0;
            }

            .progress-steps {
                flex-wrap: wrap;
                gap: 1rem;
            }
        }

        /* Animazioni */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .col-left, .col-right {
            animation: fadeInUp 0.6s ease-out;
        }

        .col-right {
            animation-delay: 0.1s;
        }
    </style>
</head>
<body>

<%@ include file="navbar.jsp" %>

<div class="checkout-header">
    <h1>Completamento Ordine</h1>
    <p>Controlla i tuoi dati e conferma l'acquisto</p>
</div>

<div class="progress-bar">
    <div class="progress-container">
        <div class="progress-steps">
            <div class="progress-step">1</div>
            <div class="progress-step">2</div>
            <div class="progress-step">3</div>
        </div>
    </div>
</div>

<div class="container">
    <!-- Colonna Sinistra -->
    <div class="col-left">
        <div class="section">
            <div class="section-header">
                <svg class="section-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path>
                </svg>
                <h3>Dati dell'utente</h3>
            </div>
            <div class="info-grid">
                <div class="info-item">
                    <span class="label">Nome:</span>
                    <span class="value"><%= nomeUtente %></span>
                </div>
                <div class="info-item">
                    <span class="label">Email:</span>
                    <span class="value"><%= email %></span>
                </div>
                <div class="info-item">
                    <span class="label">Telefono:</span>
                    <span class="value"><%= telefono %></span>
                </div>
            </div>
        </div>

        <div class="section">
            <div class="section-header">
                <svg class="section-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path>
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path>
                </svg>
                <h3>Indirizzo di Consegna</h3>
            </div>
            <div class="info-item">
                <span class="value"><%= indirizzo %></span>
            </div>
            <a href="modificaIndirizzo.jsp" class="btn">
                Modifica indirizzo
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                </svg>
            </a>
        </div>

        <div class="section">
            <div class="section-header">
                <svg class="section-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"></path>
                </svg>
                <h3>Metodo di Pagamento</h3>
            </div>
            <div class="info-item">
                <span class="value"><%= metodoPagamento %></span>
            </div>
            <a href="modificaPagamento.jsp" class="btn">
                Modifica pagamento
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"></path>
                </svg>
            </a>
        </div>
    </div>

    <!-- Colonna Destra -->
    <div class="col-right">
        <div class="section">
            <div class="section-header">
                <svg class="section-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path>
                </svg>
                <h3>Riepilogo Ordine</h3>
            </div>

            <% for (ProductBean p : cartItems.keySet()) { %>
            <div class="product-row">
                <img src="${pageContext.request.contextPath}/<%= imgPath %>" alt="<%= p.getNome() %>" class="product-image">
                <div class="product-info">
                    <h4 class="product-name"><%= p.getNome() %></h4>
                    <p class="product-details">Quantità: <%= cartItems.get(p) %></p>
                    <p class="product-details">Codice: #<%= p.getCodiceProdotto() %></p>
                    <p class="product-price">€ <%= String.format("%.2f", p.getPrezzo().multiply(BigDecimal.valueOf(cartItems.get(p)))) %></p>
                </div>
            </div>
            <% } %>

            <div class="order-summary">
                <div class="summary-row">
                    <span>Subtotale</span>
                    <span>€ <%= String.format("%.2f", totalPrice) %></span>
                </div>
                <div class="summary-row">
                    <span>Spedizione</span>
                    <span>Gratuita</span>
                </div>
                <div class="summary-row">
                    <span>IVA (22%)</span>
                    <span>€ <%= String.format("%.2f", totalPrice.multiply(new BigDecimal("0.22"))) %></span>
                </div>
                <div class="summary-row total">
                    <span>Totale</span>
                    <span>€ <%= String.format("%.2f", totalPrice.multiply(new BigDecimal("1.22"))) %></span>
                </div>
            </div>

            <form action="checkout_success.jsp" method="post">
                <button type="submit" class="checkout-button">
                    Conferma Ordine
                </button>
            </form>

            <div class="secure-badge">
                <svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path>
                </svg>
                Pagamento sicuro e protetto
            </div>
        </div>
    </div>
</div>

<%@ include file="footer.jsp" %>

<script src="https://unpkg.com/lucide@latest"></script>
<script>lucide.createIcons();</script>

</body>
</html>