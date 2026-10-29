'use strict';
document.addEventListener('DOMContentLoaded', function () {
    if(window.filmProgressController){window.filmProgressController.destroy();window.filmProgressController=null;}
    document.body.classList.remove('film-watching');
    document.querySelectorAll('.video-membership').forEach(form=>{const select=form.querySelector('select');const update=()=>{const present=select.selectedOptions[0]?.dataset.present==='1';form.elements.action.value=present?'remove_film':'add_film';form.querySelector('button').textContent=present?'Usuń z playlisty':'Dodaj do playlisty';};select.addEventListener('change',update);update();});
    document.querySelectorAll('.video-delete').forEach(form => form.addEventListener('submit', event => {
        if (!window.confirm(form.dataset.confirm || 'Usunąć?')) event.preventDefault();
    }));
    document.addEventListener('play', function (event) {
        if (!event.target.matches('video.video-media')) return;
        document.querySelectorAll('video.video-media').forEach(audio => { if (audio !== event.target) audio.pause(); });
    }, true);
    const playFilm=document.getElementById('play-film'),filmPlayer=document.getElementById('film-player'),viewer=document.getElementById('film-viewer'),closeFilm=document.getElementById('close-film');
    if(playFilm&&filmPlayer&&viewer&&closeFilm){
        let hideTimer,resume=Number(filmPlayer.dataset.position)||0,finished=false,lastSave=0,pending=Promise.resolve();
        const restart=document.getElementById('restart-film'),holder=document.createComment('film-viewer');viewer.before(holder);
        const label=seconds=>{seconds=Math.floor(seconds);return seconds>=3600?Math.floor(seconds/3600)+':'+String(Math.floor(seconds%3600/60)).padStart(2,'0')+':'+String(seconds%60).padStart(2,'0'):Math.floor(seconds/60)+':'+String(seconds%60).padStart(2,'0');};
        const updateButtons=()=>{playFilm.textContent=resume>0&&!finished?'Kontynuuj oglądanie od '+label(resume):'▶ Odtwórz';restart.hidden=!(resume>0&&!finished);};
        function saveProgress(beacon=false){
            if(!filmPlayer.hasAttribute('src'))return pending;
            if(Number.isFinite(filmPlayer.currentTime))resume=filmPlayer.currentTime;
            updateButtons();lastSave=Date.now();
            const data=new FormData();data.append('csrf',filmPlayer.dataset.csrf);data.append('film',filmPlayer.dataset.film);data.append('position',String(resume));data.append('completed',finished?'1':'0');
            if(beacon){navigator.sendBeacon('film_progress.php',data);return pending;}
            pending=pending.catch(()=>{}).then(()=>fetch('film_progress.php',{method:'POST',body:data,credentials:'same-origin',keepalive:true})).catch(()=>{});return pending;
        }
        const showClose=()=>{viewer.classList.add('film-controls-visible');clearTimeout(hideTimer);hideTimer=setTimeout(()=>viewer.classList.remove('film-controls-visible'),2500);};
        const closeViewer=()=>{filmPlayer.pause();if(viewer.open)viewer.close();};
        function startFilm(fromStart=false){
            if(fromStart||finished){resume=0;finished=false;}
            const position=resume;
            document.body.append(viewer);document.body.classList.add('film-watching');viewer.showModal();filmPlayer.hidden=false;
            const seek=()=>{filmPlayer.currentTime=Math.min(position,Number.isFinite(filmPlayer.duration)?Math.max(0,filmPlayer.duration-.1):position);};
            if(!filmPlayer.hasAttribute('src')){filmPlayer.addEventListener('loadedmetadata',seek,{once:true});filmPlayer.src=filmPlayer.dataset.src;}else if(filmPlayer.readyState>0)seek();else filmPlayer.addEventListener('loadedmetadata',seek,{once:true});
            filmPlayer.play().catch(()=>{});filmPlayer.focus({preventScroll:true});showClose();
        }
        playFilm.addEventListener('click',()=>startFilm());restart.addEventListener('click',()=>startFilm(true));
        closeFilm.addEventListener('click',closeViewer);
        viewer.addEventListener('pointermove',showClose);viewer.addEventListener('pointerdown',showClose);viewer.addEventListener('keydown',showClose);
        viewer.addEventListener('cancel',event=>{event.preventDefault();closeViewer();});
        viewer.addEventListener('close',()=>{clearTimeout(hideTimer);filmPlayer.pause();filmPlayer.hidden=true;document.body.classList.remove('film-watching');if(holder.isConnected)holder.after(viewer);saveProgress();playFilm.focus({preventScroll:true});});
        filmPlayer.addEventListener('timeupdate',()=>{if(Date.now()-lastSave>5000)saveProgress();});
        filmPlayer.addEventListener('pause',()=>saveProgress());
        filmPlayer.addEventListener('seeked',()=>saveProgress());
        filmPlayer.addEventListener('ended',()=>{finished=true;saveProgress();});
        const onPageHide=()=>saveProgress(true),onVisibility=()=>{if(document.hidden)saveProgress(true);};
        window.addEventListener('pagehide',onPageHide);document.addEventListener('visibilitychange',onVisibility);
        window.filmProgressController={flush(){closeViewer();return saveProgress();},destroy(){clearTimeout(hideTimer);closeViewer();window.removeEventListener('pagehide',onPageHide);document.removeEventListener('visibilitychange',onVisibility);}};
        updateButtons();
    }
    const root = document.querySelector('.video-player');
    if (root) {
        const queue = JSON.parse(root.dataset.queue), audio = document.getElementById('playlist-player');
        const previous = document.getElementById('previous-film'), next = document.getElementById('next-film');
        const status = document.getElementById('player-status');
        let current = 0;
        function update() {
            document.getElementById('now-title').textContent = queue[current].title;
            document.getElementById('now-director').textContent = queue[current].director;
            document.getElementById('queue-position').textContent = (current + 1) + ' / ' + queue.length;
            previous.disabled = current === 0; next.disabled = current === queue.length - 1;
            document.querySelectorAll('.video-track').forEach(row => row.classList.toggle('video-current', Number(row.dataset.row) === current));
        }
        function play(index) {
            if (index < 0 || index >= queue.length) return;
            status.textContent = '';
            if (current !== index) { current = index; audio.src = queue[current].url; const track=document.getElementById('playlist-subtitles');if(track)track.src='film_subtitles.php?id='+queue[current].id; }
            update();
            audio.play().catch(() => { status.textContent = 'Nie udało się odtworzyć nagrania. Spróbuj ponownie.'; });
        }
        previous.addEventListener('click', () => play(current - 1));
        next.addEventListener('click', () => play(current + 1));
        document.getElementById('play-playlist').addEventListener('click', () => play(current));
        document.querySelectorAll('[data-track]').forEach(button => button.addEventListener('click', () => play(Number(button.dataset.track))));
        audio.addEventListener('ended', () => { if (current + 1 < queue.length) play(current + 1); else status.textContent = 'Koniec playlisty.'; });
        audio.addEventListener('error', () => { status.textContent = 'Nagranie jest niedostępne lub format nie jest obsługiwany.'; });
        update();
    }
    document.querySelectorAll('.video-upload').forEach(form=>form.addEventListener('submit',()=>{form.querySelector('button[type="submit"]').disabled=true;document.getElementById('video-upload-status').textContent='Trwa przesyłanie filmu…';}));
});
