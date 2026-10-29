'use strict';
(function(){
 if(window.appNavigationReady)return;window.appNavigationReady=true;
 let navigating=false;
 const excluded=/(?:^|\/)(?:logout|song_file|film_file|cloud_file|artwork|film_artwork|film_subtitles|geo_api|visit_meta|monitor_api)\.php$/;
 async function show(url,options={},push=true){
  if(navigating)return;navigating=true;const main=document.querySelector('main');if(main)main.setAttribute('aria-busy','true');
  try{
   if(window.filmProgressController)await window.filmProgressController.flush();
   const response=await fetch(url,{credentials:'same-origin',...options});
   const html=await response.text(),doc=new DOMParser().parseFromString(html,'text/html'),next=doc.querySelector('main');
   if(!next){const message=(doc.body.textContent||'Nie udało się otworzyć strony.').trim();window.alert(message.slice(0,500));return;}
   if(!doc.getElementById('spotify-player')){window.location.assign(response.url);return;}
   const changedScript=Array.from(doc.querySelectorAll('script[src]')).some(script=>{const wanted=new URL(script.getAttribute('src'),response.url);return Array.from(document.querySelectorAll('script[src]')).some(current=>{const loaded=new URL(current.src,location.href);return loaded.origin===wanted.origin&&loaded.pathname===wanted.pathname&&loaded.search!==wanted.search;});});
   if(changedScript){if(window.spotifyPlayer&&window.spotifyPlayer.flush)await window.spotifyPlayer.flush();window.location.assign(response.url);return;}
   document.title=doc.title;
   doc.querySelectorAll('link[rel="stylesheet"]').forEach(link=>{const href=new URL(link.getAttribute('href'),response.url).href;if(!Array.from(document.querySelectorAll('link[rel="stylesheet"]')).some(x=>x.href===href)){const sheet=document.createElement('link');sheet.rel='stylesheet';sheet.href=href;document.head.append(sheet);}});
   main.replaceWith(document.importNode(next,true));
   for(const attr of Array.from(document.body.attributes))if(attr.name.startsWith('data-'))document.body.removeAttribute(attr.name);
   for(const attr of Array.from(doc.body.attributes))if(attr.name.startsWith('data-'))document.body.setAttribute(attr.name,attr.value);
   const target=new URL(response.url);if(push)history.pushState({},'',target.pathname+target.search+target.hash);
   document.dispatchEvent(new Event('DOMContentLoaded'));
   if(window.spotifyPlayer){const state=window.spotifyPlayer.state();if(state.queue.length)document.dispatchEvent(new CustomEvent('music:change',{detail:{...state,track:state.queue[state.index]}}));}
   if(target.hash){const node=document.getElementById(decodeURIComponent(target.hash.slice(1)));if(node)node.scrollIntoView();else window.scrollTo(0,0);}else window.scrollTo(0,0);
  }catch(error){window.alert('Nie udało się otworzyć strony. Sprawdź połączenie i spróbuj ponownie.');}
  finally{navigating=false;const current=document.querySelector('main');if(current)current.removeAttribute('aria-busy');}
 }
 document.addEventListener('click',event=>{
  if(event.defaultPrevented||event.button!==0||event.ctrlKey||event.metaKey||event.shiftKey||event.altKey||!document.getElementById('spotify-player'))return;
  const link=event.target.closest('a[href]');if(!link||link.hasAttribute('download')||(link.target&&link.target!=='_self'))return;
  const url=new URL(link.href,location.href);if(url.origin!==location.origin||!url.pathname.startsWith('/z6/')||excluded.test(url.pathname))return;
  if(url.pathname===location.pathname&&url.search===location.search&&url.hash)return;
  event.preventDefault();show(url.href);
 });
 document.addEventListener('submit',event=>{
  if(event.defaultPrevented||!document.getElementById('spotify-player'))return;
  const form=event.target;if(!(form instanceof HTMLFormElement)||form.target||form.dataset.fullNavigation==='true')return;
  const url=new URL(form.getAttribute('action')||location.href,location.href);if(url.origin!==location.origin||!url.pathname.startsWith('/z6/')||excluded.test(url.pathname))return;
  event.preventDefault();const data=new FormData(form);if(event.submitter&&event.submitter.name)data.append(event.submitter.name,event.submitter.value);
  const method=(form.method||'GET').toUpperCase();if(method==='GET'){url.search=new URLSearchParams(data).toString();show(url.href);}else show(url.href,{method,body:data});
 });
 window.addEventListener('popstate',()=>{if(document.getElementById('spotify-player'))show(location.href,{},false);});
})();
