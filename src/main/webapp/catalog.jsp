<%@ page import="java.util.Collection" %>
<%@ page import="com.r1.ecommerceproject.model.ProductBean" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="com.r1.ecommerceproject.utils.Utils" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%!
    public boolean isChecked(String[] selected, String value) {
        if (selected == null) return false;
        for (String s : selected) {
            if (value.equals(s)) return true;
        }
        return false;
    }
%>
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
                <h3>Tipo</h3>
                <label><input type="checkbox" name="tipo"
                              value="Classico" <%= isChecked(types, "Classico") ? "checked" : "" %>> Classico</label>
                <label><input type="checkbox" name="tipo"
                              value="Estivo" <%= isChecked(types, "Estivo") ? "checked" : "" %>> Estivo</label>
                <label><input type="checkbox" name="tipo"
                              value="Digitale" <%= isChecked(types, "Digitale") ? "checked" : "" %>>Digitale</label>
            </div>

            <div class="filter-group">
                <div class="price-slider-header">
                    <div class="price-slider-title">Prezzo</div>
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
                <input type="hidden" name="sort" id="sort-input" value="${param.sort}">
            </div>

            <div class="filter-group">
                <h3>Colore</h3>
                <label><input type="checkbox" name="colore"
                              value="Nero" <%= isChecked(colors, "Nero") ? "checked" : "" %>>Nero</label>
                <label><input type="checkbox" name="colore"
                              value="Blu" <%= isChecked(colors, "Blu") ? "checked" : "" %>>Blu</label>
                <label><input type="checkbox" name="colore"
                              value="Bianco" <%= isChecked(colors, "Bianco") ? "checked" : "" %>> Bianco</label>
            </div>

            <div class="filter-group">
                <h3>Taglia</h3>
                <label><input type="checkbox" name="taglia"
                              value="One Size" <%= isChecked(sizes, "One Size") ? "checked" : "" %>> One Size</label>
                <label><input type="checkbox" name="taglia"
                              value="31 mm" <%= isChecked(sizes, "31 mm") ? "checked" : "" %>> 31 mm</label>
                <label><input type="checkbox" name="taglia"
                              value="41 mm" <%= isChecked(sizes, "41 mm") ? "checked" : "" %>> 41 mm</label>
            </div>
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
                    <button class="wishlist" aria-label="Aggiungi ai preferiti">
                        <svg viewBox="0 0 24 24" class="heart-icon">
                            <path class="heart-shape"
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
                </a>
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
<script>
    lucide.createIcons();
    const r = document.getElementById('price-range');
    const v = document.getElementById('price-display');
    const filterForm = document.getElementById('filter-form');

    function aggiorna() {
        v.textContent = r.value;
    }

    r.addEventListener('input', aggiorna);
    window.addEventListener('load', aggiorna);

    r.addEventListener('change', function () {
        if (r.value === '0') {
            // Disabilita l'input così non viene inviato nel form
            r.disabled = true;
        }
        filterForm.submit();
    })

    // Aggiungi event listener a tutti i checkbox per invio automatico
    document.querySelectorAll('input[type="checkbox"]').forEach(checkbox => {
        checkbox.addEventListener('change', function () {
            if (r.value === '0') {
                r.disabled = true;
            }
            filterForm.submit();
        });
    });

    document.querySelectorAll('.sorting-tabs button').forEach(button => {
        button.addEventListener('click', function () {
            // Ottieni il valore di ordinamento dal data-attribute
            const sortValue = this.getAttribute('data-sort');
            const priceRange = document.getElementById('price-range');

            // Se il prezzo è zero, disabilita l'input così non verrà inviato
            if (priceRange && priceRange.value === "0") {
                priceRange.disabled = true;
            }

            // Imposta il valore nell'input nascosto
            document.getElementById('sort-input').value = sortValue;

            // Rimuovi la classe active da tutti i pulsanti
            document.querySelectorAll('.sorting-tabs button').forEach(btn => {
                btn.classList.remove('active');
            });

            // Aggiungi la classe active a questo pulsante
            this.classList.add('active');

            // Invia il form
            filterForm.submit();
        });
    });

</script>
</body>
</html>