<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.r1.ecommerceproject.model.ProductBean" %>
<%@ page import="com.r1.ecommerceproject.model.AddressBean" %>
<%@ page import="com.r1.ecommerceproject.model.UserBean" %>
<%@ page import="com.r1.ecommerceproject.utils.UserSession" %>
<%@ page import="java.util.HashMap, java.util.Map, java.util.List" %>


<%
    // Assicurati che l'utente sia loggato
    UserSession sessioneUtente = new UserSession(request.getSession());
    if (!sessioneUtente.isLoggedIn()) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Recupera la HashMap con ProductBean come chiavi dalla request scope
    HashMap<ProductBean, Integer> cartItems =
            (HashMap<ProductBean, Integer>) request.getAttribute("cartItems");

    // Recupera il totale calcolato dalla servlet
    Double totalPriceObject = (Double) request.getAttribute("totalPrice");
    double total = (totalPriceObject != null) ? totalPriceObject : 0.0;

    // Recupera l'indirizzo predefinito e la lista di indirizzi dalla request
    AddressBean defaultShippingAddress = (AddressBean) request.getAttribute("defaultShippingAddress");
    List<AddressBean> userAddresses = (List<AddressBean>) request.getAttribute("userAddresses");

    // Recupera l'utente corrente per nome/email
    UserBean currentUser = (UserBean) request.getSession().getAttribute("currentUser");
    String userName = (currentUser != null) ? currentUser.getNome() + " " + currentUser.getCognome() : "N/D";
    String userEmail = (currentUser != null) ? currentUser.getEmail() : "N/D";

    // Assicurati che il numero di telefono sia recuperato correttamente dall'UserBean
    // Questo è un placeholder, dovrai assicurarti che UserBean abbia un metodo getTelefono()
    //String userPhone = (currentUser != null && currentUser.getTelefono() != null && !currentUser.getTelefono().isEmpty()) ? currentUser.getTelefono() : "N/D";

    // Verifica se il carrello è null o vuoto.
    if (cartItems == null || cartItems.isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/cart");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Riepilogo Ordine e Pagamento</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/checkout.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/navbar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/footer.css">
    <script src="https://unpkg.com/lucide@latest"></script>
    <style>
        /* Stili per il modal/form di modifica indirizzo (rimangono uguali) */
        .address-modal-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.6);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 1000;
            visibility: hidden;
            opacity: 0;
            transition: visibility 0s, opacity 0.3s ease;
        }

        .address-modal-overlay.active {
            visibility: visible;
            opacity: 1;
        }

        .address-modal-content {
            background-color: var(--white);
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
            width: 90%;
            max-width: 600px;
            position: relative;
            transform: translateY(-20px);
            transition: transform 0.3s ease;
        }

        .address-modal-overlay.active .address-modal-content {
            transform: translateY(0);
        }

        .address-modal-content h2 {
            margin-top: 0;
            color: var(--black);
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 15px;
            margin-bottom: 20px;
        }

        .address-modal-content .form-group {
            margin-bottom: 15px;
        }

        .address-modal-content .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: var(--text-color);
            font-size: 15px;
        }

        .address-modal-content .form-group input[type="text"],
        .address-modal-content .form-group select {
            width: calc(100% - 22px);
            padding: 10px;
            border: 1px solid var(--border-color);
            border-radius: 5px;
            font-size: 16px;
            box-sizing: border-box;
        }

        .address-modal-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 25px;
        }

        .address-modal-actions button {
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }

        .address-modal-actions .btn-cancel {
            background-color: #ccc;
            color: var(--black);
            border: none;
        }

        .address-modal-actions .btn-save {
            background-color: var(--primary-green);
            color: var(--white);
            border: none;
        }

        .address-modal-actions .btn-cancel:hover {
            background-color: #bbb;
        }

        .address-modal-actions .btn-save:hover {
            background-color: #2a6f47;
        }

        .close-button {
            position: absolute;
            top: 15px;
            right: 15px;
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: var(--black);
        }
    </style>
</head>
<body>
<%@ include file="navbar.jsp" %>

