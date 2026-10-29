document.addEventListener('DOMContentLoaded',function(){
 const body=document.body,data=body.dataset;
 const parser=new UAParser(),r=parser.getResult();
 let os=[r.os.name,r.os.version].filter(Boolean).join(' ');
 if(navigator.maxTouchPoints>1 && navigator.platform==='MacIntel')os='iPadOS';
 const metrics={browser:[r.browser.name,r.browser.version].filter(Boolean).join(' ')||'Nierozpoznana',operating_system:os,screen_width:screen.width,screen_height:screen.height,window_width:innerWidth,window_height:innerHeight,color_depth:screen.colorDepth,cookies_enabled:navigator.cookieEnabled,java_enabled:typeof navigator.javaEnabled==='function'?navigator.javaEnabled():false,language:navigator.language,pixel_ratio:devicePixelRatio};
 for(const kind of ['visit','loginVisit']){const id=data[kind+'Id'],token=data[kind+'Token'];if(id&&token)fetch('visit_meta.php',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({...metrics,id,token}),credentials:'same-origin'}).catch(()=>{});}
 const info=document.getElementById('deviceInfo');
 if(info){for(const [key,value] of Object.entries(metrics)){const cell=info.querySelector('[data-metric="'+key+'"]');if(cell)cell.textContent=typeof value==='boolean'?(value?'Tak':'Nie'):String(value);}}
 const groups=new Map();document.querySelectorAll('[data-geo-ip]').forEach(node=>{const ip=node.dataset.geoIp;if(!groups.has(ip))groups.set(ip,[]);groups.get(ip).push(node);});
 const queue=[...groups.entries()];
 async function worker(){while(queue.length){const [ip,nodes]=queue.shift();try{const response=await fetch('geo_api.php?ip='+encodeURIComponent(ip),{headers:{'X-Geo-Token':data.geoCsrf},credentials:'same-origin'});const geo=await response.json();for(const node of nodes){node.textContent=geo.error||[geo.city,geo.region,geo.country].filter(Boolean).join(', ');if(geo.map){const link=document.createElement('a');link.href=geo.map;link.target='_blank';link.rel='noopener noreferrer';link.textContent='Google Maps';node.append(document.createElement('br'),link);}}}catch(_){nodes.forEach(node=>node.textContent='Geolokalizacja niedostępna.');}}}
 for(let i=0;i<3;i++)worker();
});