(function () {
    const navbar = document.querySelector('.navbar-wrapper');
    const navH = navbar.offsetHeight;
    let lastScroll = 0;
    let isFixed = false;
    let fixedOn = ''; // 'window' o 'wrapper'

    function handleScroll(currentScroll, ctx) {
        // 1) Fissa la navbar al primo scroll di ciascun contesto
        if (currentScroll > 0 && !isFixed) {
            navbar.classList.add('fixed');
            if (ctx === 'window') {
                document.body.style.paddingTop = navH + 'px';
            } else {
                wrapper.style.paddingTop = navH + 'px';
            }
            isFixed = true;
            fixedOn = ctx;
        } else if (currentScroll === 0 && isFixed && fixedOn === ctx) {
            navbar.classList.remove('fixed', 'hide');
            if (ctx === 'window') {
                document.body.style.paddingTop = '0';
            } else {
                wrapper.style.paddingTop = '0';
            }
            isFixed = false;
            fixedOn = '';
        }

        // 2) Hide/Show con soglia 100px
        if (currentScroll > lastScroll && currentScroll > 100) {
            navbar.classList.add('hide');
        } else if (currentScroll < lastScroll) {
            navbar.classList.remove('hide');
        }
        // se sei entro i primi 100px, mostrala comunque
        if (currentScroll <= 100) {
            navbar.classList.remove('hide');
        }

        lastScroll = currentScroll;
    }

    // listener su window
    window.addEventListener('scroll', () => {
        handleScroll(window.scrollY, 'window');
    });

    // listener sul wrapper
    const container = document.querySelector('.main-content');

    container.addEventListener('scroll', () => {
        handleScroll(container.scrollTop, 'container');
    });
})();