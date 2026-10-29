<?php
declare(strict_types=1);
require __DIR__.'/common.php';$u=cloud_user();video_post();$d=null;$back='video_playlists.php';$newCover=null;$committed=false;
try{
    $action=posted('action');$d=db();$d->begin_transaction();
    if($action==='create_playlist'){
        $name=video_text(posted('name'),160,'Nazwa playlisty');$public=posted('public')==='1'?1:0;$newCover=video_form_cover($u['username']);
        $s=$d->prepare('INSERT INTO z6v_playlistname(idu,name,public,coverfilename) VALUES (?,?,?,?)');$s->bind_param('isis',$u['id'],$name,$public,$newCover);$s->execute();$id=(int)$d->insert_id;$s->close();$back='video_playlist.php?id='.$id;$message='Utworzono playlistę.';
    }elseif(in_array($action,['update_playlist','delete_playlist','add_film','remove_film'],true)){
        $id=video_id(posted('playlist'));$playlist=video_playlist($d,$id,(int)$u['id'],true,true);if(!$playlist)throw new InvalidArgumentException('Nie znaleziono Twojej playlisty.');$back='video_playlist.php?id='.$id;
        if($action==='update_playlist'){
            $name=video_text(posted('name'),160,'Nazwa playlisty');$public=posted('public')==='1'?1:0;$newCover=video_form_cover($u['username']);$cover=$newCover??$playlist['coverfilename'];$s=$d->prepare('UPDATE z6v_playlistname SET name=?,public=?,coverfilename=? WHERE idpl=? AND idu=?');$s->bind_param('sisii',$name,$public,$cover,$id,$u['id']);$s->execute();$s->close();$message='Zapisano playlistę.';
        }elseif($action==='delete_playlist'){
            $s=$d->prepare('DELETE FROM z6v_playlistname WHERE idpl=? AND idu=?');$s->bind_param('ii',$id,$u['id']);$s->execute();$s->close();$back='video_playlists.php';$message='Usunięto playlistę. Filmy pozostały w bibliotece.';
        }elseif($action==='add_film'){
            $songId=video_id(posted('film'));if(!($film=video_film($d,$songId,(int)$u['id'])))throw new InvalidArgumentException('Ten film nie jest dostępny.');
            $s=$d->prepare('INSERT IGNORE INTO z6v_playlistdatabase(idpl,idf) VALUES (?,?)');$s->bind_param('ii',$id,$songId);$s->execute();$added=$s->affected_rows;$s->close();if($playlist['coverfilename']===null&&$film['coverfilename']!==null){$s=$d->prepare('UPDATE z6v_playlistname SET coverfilename=? WHERE idpl=?');$s->bind_param('si',$film['coverfilename'],$id);$s->execute();$s->close();}$message=$added?'Dodano film do playlisty.':'Ten film jest już na playliście.';
        }else{
            $songId=video_id(posted('film'));$s=$d->prepare('DELETE FROM z6v_playlistdatabase WHERE idpl=? AND idf=?');$s->bind_param('ii',$id,$songId);$s->execute();$s->close();$message='Usunięto film z playlisty.';
        }
    }elseif($action==='delete_film'){
        $id=video_id(posted('film'));$s=$d->prepare('SELECT filename FROM z6v_film WHERE idf=? AND idu=? FOR UPDATE');$s->bind_param('ii',$id,$u['id']);$s->execute();$row=$s->get_result()->fetch_assoc();$s->close();if(!$row)throw new InvalidArgumentException('Nie znaleziono Twojego filmu.');
        $path=video_film_path($row['filename']);$s=$d->prepare('DELETE FROM z6v_film WHERE idf=? AND idu=?');$s->bind_param('ii',$id,$u['id']);$s->execute();$s->close();$back='films.php';$message='Usunięto film.';
    }else throw new InvalidArgumentException('Nieznana operacja.');
    if(in_array($action,['add_film','remove_film'],true)&&posted('return_film')===(string)$songId)$back='film.php?id='.$songId;
    $d->commit();$committed=true;$d->close();$d=null;if(isset($path))@unlink($path);video_flash('success',$message);
}catch(Throwable $e){if($d){if(!$committed)$d->rollback();$d->close();}if(!$committed&&$newCover!==null)@unlink(FILMS_DIR.'/'.$newCover);video_flash('danger',$e instanceof InvalidArgumentException?$e->getMessage():'Operacja nie powiodła się.');}
redirect($back);