<div class="checkout-container">
    <%-- COLONNA SINISTRA: Indirizzo di Spedizione e Metodo di Pagamento --%>
    <div class="shipping-payment-section">
        <h2>Indirizzo di Spedizione</h2>
        <div class="info-box">
            <h3>Indirizzo Postale <button class="button-modify" id="modifyAddressBtn">MODIFICA</button></h3>
            <div id="currentAddressDisplay">
                <% if (defaultShippingAddress != null) { %>
                <p class="address-detail"><strong id="displayUserName"><%= userName %></strong></p>
                <p class="address-detail" id="displayVia"><%= defaultShippingAddress.getVia() %></p>
                <p class="address-detail" id="displayCittaCap"><%= defaultShippingAddress.getCitta() %>, <%= defaultShippingAddress.getCap() %></p>
                <p class="address-detail">Italia</p>
                <p class="contact-detail" id="displayUserPhone">Telefono: </p>
                <p class="contact-detail" id="displayUserEmail">Email: <%= userEmail %></p>
                <% } else { %>
                <p id="noAddressMessage">Nessun indirizzo di spedizione predefinito trovato.</p>
                <button class="button-modify" id="addAddressBtn">AGGIUNGI INDIRIZZO</button>
                <% } %>
            </div>
        </div>

        <%-- Sezione per selezionare un altro indirizzo (se ce ne sono più di uno) --%>
        <%-- La logica per aggiornare questa select dinamicamente sarà più complessa via AJAX,
             quindi per ora la lasciamo come era, e un ricaricamento pagina la aggiornerà. --%>
        <% if (userAddresses != null && userAddresses.size() > 1) { %>
        <div class="info-box">
            <h3>Seleziona un altro indirizzo</h3>
            <select name="selectedAddress" id="selectedAddress" class="form-control">
                <% for (AddressBean addr : userAddresses) { %>
                <option value="<%= addr.getId() %>"
                        <%= (defaultShippingAddress != null && addr.getId() == defaultShippingAddress.getId()) ? "selected" : "" %>>
                    <%= addr.getVia() %>, <%= addr.getCitta() %>, <%= addr.getCap() %> (<%= addr.getTipologia().name().toLowerCase() %>)
                </option>
                <% } %>
            </select>
            <button class="button-modify" id="changeSelectedAddressBtn">CAMBIA</button>
        </div>
        <% } %>


        <h2>Opzioni di Spedizione</h2>
        <div class="info-box">
            <h3>Spedizione Standard Gratuita</h3>
            <p>Consegna entro 3-5 giorni lavorativi.</p>
        </div>

        <h2>Metodo di Pagamento</h2>
        <div class="info-box">
            <h3>Metodo di Pagamento Predefinito <button class="button-modify">MODIFICA</button></h3>
            <p>Pagamento sicuro con Carta di Credito (o il metodo che hai).</p>
        </div>

        <form action="${pageContext.request.contextPath}/processOrder" method="post">
            <input type="hidden" name="shippingAddressId" value="<%= (defaultShippingAddress != null) ? defaultShippingAddress.getId() : "" %>" id="finalShippingAddressId">
            <button type="submit" class="confirm-button">Conferma e Paga</button>
        </form>
    </div>

    <%-- COLONNA DESTRA: Riepilogo Ordine (Prodotti e Totale) --%>
    <div class="order-summary-section">
        <h2><%= cartItems.size() %> Prodott<%= cartItems.size() == 1 ? "o" : "i" %></h2>
        <div class="order-items">
            <% for (ProductBean p : cartItems.keySet()) { %>
            <% int qty = cartItems.get(p); %>
            <div class="order-item">
                <img src="<%= p.getImmagine() %>" alt="Immagine di <%= p.getNome() %>">
                <div class="item-details">
                    <h3><%= p.getNome() %></h3>
                    <p><%= p.getDescrizione() %></p>
                    <p class="price">€ <%= String.format("%.2f", p.getPrezzo()) %></p>
                    <p>Qtà: <%= qty %></p>
                    <p class="subtotal">Subtotale: € <%= String.format("%.2f", p.getPrezzo() * qty) %></p>
                </div>
            </div>
            <% } %>
        </div>

        <div class="order-total">
            <p>Subtotale: € <%= String.format("%.2f", total) %></p>
            <p>Spedizione: € 6.50</p>
            <h3>TOTALE: <strong>€ <%= String.format("%.2f", total + 6.50) %></strong></h3>
        </div>
    </div>
