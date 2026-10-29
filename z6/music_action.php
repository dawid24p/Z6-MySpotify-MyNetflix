<?php
declare(strict_types=1);
require __DIR__.'/common.php';$u=cloud_user();music_post();$d=null;$back='playlists.php';$newCover=null;$committed=false;
try{
    $action=posted('action');$d=db();$d->begin_transaction();
    if($action==='create_playlist'){
        $name=music_text(posted('name'),160,'Nazwa playlisty');$public=posted('public')==='1'?1:0;$newCover=music_form_cover($u['username']);
        $s=$d->prepare('INSERT INTO z6_playlistname(idu,name,public,coverfilename) VALUES (?,?,?,?)');$s->bind_param('isis',$u['id'],$name,$public,$newCover);$s->execute();$id=(int)$d->insert_id;$s->close();$back='playlist.php?id='.$id;$message='Utworzono playlistę.';
    }elseif(in_array($action,['update_playlist','delete_playlist','add_song','remove_song'],true)){
        $id=music_id(posted('playlist'));$playlist=music_playlist($d,$id,(int)$u['id'],true,true);if(!$playlist)throw new InvalidArgumentException('Nie znaleziono Twojej playlisty.');$back='playlist.php?id='.$id;
        if($action==='update_playlist'){
            $name=music_text(posted('name'),160,'Nazwa playlisty');$public=posted('public')==='1'?1:0;$newCover=music_form_cover($u['username']);$cover=$newCover??$playlist['coverfilename'];$s=$d->prepare('UPDATE z6_playlistname SET name=?,public=?,coverfilename=? WHERE idpl=? AND idu=?');$s->bind_param('sisii',$name,$public,$cover,$id,$u['id']);$s->execute();$s->close();$message='Zapisano playlistę.';
        }elseif($action==='delete_playlist'){
            $s=$d->prepare('DELETE FROM z6_playlistname WHERE idpl=? AND idu=?');$s->bind_param('ii',$id,$u['id']);$s->execute();$s->close();$back='playlists.php';$message='Usunięto playlistę. Utwory pozostały w bibliotece.';
        }elseif($action==='add_song'){
            $songId=music_id(posted('song'));if(!($song=music_song($d,$songId,(int)$u['id'])))throw new InvalidArgumentException('Ten utwór nie jest dostępny.');
            $s=$d->prepare('INSERT IGNORE INTO z6_playlistdatabase(idpl,ids) VALUES (?,?)');$s->bind_param('ii',$id,$songId);$s->execute();$added=$s->affected_rows;$s->close();if($playlist['coverfilename']===null&&$song['coverfilename']!==null){$s=$d->prepare('UPDATE z6_playlistname SET coverfilename=? WHERE idpl=?');$s->bind_param('si',$song['coverfilename'],$id);$s->execute();$s->close();}$message=$added?'Dodano utwór do playlisty.':'Ten utwór jest już na playliście.';
        }else{
            $songId=music_id(posted('song'));$s=$d->prepare('DELETE FROM z6_playlistdatabase WHERE idpl=? AND ids=?');$s->bind_param('ii',$id,$songId);$s->execute();$s->close();$message='Usunięto utwór z playlisty.';
        }
    }elseif($action==='delete_song'){
        $id=music_id(posted('song'));$s=$d->prepare('SELECT filename FROM z6_song WHERE ids=? AND idu=? FOR UPDATE');$s->bind_param('ii',$id,$u['id']);$s->execute();$row=$s->get_result()->fetch_assoc();$s->close();if(!$row)throw new InvalidArgumentException('Nie znaleziono Twojego utworu.');
        $path=music_song_path($row['filename']);$s=$d->prepare('DELETE FROM z6_song WHERE ids=? AND idu=?');$s->bind_param('ii',$id,$u['id']);$s->execute();$s->close();$back='music.php';$message='Usunięto utwór.';
    }else throw new InvalidArgumentException('Nieznana operacja.');
    $d->commit();$committed=true;$d->close();$d=null;if(isset($path))@unlink($path);music_flash('success',$message);
}catch(Throwable $e){if($d){if(!$committed)$d->rollback();$d->close();}if(!$committed&&$newCover!==null)@unlink(SONGS_DIR.'/'.$newCover);music_flash('danger',$e instanceof InvalidArgumentException?$e->getMessage():'Operacja nie powiodła się.');}
redirect($back);
