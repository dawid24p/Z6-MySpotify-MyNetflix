<?php
declare(strict_types=1);
require __DIR__.'/common.php';$u=cloud_user();$d=db();try{$song=music_song($d,music_id($_GET['id']??null),(int)$u['id']);}catch(InvalidArgumentException){$song=null;}
if(!$song){$d->close();http_response_code(404);head('Nie znaleziono utworu');echo '<a class="btn btn-primary" href="music.php">Utwory</a>';foot();exit;}
$own=music_own_playlists($d,(int)$u['id']);$d->close();head($song['title']);music_toolbar('music.php');
?>
<section class="card"><div class="card-body p-4">
<div class="music-song-detail mb-4"><div><?=music_cover_html((int)$song['ids'],null,$song['coverfilename'],'Okładka '.$song['title'],true)?></div><div>
<dl class="music-song-data mb-0"><dt>Twórca</dt><dd class="music-artist"><?=h($song['musician'])?></dd><dt>Tytuł</dt><dd class="h3"><?=h($song['title'])?></dd><dt>Album</dt><dd><?=h(trim($song['album']??'')!==''?$song['album']:'—')?></dd><dt>Gatunek</dt><dd><span class="badge text-bg-secondary music-detail-genre"><?=h($song['genre'])?></span></dd></dl>
</div></div>
<?=music_play_button($song)?><?php music_add_form($song,$own); ?>
<?php if(trim($song['lyrics']??'')!==''): ?><h2 class="h5 mt-4">Tekst utworu</h2><div class="music-lyrics"><?=h($song['lyrics'])?></div><?php endif; ?>
<?php if((int)$song['idu']===(int)$u['id']): ?><div class="d-flex flex-wrap gap-2 mt-4"><a class="btn btn-outline-primary btn-sm" href="song_edit.php?id=<?=$song['ids']?>">Edytuj tagi</a><form class="music-delete" method="post" action="music_action.php" data-confirm="Usunąć utwór ze wszystkich playlist i biblioteki?"><input type="hidden" name="csrf" value="<?=h(music_csrf())?>"><input type="hidden" name="action" value="delete_song"><input type="hidden" name="song" value="<?=$song['ids']?>"><button type="submit" class="btn btn-outline-danger btn-sm">Usuń utwór</button></form></div><?php endif; ?>
</div></section>
<?php foot(); ?>
