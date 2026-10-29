<?php
declare(strict_types=1);
const SONGS_DIR=__DIR__.'/songs';
function music_id(mixed $value): int {
    if(!is_scalar($value)||!preg_match('/\A[1-9][0-9]{0,9}\z/D',(string)$value))throw new InvalidArgumentException('Nieprawidłowy identyfikator.');
    return (int)$value;
}
function music_text(string $value,int $max,string $label): string {
    $value=trim($value);
    if($value===''||!mb_check_encoding($value,'UTF-8')||mb_strlen($value,'UTF-8')>$max)throw new InvalidArgumentException($label.': podaj od 1 do '.$max.' znaków.');
    return $value;
}
function music_csrf(): string {return $_SESSION['music_csrf']??=bin2hex(random_bytes(32));}
function music_post(): void {
    if(($_SERVER['REQUEST_METHOD']??'')!=='POST'){http_response_code(405);header('Allow: POST');exit('Wymagane żądanie POST.');}
    if(!hash_equals(music_csrf(),posted('csrf'))){http_response_code(403);exit('Formularz wygasł. Odśwież stronę.');}
}
function music_flash(string $type,string $text):void {$_SESSION['music_flash']=['type'=>$type,'message'=>$text];}
function music_notice():void {
    if(!isset($_SESSION['music_flash']))return;$f=$_SESSION['music_flash'];unset($_SESSION['music_flash']);echo '<div class="alert alert-'.h($f['type']).'" role="status">'.h($f['message']).'</div>';
}
function music_toolbar(string $active):void {
    echo '<nav class="music-tabs d-flex flex-wrap gap-2 mb-4" aria-label="mySpotify">';
    foreach(['music.php'=>'Utwory','select.php'=>'Dodaj utwór','playlists.php'=>'Moje playlisty','playlists.php?public=1'=>'Publiczne playlisty'] as $href=>$label)echo '<a class="btn '.($active===$href?'btn-primary':'btn-outline-light').'" href="'.h($href).'">'.$label.'</a>';
    echo '</nav>';music_notice();
}
function music_access_sql(string $alias='s'):string {
    return "($alias.idu=? OR EXISTS(SELECT 1 FROM z6_playlistdatabase a JOIN z6_playlistname p ON p.idpl=a.idpl WHERE a.ids=$alias.ids AND (p.public=1 OR p.idu=?)))";
}
function music_song(mysqli $d,int $id,int $viewer):?array {
    $s=$d->prepare('SELECT s.*,m.name AS genre,u.username FROM z6_song s JOIN z6_musictype m ON m.idmt=s.idmt JOIN z6_users u ON u.id=s.idu WHERE s.ids=? AND '.music_access_sql());$s->bind_param('iii',$id,$viewer,$viewer);$s->execute();$row=$s->get_result()->fetch_assoc();$s->close();return $row;
}
function music_playlist(mysqli $d,int $id,int $viewer,bool $owner=false,bool $lock=false):?array {
    $s=$d->prepare('SELECT p.*,u.username FROM z6_playlistname p JOIN z6_users u ON u.id=p.idu WHERE p.idpl=? AND '.($owner?'p.idu=?':'(p.idu=? OR p.public=1)').($lock?' FOR UPDATE':''));$s->bind_param('ii',$id,$viewer);$s->execute();$row=$s->get_result()->fetch_assoc();$s->close();return $row;
}
function music_own_playlists(mysqli $d,int $viewer):array {
    $s=$d->prepare('SELECT idpl,name FROM z6_playlistname WHERE idu=? ORDER BY datetime DESC,idpl DESC');$s->bind_param('i',$viewer);$s->execute();$rows=$s->get_result()->fetch_all(MYSQLI_ASSOC);$s->close();return $rows;
}
function music_add_form(array $song,array $playlists,?int $current=null):void {
    if(!$playlists){echo '<a class="btn btn-outline-light btn-sm" href="playlists.php">Utwórz playlistę</a>';return;}
    echo '<form method="post" action="music_action.php" class="music-add-form"><input type="hidden" name="csrf" value="'.h(music_csrf()).'"><input type="hidden" name="action" value="add_song"><input type="hidden" name="song" value="'.(int)$song['ids'].'">';
    if($current!==null)echo '<input type="hidden" name="source_playlist" value="'.$current.'">';
    echo '<label class="visually-hidden" for="playlist-for-'.(int)$song['ids'].'">Playlista dla '.h($song['title']).'</label><select class="form-select form-select-sm" id="playlist-for-'.(int)$song['ids'].'" name="playlist" required><option value="">Wybierz playlistę</option>';
    foreach($playlists as $p)echo '<option value="'.(int)$p['idpl'].'">'.h($p['name']).'</option>';
    echo '</select><button class="btn btn-outline-primary btn-sm" type="submit">Dodaj do playlisty</button></form>';
}
function music_song_path(string $relative):string {
    if(!preg_match('/\A[A-Za-z0-9_.-]{3,20}\/[a-f0-9]{32}\.mp3\z/D',$relative))throw new RuntimeException('Nieprawidłowy plik audio.');
    $dir=dirname($relative);if(is_link(SONGS_DIR.'/'.$dir)||is_link(SONGS_DIR.'/'.$relative))throw new RuntimeException('Nieprawidłowy plik audio.');
    $path=realpath(SONGS_DIR.'/'.$relative);if($path===false||!str_starts_with($path,realpath(SONGS_DIR).'/')||!is_file($path))throw new RuntimeException('Nie znaleziono pliku audio.');return $path;
}
function music_store(string $tmp,string $user,bool $uploaded=true):string {
    if(!preg_match('/\A[A-Za-z0-9_.-]{3,20}\z/D',$user))throw new InvalidArgumentException('Nieprawidłowy użytkownik.');
    $dir=SONGS_DIR.'/'.$user;if(is_link($dir))throw new RuntimeException('Nieprawidłowy katalog.');if(!is_dir($dir)&&!mkdir($dir,0700))throw new RuntimeException('Nie można utworzyć katalogu.');
    $relative=$user.'/'.bin2hex(random_bytes(16)).'.mp3';$path=SONGS_DIR.'/'.$relative;
    if(!($uploaded?move_uploaded_file($tmp,$path):copy($tmp,$path)))throw new RuntimeException('Nie udało się zapisać pliku audio.');chmod($path,0600);return $relative;
}
function music_mp3(string $tmp,string $name):void {
    if(strtolower(pathinfo($name,PATHINFO_EXTENSION))!=='mp3'||filesize($tmp)===0)throw new InvalidArgumentException('Wybierz niepusty plik MP3.');
    $type=(new finfo(FILEINFO_MIME_TYPE))->file($tmp);
    if(!in_array($type,['audio/mpeg','audio/mp3','audio/x-mp3'],true))throw new InvalidArgumentException('Plik nie jest poprawnym nagraniem MP3.');
}
function music_id3_text(string $value):string {
    if($value==='')return '';$encoding=ord($value[0]);$text=substr($value,1);$enc=[0=>'ISO-8859-1',1=>'UTF-16',2=>'UTF-16BE',3=>'UTF-8'][$encoding]??'UTF-8';
    return trim(str_replace("\0",'',mb_convert_encoding($text,'UTF-8',$enc)));
}
function music_tags(string $path):array {
    $out=['title'=>'','musician'=>'','genre'=>'','track'=>'','album'=>'','lyrics'=>''];$f=fopen($path,'rb');if(!$f)return $out;$header=fread($f,10);
    if(strlen($header)===10&&substr($header,0,3)==='ID3'&&in_array(ord($header[3]),[3,4],true)){
        $version=ord($header[3]);$size=0;for($i=6;$i<10;$i++)$size=($size<<7)|(ord($header[$i])&127);$data=fread($f,min($size,8*1024*1024));
        $offset=0;if((ord($header[5])&0x40)!==0&&strlen($data)>=4){$extra=unpack('N',substr($data,0,4))[1];if($version===4){$extra=0;for($j=0;$j<4;$j++)$extra=($extra<<7)|(ord($data[$j])&127);$offset=$extra;}else $offset=$extra+4;}
        while($offset+10<=strlen($data)){
            $frame=substr($data,$offset,4);if(!preg_match('/\A[A-Z0-9]{4}\z/D',$frame))break;$bytes=substr($data,$offset+4,4);$len=$version===4?0:unpack('N',$bytes)[1];if($version===4)for($i=0;$i<4;$i++)$len=($len<<7)|(ord($bytes[$i])&127);
            $offset+=10;if($len<=0||$offset+$len>strlen($data))break;$value=substr($data,$offset,$len);$offset+=$len;
            $key=['TIT2'=>'title','TPE1'=>'musician','TCON'=>'genre','TRCK'=>'track','TALB'=>'album'][$frame]??null;if($key)$out[$key]=music_id3_text($value);
        }
    }
    if(fseek($f,-128,SEEK_END)===0){$tag=fread($f,128);if(substr($tag,0,3)==='TAG'){
        if($out['title']==='')$out['title']=trim(mb_convert_encoding(rtrim(substr($tag,3,30),"\0 "),'UTF-8','Windows-1252'));
        if($out['musician']==='')$out['musician']=trim(mb_convert_encoding(rtrim(substr($tag,33,30),"\0 "),'UTF-8','Windows-1252'));
        if($out['album']==='')$out['album']=trim(mb_convert_encoding(rtrim(substr($tag,63,30),"\0 "),'UTF-8','Windows-1252'));
        if($out['track']===''&&ord($tag[125])===0&&ord($tag[126])>0)$out['track']=(string)ord($tag[126]);
    }}fclose($f);return $out;
}
function music_artwork(string $path):?string {
    $f=fopen($path,'rb');if(!$f)return null;$header=fread($f,10);
    if(strlen($header)!==10||substr($header,0,3)!=='ID3'||!in_array(ord($header[3]),[3,4],true)){fclose($f);return null;}
    $version=ord($header[3]);$size=0;for($i=6;$i<10;$i++)$size=($size<<7)|(ord($header[$i])&127);$data=fread($f,min($size,8*1024*1024));fclose($f);$offset=0;
    if((ord($header[5])&0x40)!==0&&strlen($data)>=4){$extra=$version===3?unpack('N',substr($data,0,4))[1]:0;if($version===4)for($i=0;$i<4;$i++)$extra=($extra<<7)|(ord($data[$i])&127);$offset=$extra+($version===3?4:0);}
    while($offset+10<=strlen($data)){
        $frame=substr($data,$offset,4);if(!preg_match('/\A[A-Z0-9]{4}\z/D',$frame))break;$len=$version===3?unpack('N',substr($data,$offset+4,4))[1]:0;if($version===4)for($i=$offset+4;$i<$offset+8;$i++)$len=($len<<7)|(ord($data[$i])&127);$offset+=10;if($len<=0||$offset+$len>strlen($data))break;$value=substr($data,$offset,$len);$offset+=$len;
        if($frame!=='APIC'||strlen($value)<5)continue;$encoding=ord($value[0]);$mimeEnd=strpos($value,"\0",1);if($mimeEnd===false)continue;$start=$mimeEnd+2;
        if(in_array($encoding,[1,2],true)){while($start+1<strlen($value)&&substr($value,$start,2)!=="\0\0")$start+=2;$start+=2;}else{$end=strpos($value,"\0",$start);if($end===false)continue;$start=$end+1;}
        $image=substr($value,$start);if(@getimagesizefromstring($image)!==false)return $image;
    }
    return null;
}
function music_save_cover(string $bytes,string $user):string {
    $size=@getimagesizefromstring($bytes);if(!$size||$size[0]>6000||$size[1]>6000||$size[0]*$size[1]>16000000)throw new InvalidArgumentException('Okładka może mieć maksymalnie 16 milionów pikseli i bok do 6000 px.');
    $source=@imagecreatefromstring($bytes);if(!$source)throw new InvalidArgumentException('Nieprawidłowy obraz okładki.');
    $dest=imagecreatetruecolor(600,600);$background=imagecolorallocate($dest,0,0,0);imagefill($dest,0,0,$background);$scale=min(600/$size[0],600/$size[1]);$width=max(1,(int)round($size[0]*$scale));$height=max(1,(int)round($size[1]*$scale));imagecopyresampled($dest,$source,(int)((600-$width)/2),(int)((600-$height)/2),0,0,$width,$height,$size[0],$size[1]);imagedestroy($source);
    if(!preg_match('/\A[A-Za-z0-9_.-]{3,20}\z/D',$user)){imagedestroy($dest);throw new InvalidArgumentException('Nieprawidłowy użytkownik.');}$dir=SONGS_DIR.'/'.$user;if(is_link($dir))throw new RuntimeException('Nieprawidłowy katalog.');if(!is_dir($dir)&&!mkdir($dir,0700))throw new RuntimeException('Nie można utworzyć katalogu.');
    $relative=$user.'/'.bin2hex(random_bytes(16)).'.jpg';$ok=imagejpeg($dest,SONGS_DIR.'/'.$relative,88);imagedestroy($dest);if(!$ok)throw new RuntimeException('Nie udało się zapisać okładki.');chmod(SONGS_DIR.'/'.$relative,0600);return $relative;
}
function music_form_cover(string $user):?string {
    $file=$_FILES['cover']??null;if($file===null||(is_array($file)&&($file['error']??null)===UPLOAD_ERR_NO_FILE))return null;
    if(!is_array($file)||($file['error']??null)!==UPLOAD_ERR_OK||!is_string($file['tmp_name']??null)||!is_uploaded_file($file['tmp_name'])||filesize($file['tmp_name'])>8*1024*1024)throw new InvalidArgumentException('Wybierz obraz okładki do 8 MB.');return music_save_cover(file_get_contents($file['tmp_name']),$user);
}
function music_cover_html(?int $song,?int $playlist,?string $filename,string $alt,bool $large=false):string {
    $class='music-cover'.($large?' music-cover-large':'');
    if(!$filename)return '<span class="'.$class.' music-cover-empty" aria-hidden="true">♫</span>';
    return '<img class="'.$class.'" src="artwork.php?'.($song!==null?'song='.$song:'playlist='.$playlist).'" alt="'.h($alt).'" loading="lazy">';
}
function music_play_button(array $song):string {
    $item=['id'=>(int)$song['ids'],'title'=>$song['title'],'musician'=>$song['musician'],'url'=>'song_file.php?id='.(int)$song['ids'],'cover'=>!empty($song['coverfilename'])?'artwork.php?song='.(int)$song['ids']:null];
    return '<button class="btn btn-outline-primary music-play-button" type="button" data-audio-track="'.h(json_encode($item,JSON_UNESCAPED_UNICODE|JSON_THROW_ON_ERROR)).'">▶ Odtwórz</button>';
}
