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
    // --- gestione Aggiungi/Rimuovi preferiti su product.jsp
    const favBtn = document.getElementById('favBtn');
    if (favBtn) {
        favBtn.addEventListener('click', async e => {
            e.preventDefault();

            const productId = favBtn.getAttribute('data-product-id');
            try {
                const data = await postXHR('favorite', { productId });

                if (data.redirect) {
                    return window.location.href = data.redirect;
                }

                if (data.success) {
                    const badge = document.querySelector('.favorites-badge');
                    let count = badge ? parseInt(badge.dataset.count || badge.textContent, 10) : 0;

                    if (data.removed) {
                        favBtn.classList.remove('favorited');
                        favBtn.innerHTML = '<span class="heart-icon"></span> Aggiungi ai Preferiti';
                        count = Math.max(0, count - 1);
                        showNotification('Prodotto rimosso dai preferiti');
                    } else {
                        favBtn.classList.add('favorited');
                        favBtn.innerHTML = '<span class="heart-icon"></span> Rimuovi dai Preferiti';
                        count += 1;
                        showNotification('Prodotto aggiunto ai preferiti');
                    }

                    if (badge) {
                        badge.dataset.count = count;
                        badge.textContent = count;
                    }
                    return;
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