</div>

<%-- MODAL/FORM PER L'AGGIUNTA/MODIFICA INDIRIZZO --%>
<div class="address-modal-overlay" id="addressModal">
    <div class="address-modal-content">
        <button class="close-button" id="closeModalBtn">&times;</button>
        <h2 id="modalTitle">Modifica Indirizzo</h2>
        <%-- L'ACTION del form punta alla servlet /address --%>
        <form id="addressForm" action="${pageContext.request.contextPath}/address" method="post">
            <input type="hidden" name="action" id="addressFormAction" value="update">
            <input type="hidden" name="addressId" id="addressId">

            <div class="form-group">
                <label for="via">Via:</label>
                <input type="text" id="via" name="via" required>
            </div>
            <div class="form-group">
                <label for="citta">Città:</label>
                <input type="text" id="citta" name="citta" required>
            </div>
            <div class="form-group">
                <label for="cap">CAP:</label>
                <input type="text" id="cap" name="cap" required pattern="[0-9]{5}" title="Il CAP deve essere di 5 cifre numeriche.">
            </div>
            <div class="form-group">
                <label for="tipologia">Tipologia:</label>
                <select id="tipologia" name="tipologia" required>
                    <option value="spedizione">Spedizione</option>
                    <option value="fatturazione">Fatturazione</option>
                    <option value="entrambi">Entrambi</option>
                </select>
            </div>
            <div class="address-modal-actions">
                <button type="button" class="btn-cancel" id="cancelAddressBtn">Annulla</button>
                <button type="submit" class="btn-save">Salva Indirizzo</button>
            </div>
        </form>

        <%-- Sezione per la gestione degli indirizzi esistenti (solo per MODIFICA) --%>
        <% if (userAddresses != null && !userAddresses.isEmpty()) { %>
        <hr style="margin: 25px 0;">
        <h3>I tuoi indirizzi esistenti:</h3>
        <ul style="list-style: none; padding: 0;" id="existingAddressesList">
            <% for (AddressBean addr : userAddresses) { %>
            <li data-id="<%= addr.getId() %>" style="display: flex; justify-content: space-between; align-items: center; padding: 8px 0; border-bottom: 1px dashed #eee;">
                <span><%= addr.getVia() %>, <%= addr.getCitta() %>, <%= addr.getCap() %> (<%= addr.getTipologia().name().toLowerCase() %>)</span>
                <div>
                    <button type="button" class="button-modify edit-address-btn" data-id="<%= addr.getId() %>"
                            data-via="<%= addr.getVia() %>"
                            data-citta="<%= addr.getCitta() %>"
                            data-cap="<%= addr.getCap() %>"
                            data-tipologia="<%= addr.getTipologia().name().toLowerCase() %>">Modifica</button>
                </div>
            </li>
            <% } %>
        </ul>
        <button type="button" class="button-modify" id="addNewAddressBtn" style="margin-top: 15px;">Aggiungi Nuovo Indirizzo</button>
        <% } %>
    </div>
</div>


