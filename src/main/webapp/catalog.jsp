<%@ page import="java.util.Collection" %>
<%@ page import="com.r1.ecommerceproject.model.ProductBean" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="com.r1.ecommerceproject.utils.Utils" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="static com.r1.ecommerceproject.utils.Utils.isChecked" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%
    // filtri
    String[] types = request.getParameterValues("tipo");
    String[] brands = request.getParameterValues("brand");
    String[] materials  = request.getParameterValues("materiale");
    String priceParam = request.getParameter("prezzo");

    // Produtti della pagina corrente
    Collection<ProductBean> products = (Collection<ProductBean>) request.getAttribute("products");

    if (products == null) {
        products = new ArrayList<>();
    }

    // numero di pagina corrente, se non è definita viene impostata di default a 1
    int currentPage = 1;
    String pageStr = request.getParameter("page");
    if (pageStr != null) {
        try {
            currentPage = Integer.parseInt(pageStr);
        } catch (NumberFormatException ignored) {
        }
    }

    Integer totalPagesObj = (Integer) request.getAttribute("totalPages");
    int totalPages = totalPagesObj != null ? totalPagesObj : 1;
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catalogo Prodotti</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/catalog.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
</head>
<body>
<%@ include file="navbar.jsp" %>
<button id="filter-toggle" class="filter-toggle" aria-label="Mostra filtri">
    <i data-lucide="filter"></i>
