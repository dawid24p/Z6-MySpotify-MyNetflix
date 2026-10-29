<?php declare(strict_types=1);
$savedPlayer=null;try{$playerUser=current_user();if($playerUser){$playerDb=db();$stmt=$playerDb->prepare('SELECT state FROM z6_player_state WHERE idu=?');$stmt->bind_param('i',$playerUser['id']);$stmt->execute();$savedPlayer=$stmt->get_result()->fetch_assoc()['state']??null;$playerDb->close();}}catch(Throwable $error){error_log('Player state read: '.$error->getMessage());}
$icons=[
'play'=>'<path d="m9 5 11 7-11 7Z" fill="currentColor" stroke="none"/>',
'previous'=>'<path d="M5 5v14M19 5 7 12l12 7Z"/>',
'next'=>'<path d="M19 5v14M5 5l12 7-12 7Z"/>',
'shuffle'=>'<path d="M3 6h3c5 0 7 12 12 12h3m-4-4 4 4-4 4M3 18h3c2 0 4-2 6-6s4-6 6-6h3m-4-4 4 4-4 4"/>',
'repeat'=>'<path d="m17 2 4 4-4 4M3 11V9a3 3 0 0 1 3-3h15M7 22l-4-4 4-4m14-1v2a3 3 0 0 1-3 3H3"/>',
'queue'=>'<path d="M3 5h14M3 11h14M3 17h9m5-2 4 3-4 3Z"/>',
'volume'=>'<path d="M3 9h4l5-4v14l-5-4H3Zm13-1a6 6 0 0 1 0 8m3-11a10 10 0 0 1 0 14"/>',
];
$svg=static fn(string $name):string=>'<svg viewBox="0 0 24 24" width="20" height="20" aria-hidden="true" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">'.$icons[$name].'</svg>';
?>
<section id="spotify-player" data-csrf="<?=h(music_csrf())?>" data-saved="<?=h($savedPlayer??'null')?>" class="spotify-player" aria-label="Odtwarzacz muzyki" data-user="<?=h(hash('sha256',(string)$_SESSION['username']))?>">
<audio id="spotify-audio" preload="none"></audio>
<div class="spotify-current"><span class="spotify-art"><img id="spotify-cover" alt="Okładka odtwarzanego utworu" hidden><span id="spotify-cover-empty" aria-hidden="true">♫</span></span><div class="spotify-info"><a id="spotify-title" class="spotify-title">Wybierz utwór</a><div id="spotify-artist" class="spotify-artist">mySpotify</div></div></div>
<div class="spotify-center"><div class="spotify-buttons"><button class="spotify-icon" id="spotify-shuffle" type="button" aria-label="Odtwarzanie losowe" aria-pressed="false"><?=$svg('shuffle')?></button><button class="spotify-icon" id="spotify-previous" type="button" aria-label="Poprzedni utwór" disabled><?=$svg('previous')?></button><button class="spotify-play" id="spotify-toggle" type="button" aria-label="Odtwórz" disabled><?=$svg('play')?></button><button class="spotify-icon" id="spotify-next" type="button" aria-label="Następny utwór" disabled><?=$svg('next')?></button><button class="spotify-icon" id="spotify-repeat" type="button" aria-label="Powtarzanie wyłączone" aria-pressed="false"><?=$svg('repeat')?><span id="spotify-repeat-one" hidden>1</span></button></div><div class="spotify-progress"><span id="spotify-time">0:00</span><label class="visually-hidden" for="spotify-seek">Pozycja odtwarzania</label><input id="spotify-seek" type="range" min="0" max="1000" value="0" disabled><span id="spotify-duration">0:00</span></div><p id="spotify-status" class="visually-hidden" role="status"></p></div>
<div class="spotify-right"><button class="spotify-icon" id="spotify-queue-toggle" type="button" aria-label="Kolejka odtwarzania" aria-expanded="false" aria-controls="spotify-queue"><?=$svg('queue')?></button><button class="spotify-icon" id="spotify-mute" type="button" aria-label="Wycisz" aria-pressed="false"><?=$svg('volume')?></button><label class="visually-hidden" for="spotify-volume">Głośność</label><input id="spotify-volume" type="range" min="0" max="100" value="75"></div>
<aside id="spotify-queue" class="spotify-queue" hidden><div class="d-flex justify-content-between align-items-center mb-3"><h2 class="h6 mb-0">Kolejka odtwarzania</h2><button type="button" class="spotify-icon" id="spotify-queue-close" aria-label="Zamknij kolejkę">✕</button></div><ol id="spotify-queue-list"></ol></aside>
</section>
