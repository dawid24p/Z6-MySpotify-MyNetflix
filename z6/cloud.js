document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.cloud-delete').forEach(function (form) {
        form.addEventListener('submit', function (event) {
            const name = form.elements.name.value;
            if (!window.confirm('Usunąć „' + name + '”? Tej operacji nie można cofnąć.')) event.preventDefault();
        });
    });
    document.querySelectorAll('.cloud-upload-form').forEach(function (form) {
        form.addEventListener('submit', function () {
            const status = form.querySelector('.cloud-upload-status');
            status.textContent = 'Trwa przesyłanie plików. Poczekaj na zakończenie.';
            const button = form.querySelector('button[type="submit"]');
            button.disabled = true;
        });
    });
});
