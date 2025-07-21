<%@ page contentType="text/html; charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="it">
<head>
  <meta charset="UTF-8">
  <title>Ordine non completato</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/fonts.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/navbar.css">
  <style>
    html, body {
      margin: 0;
      padding: 0;
      min-height: 100vh;
      background-color: #fef2f2;
      font-family: 'Lato', Arial, sans-serif;
      color: #b91c1c;
      display: flex;
      flex-direction: column;
    }

    main {
      flex: 1;
    }

    .container {
      width: 85%;
      margin: 0 auto;
      padding: 60px 0;
      text-align: center;
    }

    .error-circle {
      display: flex;
      justify-content: center;
      align-items: center;
      background-color: #fdecea;
      border: 4px solid #dc2626;
      border-radius: 50%;
      width: 130px;
      height: 130px;
      margin: 0 auto 20px auto;
      box-shadow: 0 6px 16px rgba(0, 0, 0, 0.1);
      animation: shake 0.4s ease-in-out;
    }

    @keyframes shake {
      0% { transform: translateX(0); }
      25% { transform: translateX(-5px); }
      50% { transform: translateX(5px); }
      75% { transform: translateX(-3px); }
      100% { transform: translateX(0); }
    }

    .title {
      font-size: 32px;
      font-weight: bold;
      color: #dc2626;
      margin-bottom: 15px;
    }

    .error-desc {
      font-size: 17px;
      color: #7f1d1d;
      max-width: 600px;
      margin: 0 auto 40px auto;
    }

    .btn-home {
      display: inline-block;
      margin-top: 10px;
      background-color: #dc2626;
      color: white;
      padding: 14px 30px;
      font-size: 16px;
      border: none;
      border-radius: 8px;
      text-decoration: none;
      box-shadow: 0 4px 12px rgba(0,0,0,0.1);
      transition: background 0.3s, transform 0.2s;
    }

    .btn-home:hover {
      background-color: #b91c1c;
      transform: translateY(-2px);
    }

    @media (max-width: 768px) {
      .container {
        width: 92%;
      }

      .title {
        font-size: 26px;
      }

      .error-desc {
        font-size: 15px;
      }
    }
  </style>
</head>
<body>
<%@ include file="navbar.jsp" %>
<!-- CONTENUTO PRINCIPALE -->
<main>
  <div class="container">
    <div class="error-circle">
      <svg width="65" height="65" viewBox="0 0 24 24" fill="none" stroke="#dc2626" stroke-width="3.5" stroke-linecap="round" stroke-linejoin="round">
        <line x1="18" y1="6" x2="6" y2="18"></line>
        <line x1="6" y1="6" x2="18" y2="18"></line>
      </svg>
    </div>

    <div class="title">Ordine non completato</div>
    <p class="error-desc">
      Purtroppo si è verificato un errore durante il processo di pagamento.
      Ti invitiamo a riprovare o a contattare il nostro servizio clienti se il problema persiste.
    </p>

    <a class="btn-home" href="<%= request.getContextPath() %>/">Torna alla Home</a>
  </div>
</main>

<!-- FOOTER INCLUSO -->
<%@ include file="footer.jsp" %>

<!-- Script per icone (lucide.js) -->
<script src="https://unpkg.com/lucide@latest"></script>
<script>lucide.createIcons();</script>

</body>
</html>
