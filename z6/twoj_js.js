function myLoadHeader() {
    jQuery('#myHeader').load('header.php', function (_response, status) {
        if (status === 'error') {
            const note = document.createElement('p');
            note.className = 'container text-warning pt-3';
            note.textContent = 'Nie udało się wczytać menu. Odśwież stronę.';
            document.getElementById('myHeader').append(note);
            return;
        }
        const current = window.location.pathname.split('/').pop() || 'index.php';
        document.querySelectorAll('#myHeader a[href]').forEach(function (link) {
            if (link.getAttribute('href') === current) {
                link.classList.add('active');
                link.setAttribute('aria-current', 'page');
                const group = link.closest('.nav-item.dropdown');
                if (group) group.querySelector('.dropdown-toggle').classList.add('active');
            }
        });
        const navbar = document.querySelector('#myHeader .navbar');
        function setOffset() {
            document.documentElement.style.setProperty('--navbar-height', navbar.getBoundingClientRect().height + 'px');
        }
        setOffset();
        if(window.navbarObserver)window.navbarObserver.disconnect();window.navbarObserver=new ResizeObserver(setOffset);window.navbarObserver.observe(navbar);
        const mobile = window.matchMedia('(max-width: 991.98px)');
        const panel = document.getElementById('main_nav');
        if (panel) {
            panel.addEventListener('shown.bs.collapse', setOffset);
            panel.addEventListener('hidden.bs.collapse', setOffset);
        }
        mobile.addEventListener('change', function () {
            const panel = document.getElementById('main_nav');
            if (!panel) return;
            const controller = bootstrap.Collapse.getOrCreateInstance(panel, { toggle: false });
            controller.hide();
        });
    });
}
document.addEventListener('DOMContentLoaded', function () {
    myLoadHeader();
    const input = document.getElementById('avatar');
    const preview = document.getElementById('avatarPreview');
    let previewUrl;
    if (input && preview) input.addEventListener('change', function () {
        if (previewUrl) URL.revokeObjectURL(previewUrl);
        const file = input.files[0];
        if (!file) { preview.src = 'media/default-avatar.svg'; return; }
        if (!['image/png','image/jpeg','image/webp'].includes(file.type) || file.size > 2 * 1024 * 1024) {
            input.value = '';
            preview.src = 'media/default-avatar.svg';
            document.getElementById('avatarHelp').textContent = 'Wybierz PNG, JPG lub WebP o rozmiarze do 2 MB.';
            return;
        }
        previewUrl = URL.createObjectURL(file);
        preview.src = previewUrl;
    });
});