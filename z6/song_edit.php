<?php
declare(strict_types=1);
require __DIR__.'/common.php';$u=cloud_user();$d=db();
try{$id=music_id($_GET['id']??null);}catch(InvalidArgumentException){$id=0;}
$s=$d->prepare('SELECT * FROM z6_song WHERE ids=? AND idu=?');$s->bind_param('ii',$id,$u['id']);$s->execute();$song=$s->get_result()->fetch_assoc();$s->close();
if(!$song){$d->close();http_response_code(404);head('Nie znaleziono Twojego utworu');echo '<a class="btn btn-primary" href="music.php">Utwory</a>';foot();exit;}
if(($_SERVER['REQUEST_METHOD']??'')==='POST'){
    music_post();$cover=null;$committed=false;
    try{
        $title=music_text(posted('title'),250,'Tytuł');$artist=music_text(posted('musician'),250,'Twórca');$album=trim(posted('album'));$lyrics=posted('lyrics');$genre=music_id(posted('genre'));
        if(mb_strlen($album,'UTF-8')>250||mb_strlen($lyrics,'UTF-8')>16000)throw new InvalidArgumentException('Album lub tekst utworu jest zbyt długi.');
        $d->begin_transaction();$s=$d->prepare('SELECT coverfilename FROM z6_song WHERE ids=? AND idu=? FOR UPDATE');$s->bind_param('ii',$id,$u['id']);$s->execute();$locked=$s->get_result()->fetch_assoc();$s->close();if(!$locked)throw new InvalidArgumentException('Utwór nie jest dostępny.');
        $s=$d->prepare('SELECT idmt FROM z6_musictype WHERE idmt=?');$s->bind_param('i',$genre);$s->execute();if(!$s->get_result()->num_rows)throw new InvalidArgumentException('Wybierz gatunek.');$s->close();
        $cover=music_form_cover($u['username']);$image=$cover??$locked['coverfilename'];
        $s=$d->prepare('UPDATE z6_song SET title=?,musician=?,album=?,lyrics=?,idmt=?,coverfilename=? WHERE ids=? AND idu=?');$s->bind_param('ssssisii',$title,$artist,$album,$lyrics,$genre,$image,$id,$u['id']);$s->execute();$s->close();$d->commit();$committed=true;$d->close();
        music_flash('success','Zapisano tagi utworu.');redirect('song.php?id='.$id);
    }catch(Throwable $e){if(!$committed)$d->rollback();$d->close();if(!$committed&&$cover!==null)@unlink(SONGS_DIR.'/'.$cover);music_flash('danger',$e instanceof InvalidArgumentException?$e->getMessage():'Nie udało się zapisać zmian.');redirect('song_edit.php?id='.$id);}
}
$genres=$d->query('SELECT * FROM z6_musictype ORDER BY idmt')->fetch_all(MYSQLI_ASSOC);$d->close();head('Edytuj tagi');music_toolbar('music.php');
?>
<form class="card" method="post" action="song_edit.php?id=<?=$id?>" enctype="multipart/form-data"><div class="card-body p-4"><input type="hidden" name="csrf" value="<?=h(music_csrf())?>">
<div class="row g-4"><div class="col-12 col-lg-7">
<label class="form-label" for="edit-title">Tytuł</label><input class="form-control mb-3" id="edit-title" name="title" value="<?=h($song['title'])?>" maxlength="250" required>
<label class="form-label" for="edit-artist">Twórca</label><input class="form-control mb-3" id="edit-artist" name="musician" value="<?=h($song['musician'])?>" maxlength="250" required>
<label class="form-label" for="edit-album">Album</label><input class="form-control mb-3" id="edit-album" name="album" value="<?=h($song['album']??'')?>" maxlength="250">
<label class="form-label" for="edit-genre">Gatunek</label><select class="form-select mb-4" id="edit-genre" name="genre" required><?php foreach($genres as $g): ?><option value="<?=$g['idmt']?>"<?=(int)$song['idmt']===(int)$g['idmt']?' selected':''?>><?=h($g['name'])?></option><?php endforeach; ?></select>
<button class="btn btn-primary" type="submit">Zapisz tagi</button> <a class="btn btn-outline-light" href="song.php?id=<?=$id?>">Anuluj</a>
</div><div class="col-12 col-lg-5"><?=music_cover_html($id,null,$song['coverfilename'],'Obecna okładka',true)?><label class="form-label mt-3" for="edit-cover">Nowa okładka (opcjonalnie)</label><input class="form-control mb-4" id="edit-cover" type="file" name="cover" accept="image/png,image/jpeg,image/webp"><label class="form-label" for="edit-lyrics">Tekst utworu</label><textarea class="form-control" id="edit-lyrics" name="lyrics" rows="8" maxlength="16000"><?=h($song['lyrics']??'')?></textarea></div></div></div></form>
<?php foot(); ?>
