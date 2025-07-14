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
    String[] colors = request.getParameterValues("colore");
    String[] sizes = request.getParameterValues("taglia");
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
    <title>Catalogo Prodotti</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/catalog.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/navbar.css">
</head>
<body>
<%@ include file="navbar.jsp" %>
<div class="container">
    <!-- Sidebar filtri -->
    <aside class="sidebar">
        <h2>Filtro</h2>
        <form id="filter-form" action="${pageContext.request.contextPath}/catalog" method="get">
            <div class="filter-group">
                <div class="price-slider-header">
                    <div class="price-slider-title">Budget</div>
                    <div class="price-value">€<span
                            id="price-display"><%= priceParam == null ? "0" : priceParam %></span></div>
                </div>

                <div class="price-slider">
                    <input type="range" id="price-range" name="prezzo" min="0" max="1000"
                           value="<%= priceParam == null ? "0" : priceParam %>" step="1">
                </div>

                <div class="price-range-labels">
                    <span>€0</span>
                    <span>€1000</span>
                </div>
            </div>

            <div class="filter-group">
                <h3>Colore</h3>
                <label>
                    <input type="checkbox" name="colore"
                              value="Nero" <%= isChecked(colors, "Nero") ? "checked" : "" %>>
                    <span class="checkmark"></span>
                    Nero
                </label>
                <label>
                    <input type="checkbox" name="colore"
                              value="Blu" <%= isChecked(colors, "Blu") ? "checked" : "" %>>
                    <span class="checkmark"></span>
                    Blu
                </label>
                <label>
                    <input type="checkbox" name="colore"
                              value="Bianco" <%= isChecked(colors, "Bianco") ? "checked" : "" %>>
                    <span class="checkmark"></span>
                    Bianco
                </label>
            </div>
            <div class="filter-group">
                <h3>Materiale</h3>
                <label>
                    <input type="checkbox" name="materiale"
                           value="Accaio" <%= isChecked(colors, "Acciaio") ? "checked" : "" %>>
                    <span class="checkmark"></span>
                    Acciaio
                </label>
                <label>
                    <input type="checkbox" name="materiale"
                           value="Pelle Italiana" <%= isChecked(colors, "Pelle Italiana") ? "checked" : "" %>>
                    <span class="checkmark"></span>
                    Pelle Italiana
                </label>
                <label>
                    <input type="checkbox" name="materiale"
                           value="Resina e Carbonio" <%= isChecked(colors, "Resina e Carbonio") ? "checked" : "" %>>
                    <span class="checkmark"></span>
                    Resina e Carbonio
                </label>
            </div>
            <div class="filter-group">
                <h3>Brands</h3>
                <label>
                    <input type="checkbox" name="taglia"
                           value="Tommy Hilfiger" <%= isChecked(sizes, "Tommy Hilfiger") ? "checked" : "" %>>
                    <span class="checkmark"></span>
                    Tommy Hilfiger
                </label>
                <label>
                    <input type="checkbox" name="brand"
                           value="Casio" <%= isChecked(sizes, "Casio") ? "checked" : "" %>>
                    <span class="checkmark"></span>
                    Casio
                </label>
                <label>
                    <input type="checkbox" name="brand"
                           value="Versace" <%= isChecked(sizes, "Versace") ? "checked" : "" %>>
                    <span class="checkmark"></span>
                    Versace
                </label>
                <label>
                    <input type="checkbox" name="brand"
                           value="Tissot" <%= isChecked(sizes, "Tissot") ? "checked" : "" %>>
                    <span class="checkmark"></span>
                    Tissot
                </label>
            </div>
            <% if(request.getParameter("sort") != null) { %>
            <input type="hidden" name="sort" id="sort-input" value="${param.sort}">
            <% } %>
            <% if(request.getParameter("category") != null) { %>
            <input type="hidden" name="category" value="${param.category}">
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
<script src="https://unpkg.com/lucide@latest"></script>
<script src="${pageContext.request.contextPath}/assets/js/catalog-scripts.js"></script>
<script>
    lucide.createIcons();
</script>
</body>
</html>