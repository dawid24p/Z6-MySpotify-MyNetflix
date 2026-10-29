'use strict';
document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('.music-delete').forEach(form => form.addEventListener('submit', event => {
        if (!window.confirm(form.dataset.confirm || 'Usunąć?')) event.preventDefault();
    }));
    document.addEventListener('play', function (event) {
        if (!event.target.matches('audio.music-audio')) return;
        document.querySelectorAll('audio.music-audio').forEach(audio => { if (audio !== event.target) audio.pause(); });
    }, true);
    document.querySelectorAll('[data-audio-track]').forEach(button=>button.addEventListener('click',()=>window.spotifyPlayer.playQueue([JSON.parse(button.dataset.audioTrack)],0)));
    const root = document.querySelector('.music-player');
    if(root){
        const queue=JSON.parse(root.dataset.queue);
        document.getElementById('play-playlist').addEventListener('click',()=>window.spotifyPlayer.playQueue(queue,0));
        root.nextElementSibling.querySelectorAll('.music-track').forEach(row=>{
            const playRow=()=>window.spotifyPlayer.playQueue(queue,Number(row.dataset.row));
            row.tabIndex=0;
            row.setAttribute('aria-label','Odtwórz '+queue[Number(row.dataset.row)].title);
            row.addEventListener('click',event=>{
                if(event.target.closest('a,form,input,select,textarea,label'))return;
                playRow();
            });
            row.addEventListener('keydown',event=>{
                if(event.target!==row||!['Enter',' '].includes(event.key))return;
                event.preventDefault();playRow();
            });
        });
        document.addEventListener('music:change',event=>{
            if(!root.isConnected)return;
            const current=queue.findIndex(x=>Number(x.id)===Number(event.detail.track.id));
            root.nextElementSibling.querySelectorAll('.music-track').forEach(row=>row.classList.toggle('music-current',Number(row.dataset.row)===current));
        });
    }

    const catalog=document.getElementById('music-catalog');
    if(catalog){const buttons=document.querySelectorAll('[data-music-view]');const view=mode=>{catalog.classList.toggle('music-list',mode==='list');buttons.forEach(b=>{const active=b.dataset.musicView===mode;b.classList.toggle('active',active);b.setAttribute('aria-pressed',String(active));});localStorage.setItem('z6-music-view',mode);};buttons.forEach(b=>b.addEventListener('click',()=>view(b.dataset.musicView)));view(localStorage.getItem('z6-music-view')==='list'?'list':'grid');}
    const fileInput = document.getElementById('song-file');
    function decodeText(bytes) {
        const encoding = bytes[0], data = bytes.slice(1);
        return new TextDecoder(({0:'windows-1252',1:'utf-16',2:'utf-16be',3:'utf-8'})[encoding] || 'utf-8').decode(data).replace(/\0/g, '').trim();
    }
    if (fileInput) fileInput.addEventListener('change', async function () {
        const file = fileInput.files[0], status = document.getElementById('tag-status');
        if (!file) return;
        try {
            const data = new Uint8Array(await file.slice(0, 8 * 1024 * 1024).arrayBuffer());
            const text = bytes => String.fromCharCode(...bytes);
            const tags = {};
            if (text(data.slice(0,3)) === 'ID3' && [3,4].includes(data[3])) {
                const version = data[3]; let offset = 10;
                if (data[5] & 0x40) { let extra = 0; for (let i=10;i<14;i++) extra = extra * (version===4?128:256) + data[i]; offset += extra + (version===3?4:0); }
                while (offset + 10 <= data.length) {
                    const frame = text(data.slice(offset, offset+4)); if (!/^[A-Z0-9]{4}$/.test(frame)) break;
                    let size=0; for(let i=offset+4;i<offset+8;i++) size=size*(version===4?128:256)+data[i];
                    offset+=10; if(size<=0||offset+size>data.length) break;
                    if (['TIT2','TPE1','TCON','TALB'].includes(frame)) tags[frame]=decodeText(data.slice(offset,offset+size));
                    offset+=size;
                }
            }
            const title=document.getElementById('song-title'), musician=document.getElementById('song-musician');
            if(tags.TIT2) title.value=tags.TIT2.slice(0,250);
            if(tags.TPE1) musician.value=tags.TPE1.slice(0,250);
            if(tags.TALB) document.getElementById('song-album').value=tags.TALB.slice(0,250);
            if(tags.TCON){const genre=document.getElementById('song-genre'), value=tags.TCON.toLowerCase();const option=Array.from(genre.options).find(o=>o.textContent.toLowerCase()===value);if(option)genre.value=option.value;}
            status.textContent = tags.TIT2 || tags.TPE1 ? 'Odczytano tagi. Możesz poprawić dane przed zapisaniem.' : 'Brak obsługiwanych tagów. Uzupełnij tytuł, wykonawcę i gatunek.';
        } catch (_) { status.textContent = 'Uzupełnij tytuł, wykonawcę i gatunek.'; }
    });
    document.querySelectorAll('.music-upload').forEach(form => form.addEventListener('submit', () => {
        form.querySelector('button[type="submit"]').disabled = true;
        document.getElementById('tag-status').textContent = 'Trwa przesyłanie utworu…';
    }));
});