</button>
<div class="container">
    <!-- Sidebar filtri -->
    <aside class="sidebar">
        <h2>Filtra</h2>
        <form id="filter-form" action="${pageContext.request.contextPath}/catalog" method="get">
            <div class="filter-group">
                <div class="price-slider-header">
                    <div class="price-slider-title">Budget</div>
                    <div class="price-value">€<span
                            id="price-display"><%= priceParam == null ? "0" : priceParam %></span></div>
                </div>

                <div class="price-slider">
                    <label for="price-range"></label>
                    <input type="range" id="price-range" name="prezzo" min="0" max="1000"
                                                            value="<%= priceParam == null ? "0" : priceParam %>" step="1">
                </div>

                <div class="price-range-labels">
                    <span>€0</span>
                    <span>€1000</span>
                </div>
            </div>

            <div class="filter-group">
                <h3>Tipo</h3>
                <label>
                    <input type="checkbox" name="tipo"
                           value="Orologi D'Oro" <%= isChecked(types, "Orologi D'Oro") ? "checked" : "" %>>
                    <span class="checkmark"></span>
                    Orologi D'Oro
                </label>
                <label>
                    <input type="checkbox" name="tipo"
                           value="Automatici" <%= isChecked(types, "Automatici") ? "checked" : "" %>>
                    <span class="checkmark"></span>
                    Automatici
                </label>
                <label>
                    <input type="checkbox" name="tipo"
                           value="Da Tasca" <%= isChecked(types, "Da Tasca") ? "checked" : "" %>>
                    <span class="checkmark"></span>
                    Da Tasca
                </label>
                <label>
                    <input type="checkbox" name="tipo"
                           value="Con Fasi Lunari" <%= isChecked(types, "Con Fasi Lunari") ? "checked" : "" %>>
                    <span class="checkmark"></span>
                    Con Fasi Lunari
                </label>
                <label>
                    <input type="checkbox" name="tipo"
                           value="Usati" <%= isChecked(types, "Usati") ? "checked" : "" %>>
                    <span class="checkmark"></span>
                    Usati
                </label>
                <label>
                    <input type="checkbox" name="tipo"
                           value="Scheletrati" <%= isChecked(types, "Scheletrati") ? "checked" : "" %>>
                    <span class="checkmark"></span>
                    Scheletrati
                </label>
            </div>
            <div class="filter-group">
                <h3>Materiale</h3>
                <label>
                    <input type="checkbox" name="materiale"
                           value="Acciaio" <%= isChecked(materials, "Acciaio") ? "checked" : "" %>>
                    <span class="checkmark"></span>
                    Acciaio
                </label>
                <label>
                    <input type="checkbox" name="materiale"
                           value="Pelle Italiana" <%= isChecked(materials, "Pelle Italiana") ? "checked" : "" %>>
                    <span class="checkmark"></span>
                    Pelle Italiana
                </label>
                <label>
                    <input type="checkbox" name="materiale"
                           value="Pelle Sintetica" <%= isChecked(materials, "Pelle Sintetica") ? "checked" : "" %>>
                    <span class="checkmark"></span>
                    Pelle Sintetica
                </label>
                <label>
                    <input type="checkbox" name="materiale"
                           value="Resina e Carbonio" <%= isChecked(materials, "Resina e Carbonio") ? "checked" : "" %>>
                    <span class="checkmark"></span>
                    Resina e Carbonio
                </label>
                <label>
                <input type="checkbox" name="materiale"
                       value="Silicone Nero" <%= isChecked(materials, "Silicone Nero") ? "checked" : "" %>>
                <span class="checkmark"></span>
                Silicone Nero
                </label>
            </div>
            <div class="filter-group">
                <h3>Brand</h3>
                <label>
                    <input type="checkbox" name="brand"
                           value="Tommy Hilfiger" <%= isChecked(brands, "Tommy Hilfiger") ? "checked" : "" %>>
                    <span class="checkmark"></span>
                    Tommy Hilfiger
                </label>
                <label>
                    <input type="checkbox" name="brand"
                           value="Casio" <%= isChecked(brands, "Casio") ? "checked" : "" %>>
                    <span class="checkmark"></span>
                    Casio
                </label>
                <label>
                    <input type="checkbox" name="brand"
                           value="Versace" <%= isChecked(brands, "Versace") ? "checked" : "" %>>
                    <span class="checkmark"></span>
                    Versace
                </label>
                <label>
                    <input type="checkbox" name="brand"
                           value="Tissot" <%= isChecked(brands, "Tissot") ? "checked" : "" %>>
                    <span class="checkmark"></span>
                    Tissot
                </label>
            </div>
            <% if(request.getParameter("sort") != null) { %>
            <input type="hidden" name="sort" id="sort-input" value="${param.sort}">
            <% } %>
            <% if(request.getParameter("gender") != null) { %>
            <input type="hidden" name="gender" value="${param.gender}">
            <% } %>
        </form>
    </aside>

    <!-- Contenuto principale -->
    <main class="main-content">
        <!-- Tab ordinamento -->
        <div class="sorting-tabs">
            <button class="${param.sort == 'nome_asc' ? 'active' : ''}" type="button" data-sort="nome_asc">A-Z</button>
            <button class="${param.sort == 'prezzo_asc' ? 'active' : ''}" type="button" data-sort="prezzo_asc">Prezzo
                crescente
            </button>
            <button class="${param.sort == 'prezzo_desc' ? 'active' : ''}" type="button" data-sort="prezzo_desc">Prezzo
                decrescente
            </button>
        </div>

        <!-- Griglia prodotti -->
        <div class="product-grid">
            <% for (Iterator<ProductBean> i = products.iterator(); i.hasNext(); ) { %>
            <% ProductBean p = i.next(); %>
            <div class="product-card">
                <a href="product?id=<%= p.getCodiceProdotto() %>">
                    <div class="thumb"><img
                            src="<%= p.getImmagine()%>"
                            alt="Prodotto"></div>
                    <h4><%= p.getNome() %>
                    </h4>
                    <p class="price">$<%= String.format("%.2f", p.getPrezzo()) %>
                    </p>
                    <p class="desc"><%= p.getDescrizione()%>
                    </p>
                </a>
                <button class="wishlist" aria-label="Aggiungi ai preferiti" data-codice="<%= p.getCodiceProdotto() %>">
                    <svg viewBox="0 0 24 24" class="heart-icon">
                        <path class="<%= userSession.isFavorite(p.getCodiceProdotto()) ? "heart-full" : "heart-shape" %>"
                              d="M12 21.35l-1.45-1.32
                                 C5.4 15.36 2 12.28 2 8.5
                                 2 5.42 4.42 3 7.5 3
                                 c1.74 0 3.41.81 4.5 2.09
                                 C13.09 3.81 14.76 3 16.5 3
                                 19.58 3 22 5.42 22 8.5
                                 c0 3.78-3.4 6.86-8.55 11.54
                                 L12 21.35z">
                        </path>
                    </svg>
                </button>
            </div>
            <% } %>
            <!-- ... altre card ... -->
        </div>

        <!-- Paginazione -->
        <!-- Paginazione dinamica -->
        <nav class="pagination">
            <a class="prev <%= currentPage == 1 ? "disabled" : "" %>"
               href="<%= currentPage > 1 ? Utils.addRequestParameter(request, "page", String.valueOf(currentPage - 1)) : "#" %>">&laquo;
                Precedente</a>
            <ul>
                <%
                    boolean ellipsisPrinted = false;
                    for (int i = 1; i <= totalPages; i++) {
                        if (i <= 3 || i > totalPages - 2) {
                %>
                <li>
                    <a class="<%= i == currentPage ? "active" : "" %>"
                       href="<%= Utils.addRequestParameter(request, "page", String.valueOf(i)) %>"><%= i %>
                    </a>
                </li>
                <%
                    ellipsisPrinted = false; // reset each time we print a page number
                } else {
                    if (!ellipsisPrinted) {
                %>
                <li class="dots">...</li>
                <%
                                ellipsisPrinted = true;
                            }
                        }
                    }
                %>
            </ul>
            <a class="next <%= currentPage == totalPages ? "disabled" : "" %>"
               href="<%= currentPage < totalPages ? Utils.addRequestParameter(request, "page", String.valueOf(currentPage + 1)) : "#" %>">Successivo
                &raquo;</a>
        </nav>
    </main>
</div>
<%@include file="footer.jsp"%>
<script src="https://unpkg.com/lucide@latest"></script>
<script src="assets/js/navbar.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/catalog-scripts.js"></script>
<script>
    lucide.createIcons();
</script>
</body>
</html>