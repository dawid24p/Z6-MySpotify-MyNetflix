<?php
declare(strict_types=1);
require __DIR__.'/common.php';$u=cloud_user();music_post();$d=null;$relative=null;$committed=false;$cover=null;
try{
    $file=$_FILES['song']??null;
    if(!is_array($file)||($file['error']??UPLOAD_ERR_NO_FILE)!==UPLOAD_ERR_OK||!is_string($file['tmp_name']??null)||!is_uploaded_file($file['tmp_name']))throw new InvalidArgumentException('Nie udało się przesłać MP3. Wybierz plik i sprawdź limit przesyłania na hostingu.');
    music_mp3($file['tmp_name'],(string)$file['name']);$tags=music_tags($file['tmp_name']);
    $title=music_text(posted('title')?:$tags['title'],250,'Tytuł');$musician=music_text(posted('musician')?:$tags['musician'],250,'Wykonawca');$album=trim(posted('album')?:$tags['album']);if(mb_strlen($album,'UTF-8')>250)throw new InvalidArgumentException('Nazwa albumu może mieć maksymalnie 250 znaków.');$genre=music_id(posted('genre'));$lyrics=posted('lyrics');if(mb_strlen($lyrics,'UTF-8')>16000)throw new InvalidArgumentException('Tekst utworu może mieć maksymalnie 16000 znaków.');
    $d=db();$d->begin_transaction();$s=$d->prepare('SELECT idmt FROM z6_musictype WHERE idmt=?');$s->bind_param('i',$genre);$s->execute();if(!$s->get_result()->num_rows)throw new InvalidArgumentException('Wybierz gatunek.');$s->close();
    $relative=music_store($file['tmp_name'],$u['username']);$cover=music_form_cover($u['username']);if($cover===null){$image=music_artwork(SONGS_DIR.'/'.$relative);if($image!==null)$cover=music_save_cover($image,$u['username']);}
    $s=$d->prepare('INSERT INTO z6_song(title,musician,album,idu,filename,lyrics,idmt,coverfilename) VALUES (?,?,?,?,?,?,?,?)');$s->bind_param('sssissis',$title,$musician,$album,$u['id'],$relative,$lyrics,$genre,$cover);$s->execute();$id=(int)$d->insert_id;$s->close();$d->commit();$committed=true;$d->close();$d=null;
    music_flash('success','Dodano utwór „'.$title.'”.');redirect('song.php?id='.$id);
}catch(Throwable $e){if($d){if(!$committed)$d->rollback();$d->close();}if(!$committed&&$relative!==null)@unlink(SONGS_DIR.'/'.$relative);if(!$committed&&$cover!==null)@unlink(SONGS_DIR.'/'.$cover);music_flash('danger',$e instanceof InvalidArgumentException?$e->getMessage():'Nie udało się dodać utworu. Spróbuj ponownie.');redirect('select.php');}
