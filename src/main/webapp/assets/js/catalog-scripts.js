const priceRange = document.getElementById('price-range');
const output = document.getElementById('price-display');
const filterForm = document.getElementById('filter-form');


function updateSlider() {
    const val = priceRange.value;
    output.textContent = `${val}`;
    const percent = (val - priceRange.min) / (priceRange.max - priceRange.min) * 100;
    priceRange.style.setProperty('--value', percent + '%');
}

priceRange.addEventListener('input', updateSlider);
// Inizializza
updateSlider();

priceRange.addEventListener('change', function () {
    if (priceRange && priceRange.value === "0") {
        priceRange.disabled = true;
    }
    filterForm.submit();
})

// Aggiungi event listener a tutti i checkbox per invio automatico
document.querySelectorAll('input[type="checkbox"]').forEach(checkbox => {
    checkbox.addEventListener('change', function () {
        if (priceRange && priceRange.value === "0") {
            priceRange.disabled = true;
        }
        filterForm.submit();
    });
});

document.querySelectorAll('.sorting-tabs button').forEach(button => {
    button.addEventListener('click', function () {
        // Ottieni il valore di ordinamento dal data-attribute
        const sortValue = this.getAttribute('data-sort');

        // Se il prezzo è zero, disabilita l'input così non verrà inviato
        if (priceRange && priceRange.value === "0") {
            priceRange.disabled = true;
        }

        // create sort-input element in DOM
        if (!document.getElementById('sort-input')) {
            const sortInput = document.createElement('input');
            sortInput.setAttribute('type', 'hidden');
            sortInput.setAttribute('name', 'sort');
            sortInput.setAttribute('id', 'sort-input');
            filterForm.appendChild(sortInput);
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

const AUTO_CLOSE_DELAY = 5000;

// Utility: fade out and remove an element
const fadeOutAndRemove = (el, duration = 500) => {
    el.style.transition = `opacity ${duration}ms`;
    el.style.opacity = '0';
    setTimeout(() => el.remove(), duration);
};

// Show notification (error or success)
const showNotification = (message, isError = false) => {
    const notification = document.createElement('div');
    notification.className = `error-notification danger`;
    notification.innerHTML = `
        ${message}
        <span class="close" aria-label="Chiudi">&times;</span>
    `;
    document.body.appendChild(notification);

    const closeBtn = notification.querySelector('.close');
    closeBtn.addEventListener('click', () => fadeOutAndRemove(notification));
    setTimeout(() => fadeOutAndRemove(notification), AUTO_CLOSE_DELAY);
};

// Send AJAX POST with XMLHttpRequest, return Promise resolving to parsed JSON or rejecting
const postXHR = (url, data) => new Promise((resolve, reject) => {
    const xhr = new XMLHttpRequest();
    xhr.open('POST', url, true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.onreadystatechange = () => {
        if (xhr.readyState !== 4) return;
        if (xhr.status === 200) {
            try {
                resolve(JSON.parse(xhr.responseText));
            } catch (e) {
                reject(new Error('Parsing error'));
            }
        } else {
            reject(new Error(`HTTP ${xhr.status}`));
        }
    };
    const body = Object.entries(data)
        .map(([k, v]) => `${encodeURIComponent(k)}=${encodeURIComponent(v)}`)
        .join('&');
    xhr.send(body);
});

document.querySelectorAll('.wishlist').forEach((btn) => {
    btn.addEventListener('click', async (e) => {
        e.preventDefault();
        const productId = btn.getAttribute('data-codice');
        // seleziono l'icona cuore, sia che sia .heart-shape sia che sia .heart-full
        const heartIcon = btn.querySelector('.heart-shape, .heart-full');

        try {
            const data = await postXHR('favorite', { productId });

            if (data.success) {
                // inverto sempre le classi
                heartIcon.classList.toggle('heart-full');
                heartIcon.classList.toggle('heart-shape');

                // mostro messaggio corretto in base al server
                if (data.removed) {
                    showNotification('Prodotto rimosso dai preferiti');
                } else {
                    showNotification('Prodotto aggiunto ai preferiti');
                }

            } else if (data.redirect) {
                // se il server richiede redirect
                window.location.href = data.redirect;

            } else {
                // fallback errore applicativo
                showNotification(`Errore: ${data.message}`, true);
            }

        } catch (err) {
            console.error(err);
            showNotification('Errore durante l’aggiornamento dei preferiti', true);
        }
    });
});

// Toggle sidebar visibility on mobile
const filterToggle = document.getElementById('filter-toggle');
const sidebar = document.querySelector('.sidebar');
if (filterToggle && sidebar) {
    filterToggle.addEventListener('click', () => {
        sidebar.classList.toggle('open');
    });
}
