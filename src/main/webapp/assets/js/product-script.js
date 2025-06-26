// assets/js/product-script.js

// Delay per la chiusura automatica delle notifiche
const AUTO_CLOSE_DELAY = 5000;

// Utility: fade out e rimozione
const fadeOutAndRemove = (el, duration = 500) => {
    el.style.transition = `opacity ${duration}ms`;
    el.style.opacity = '0';
    setTimeout(() => el.remove(), duration);
};

// Mostra notifiche di successo o errore
const showNotification = (message, isError = false) => {
    const notification = document.createElement('div');
    notification.className = `error-notification${isError ? ' danger' : ''}`;
    notification.innerHTML = `
    ${message}
    <span class="close" aria-label="Chiudi">&times;</span>
  `;
    document.body.appendChild(notification);

    const closeBtn = notification.querySelector('.close');
    closeBtn.addEventListener('click', () => fadeOutAndRemove(notification));
    setTimeout(() => fadeOutAndRemove(notification), AUTO_CLOSE_DELAY);
};

// Invia POST URL-encoded e ritorna JSON
const postXHR = (url, data) => new Promise((resolve, reject) => {
    const xhr = new XMLHttpRequest();
    xhr.open('POST', url, true);
    xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
    xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
    xhr.onreadystatechange = () => {
        if (xhr.readyState !== 4) return;
        if (xhr.status === 200) {
            try { resolve(JSON.parse(xhr.responseText)); }
            catch (e) { reject(new Error('Parsing error')); }
        } else {
            reject(new Error(`HTTP ${xhr.status}`));
        }
    };
    const body = Object.entries(data)
        .map(([k, v]) => `${encodeURIComponent(k)}=${encodeURIComponent(v)}`)
        .join('&');
    xhr.send(body);
});

document.addEventListener('DOMContentLoaded', () => {
    // --- gestione Aggiungi preferiti su product-detail.jsp
    const favForm = document.getElementById('favForm');
    if (favForm) {
        favForm.addEventListener('submit', async e => {
            e.preventDefault();

            const productId = favForm.querySelector('input[name=productId]').value;
            try {
                const data = await postXHR(favForm.action, { productId });

                if (data.redirect) {
                    return window.location.href = data.redirect;
                }
                if (data.success) {
                    return window.location.href = `${favForm.action.replace(/\/favorite$/, '')}/favorites.jsp`;
                }
                showNotification(`Errore: ${data.message}`, true);
            } catch (err) {
                console.error(err);
                showNotification('Errore durante l’aggiornamento dei preferiti', true);
            }
        });
    }

    // --- gestione Rimuovi preferiti su favorites.jsp
    document.querySelectorAll('.remove-favorite').forEach(btn => {
        btn.addEventListener('click', async e => {
            e.preventDefault();
            const form = btn.closest('form');
            const productIdInput = form.querySelector('input[name="productId"]');
            const productId = productIdInput ? productIdInput.value : null;
            try {
                const data = await postXHR(form.action, { productId });
                if (data.redirect) {
                    return window.location.href = data.redirect;
                }
                if (data.success) {
                    return window.location.reload();
                }
                showNotification(`Errore: ${data.message}`, true);
            } catch (err) {
                console.error(err);
                showNotification('Errore durante la rimozione dai preferiti', true);
            }
        });
    });
});
