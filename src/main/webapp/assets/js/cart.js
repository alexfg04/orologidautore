document.addEventListener('DOMContentLoaded', () => {
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

    // aggiorna quantità
    document.body.addEventListener('change', async event => {
        const input = event.target.closest('.quantity-input');
        if (!input) return;

        let qty = parseInt(input.value, 10) || 1;
        if (qty < 1) qty = 1;
        input.value = qty;

        const { productId } = input.dataset;
        const spinner = document.getElementById(`spinner-${productId}`);
        spinner.style.display = 'inline-block';

        try {
            const data = await postXHR('updateQuantity', { productId, quantity: qty });
            if (data.success) {
                document.querySelector('.total p strong').textContent = `€ ${parseFloat(data.total).toFixed(2)}`;
                showNotification('Quantità aggiornata correttamente');
            } else {
                showNotification(`Errore: ${data.message}`, true);
            }
        } catch (err) {
            console.error(err);
            showNotification('Errore durante l\'aggiornamento della quantità', true);
        } finally {
            spinner.style.display = 'none';
        }
    });

    // rimuovi prodotto
    document.body.addEventListener('click', async event => {
        const btn = event.target.closest('.remove-icon');
        if (!btn) return;

        const { productId } = btn.dataset;
        const cartItem = document.getElementById(`item_${productId}`);
        const badge = document.querySelector('.cart-badge');
        if (!confirm('Sei sicuro di voler rimuovere questo prodotto dal carrello?')) return;

        try {
            const data = await postXHR('removeFromCart', { productId });
            if (data.success) {
                fadeOutAndRemove(cartItem, 300);
                document.querySelector('.total p strong').textContent = `€ ${parseFloat(data.total).toFixed(2)}`;
                console.log(data.itemCount);
                if (data.itemCount === 0) {
                    const cartContainer = document.querySelector('.cart-container');
                    const emptyCart = document.createElement('div');
                    emptyCart.className = 'empty-cart';
                    emptyCart.innerHTML = `
                        <h2>Il carrello è vuoto</h2>
                        <p>Non hai ancora aggiunto nessun prodotto al carrello.</p>
                    `;
                    cartContainer.replaceWith(emptyCart);
                    badge.remove();
                } else {
                    badge.textContent = data.itemCount;
                }
                showNotification('Prodotto rimosso dal carrello');
            } else {
                showNotification(`Errore: ${data.message}`, true);
            }
        } catch (err) {
            console.error(err);
            showNotification('Errore durante la rimozione del prodotto', true);
        }
    });
});