<script>
    lucide.createIcons();

    const addressModal = document.getElementById('addressModal');
    const closeModalBtn = document.getElementById('closeModalBtn');
    const modifyAddressBtn = document.getElementById('modifyAddressBtn');
    const addAddressBtn = document.getElementById('addAddressBtn'); // Pulsante "Aggiungi Indirizzo" quando non ce n'è uno predefinito
    const cancelAddressBtn = document.getElementById('cancelAddressBtn');
    const addressForm = document.getElementById('addressForm');
    const modalTitle = document.getElementById('modalTitle');
    const addressFormAction = document.getElementById('addressFormAction');
    const addressIdInput = document.getElementById('addressId');
    const viaInput = document.getElementById('via');
    const cittaInput = document.getElementById('citta');
    const capInput = document.getElementById('cap');
    const tipologiaSelect = document.getElementById('tipologia');
    const addNewAddressBtn = document.getElementById('addNewAddressBtn'); // Pulsante "Aggiungi Nuovo Indirizzo" dentro il modale

    // Elementi per la visualizzazione dell'indirizzo predefinito
    const currentAddressDisplay = document.getElementById('currentAddressDisplay');
    const noAddressMessage = document.getElementById('noAddressMessage');
    const displayUserName = document.getElementById('displayUserName');
    const displayVia = document.getElementById('displayVia');
    const displayCittaCap = document.getElementById('displayCittaCap');
    const displayUserPhone = document.getElementById('displayUserPhone');
    const displayUserEmail = document.getElementById('displayUserEmail');

    // Elementi per la sezione "Seleziona un altro indirizzo"
    const selectedAddressSelect = document.getElementById('selectedAddress');
    const changeSelectedAddressBtn = document.getElementById('changeSelectedAddressBtn');
    const finalShippingAddressId = document.getElementById('finalShippingAddressId');
    const existingAddressesList = document.getElementById('existingAddressesList'); // Lista degli indirizzi esistenti nel modale

    // Dati dell'utente correnti (per aggiornare la visualizzazione)
    const currentUserName = '<%= userName %>';
    const currentUserEmail = '<%= userEmail %>';


    // Funzione per aprire il modale
    function openAddressModal(isNew = false, addressData = {}) {
        addressModal.classList.add('active');
        if (isNew) {
            modalTitle.textContent = 'Aggiungi Nuovo Indirizzo';
            addressFormAction.value = 'save';
            addressIdInput.value = '';
            addressForm.reset();
        } else {
            modalTitle.textContent = 'Modifica Indirizzo';
            addressFormAction.value = 'update';
            addressIdInput.value = addressData.id || '';
            viaInput.value = addressData.via || '';
            cittaInput.value = addressData.citta || '';
            capInput.value = addressData.cap || '';
            tipologiaSelect.value = addressData.tipologia || 'spedizione';
        }
    }

    // Funzione per chiudere il modale
    function closeAddressModal() {
        addressModal.classList.remove('active');
    }

    // Event listeners per aprire il modale
    if (modifyAddressBtn) {
        modifyAddressBtn.addEventListener('click', () => {
            const currentAddress = {
                id: '<%= defaultShippingAddress != null ? defaultShippingAddress.getId() : "" %>',
                via: '<%= defaultShippingAddress != null ? defaultShippingAddress.getVia() : "" %>',
                citta: '<%= defaultShippingAddress != null ? defaultShippingAddress.getCitta() : "" %>',
                cap: '<%= defaultShippingAddress != null ? defaultShippingAddress.getCap() : "" %>',
                tipologia: '<%= defaultShippingAddress != null ? defaultShippingAddress.getTipologia().name().toLowerCase() : "" %>'
            };
            openAddressModal(false, currentAddress);
        });
    }

    if (addAddressBtn) { // Pulsante AGGIUNGI INDIRIZZO quando non c'è un predefinito
        addAddressBtn.addEventListener('click', () => {
            openAddressModal(true);
        });
    }

    if (addNewAddressBtn) { // Pulsante AGGIUNGI NUOVO INDIRIZZO dentro il modale
        addNewAddressBtn.addEventListener('click', () => {
            openAddressModal(true);
        });
    }

    // Listener per i pulsanti "Modifica" degli indirizzi esistenti nel modale
    document.querySelectorAll('.edit-address-btn').forEach(button => {
        button.addEventListener('click', (event) => {
            const data = event.target.dataset;
            openAddressModal(false, data);
        });
    });

    // Event listeners per chiudere il modale
    closeModalBtn.addEventListener('click', closeAddressModal);
    cancelAddressBtn.addEventListener('click', closeAddressModal);
    addressModal.addEventListener('click', (event) => {
        if (event.target === addressModal) {
            closeAddressModal();
        }
    });

    // --- Gestione AJAX della sottomissione del form indirizzo ---
    addressForm.addEventListener('submit', async (event) => {
        event.preventDefault(); // Previene il ricaricamento della pagina

        const formData = new FormData(addressForm);
        try {
            const response = await fetch("address", {
                method: 'POST',
                body: new URLSearchParams(formData)
            });

            if (response.ok) {
                // Il servlet dovrebbe rispondere con l'AddressBean salvato/aggiornato in formato JSON
                const updatedAddress = await response.json();
                alert('Indirizzo salvato con successo!');
                closeAddressModal();

                // Aggiorna la visualizzazione dell'indirizzo di spedizione principale
                updateDisplayedAddress(updatedAddress);

                // Re-renderizza la lista degli indirizzi esistenti nel modale e la select
                // (Per ora ricarichiamo la pagina per la select, ma si potrebbe fare AJAX)
                // Se si vuole un aggiornamento completo della lista degli indirizzi (nel modale) e della select,
                // l'approccio più semplice senza riscrivere molta logica lato client è ricaricare la pagina
                // o fare una nuova chiamata AJAX per recuperare *tutti* gli indirizzi dell'utente
                // e ricostruire la lista/select.
                // Per un aggiornamento dinamico completo, il servlet dovrebbe restituire anche
                // la lista aggiornata di tutti gli indirizzi, non solo quello modificato.
                // Per questo esempio, ci concentriamo sull'aggiornamento dell'indirizzo predefinito.
                // Un semplice ricaricamento della pagina (come fallback per la lista nel modale e la select) è comunque efficace.
                // window.location.reload(); // Ricarica per aggiornare lista indirizzi esistenti e select
            } else {
                const errorText = await response.text();
                alert('Errore durante il salvataggio dell\'indirizzo: ' + errorText);
            }
        } catch (error) {
            console.error('Errore nella richiesta AJAX:', error);
            alert('Si è verificato un errore di rete. Riprova più tardi.');
        }
    });

    // Funzione per aggiornare l'indirizzo visualizzato sulla pagina
    function updateDisplayedAddress(address) {
        if (noAddressMessage) { // Se c'era il messaggio "Nessun indirizzo..." lo rimuoviamo
            noAddressMessage.style.display = 'none';
        }
        if (addAddressBtn) { // Nascondi il pulsante "Aggiungi indirizzo" iniziale
            addAddressBtn.style.display = 'none';
        }

        // Assicurati che gli elementi esistano prima di aggiornarli
        if (!displayUserName) {
            // Se gli elementi non esistono (es. la pagina è stata caricata senza defaultAddress),
            // dobbiamo crearli dinamicamente o ricaricare la pagina.
            // Ricaricare la pagina dopo un salvataggio è l'approccio più robusto per ora,
            // specialmente se la lista degli indirizzi e la select devono essere aggiornate.
            window.location.reload();
            return;
        }

        displayUserName.textContent = currentUserName; // Il nome utente rimane lo stesso
        displayVia.textContent = address.via;
        displayCittaCap.textContent = address.citta + ', ' + address.cap;
        displayUserPhone.textContent =  "Telefono " + address.phone;
        displayUserEmail.textContent = "Email " + address.email;

        // Aggiorna anche l'ID nascosto per il form di conferma ordine
        finalShippingAddressId.value = address.id;
    }


    // Per il pulsante "CAMBIA" indirizzo selezionato nella sezione "Seleziona un altro indirizzo"
    if (changeSelectedAddressBtn) {
        changeSelectedAddressBtn.addEventListener('click', async () => {
            const selectedId = selectedAddressSelect.value;
            console.log('Cambiato indirizzo selezionato:', selectedId);
            finalShippingAddressId.value = selectedId;

            try {
                // Invia una richiesta al servlet per impostare questo indirizzo come predefinito
                // e/o per recuperare i suoi dettagli per l'aggiornamento dinamico della pagina.
                // Questo presuppone che la tua AddressServlet abbia un'azione 'set_default' o simile
                // che restituisca l'indirizzo appena impostato come JSON.
                const params = new URLSearchParams();
                params.append('action', 'setDefault');
                params.append('addressId', selectedId);
                const response = await fetch("address", {
                    method: 'POST',
                    body: params
                });

                if (response.ok) {
                    const defaultAddr = await response.json();
                    console.log(defaultAddr);
                    updateDisplayedAddress(defaultAddr); // Aggiorna la visualizzazione principale
                    alert('Indirizzo di spedizione predefinito aggiornato.');
                } else {
                    const errorText = await response.text();
                    alert('Errore durante il cambio dell\'indirizzo predefinito: ' + errorText);
                }
            } catch (error) {
                console.error('Errore nella richiesta AJAX per cambio indirizzo:', error);
                alert('Si è verificato un errore di rete. Riprova più tardi.');
            }
        });
    }

</script>

</body>
</html>