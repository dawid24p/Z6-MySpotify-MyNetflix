<?php
declare(strict_types=1);
require __DIR__.'/common.php';$u=cloud_user();$d=db();try{$film=video_film($d,video_id($_GET['id']??null),(int)$u['id']);}catch(InvalidArgumentException){$film=null;}
if(!$film){$d->close();http_response_code(404);head('Nie znaleziono filmu');echo '<a class="btn btn-primary" href="films.php">Filmy</a>';foot();exit;}
$own=video_own_playlists($d,(int)$u['id']);
$s=$d->prepare('SELECT position_seconds,completed FROM z6v_watch_progress WHERE idu=? AND idf=?');$s->bind_param('ii',$u['id'],$film['idf']);$s->execute();$progress=$s->get_result()->fetch_assoc();$resume=$progress&&!$progress['completed']?(float)$progress['position_seconds']:0;
$s=$d->prepare('SELECT idpl FROM z6v_playlistdatabase WHERE idf=? AND idpl IN(SELECT idpl FROM z6v_playlistname WHERE idu=?)');$s->bind_param('ii',$film['idf'],$u['id']);$s->execute();$members=array_column($s->get_result()->fetch_all(MYSQLI_ASSOC),'idpl');$d->close();head($film['title']);video_toolbar('films.php');
?>
<a class="film-close film-details-close mb-3" href="films.php" aria-label="Wróć do listy filmów">✕</a>
<section class="card"><div class="card-body p-4">
<div class="film-detail-poster mb-4"><?=video_cover_html((int)$film['idf'],null,$film['coverfilename'],'Okładka '.$film['title'],true)?></div>
<h2 class="h3"><?=h($film['title'])?></h2>
<dl class="video-film-data mb-4"><dt>Gatunek</dt><dd><span class="badge text-bg-secondary video-detail-genre"><?=h($film['genre'])?></span></dd><dt>Czas trwania</dt><dd><?=h(video_duration_label($film['duration_seconds']===null?null:(int)$film['duration_seconds']))?></dd><dt>Reżyser</dt><dd><?=h($film['director'])?></dd><dt>Opis filmu</dt><dd class="film-description"><?=h(trim($film['description']??'')!==''?$film['description']:'Nie dodano opisu.')?></dd></dl>
<div class="mb-3"><?php video_membership_form($film,$own,$members); ?></div>
<button type="button" class="btn btn-primary mb-4" id="play-film" aria-controls="film-viewer"><?=$resume>0?'Kontynuuj oglądanie od '.h(video_duration_label((int)$resume)):'▶ Odtwórz'?></button>
<button type="button" class="btn btn-outline-light mb-4" id="restart-film"<?=$resume>0?'':' hidden'?>>Oglądaj od nowa</button>
<dialog id="film-viewer" aria-label="Odtwarzanie filmu <?=h($film['title'])?>"><button type="button" class="film-close film-viewer-close" id="close-film" aria-label="Wróć do opisu filmu">✕</button><video id="film-player" data-film="<?=$film['idf']?>" data-csrf="<?=h(video_csrf())?>" data-position="<?=$resume?>" tabindex="0" class="video-media w-100 mb-4" controls playsinline preload="none" hidden data-src="film_file.php?id=<?=$film['idf']?>"><?php if(str_contains($film['subtitles']??'','-->')): ?><track kind="subtitles" src="film_subtitles.php?id=<?=$film['idf']?>" srclang="pl" label="Polski" default><?php endif; ?></video></dialog>
<?php if(trim($film['subtitles']??'')!==''): ?><h2 class="h5 mt-4">Napisy</h2><div class="video-subtitles"><?=h($film['subtitles'])?></div><?php endif; ?>
<?php if((int)$film['idu']===(int)$u['id']): ?><form class="mt-4 video-delete" method="post" action="video_action.php" data-confirm="Usunąć film ze wszystkich playlist i biblioteki?"><input type="hidden" name="csrf" value="<?=h(video_csrf())?>"><input type="hidden" name="action" value="delete_film"><input type="hidden" name="film" value="<?=$film['idf']?>"><button type="submit" class="btn btn-outline-danger btn-sm">Usuń film</button></form><?php endif; ?>
</div></section>
<?php foot(); ?>
