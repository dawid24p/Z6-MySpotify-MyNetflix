<?php
declare(strict_types=1);
const FILMS_DIR=__DIR__.'/films';
function video_id(mixed $value): int {
    if(!is_scalar($value)||!preg_match('/\A[1-9][0-9]{0,9}\z/D',(string)$value))throw new InvalidArgumentException('Nieprawidłowy identyfikator.');
    return (int)$value;
}
function video_text(string $value,int $max,string $label): string {
    $value=trim($value);
    if($value===''||!mb_check_encoding($value,'UTF-8')||mb_strlen($value,'UTF-8')>$max)throw new InvalidArgumentException($label.': podaj od 1 do '.$max.' znaków.');
    return $value;
}
function video_csrf(): string {return $_SESSION['video_csrf']??=bin2hex(random_bytes(32));}
function video_post(): void {
    if(($_SERVER['REQUEST_METHOD']??'')!=='POST'){http_response_code(405);header('Allow: POST');exit('Wymagane żądanie POST.');}
    if(!hash_equals(video_csrf(),posted('csrf'))){http_response_code(403);exit('Formularz wygasł. Odśwież stronę.');}
}
function video_flash(string $type,string $text):void {$_SESSION['video_flash']=['type'=>$type,'message'=>$text];}
function video_notice():void {
    if(!isset($_SESSION['video_flash']))return;$f=$_SESSION['video_flash'];unset($_SESSION['video_flash']);echo '<div class="alert alert-'.h($f['type']).'" role="status">'.h($f['message']).'</div>';
}
function video_toolbar(string $active):void {
    echo '<nav class="video-tabs d-flex flex-wrap gap-2 mb-4" aria-label="myNetflix">';
    foreach(['films.php'=>'Filmy','film_select.php'=>'Dodaj film','video_playlists.php'=>'Moje playlisty','video_playlists.php?public=1'=>'Publiczne playlisty'] as $href=>$label)echo '<a class="btn '.($active===$href?'btn-primary':'btn-outline-light').'" href="'.h($href).'">'.$label.'</a>';
    echo '</nav>';video_notice();
}
function video_access_sql(string $alias='s'):string {
    return "($alias.idu=? OR EXISTS(SELECT 1 FROM z6v_playlistdatabase a JOIN z6v_playlistname p ON p.idpl=a.idpl WHERE a.idf=$alias.idf AND (p.public=1 OR p.idu=?)))";
}
function video_film(mysqli $d,int $id,int $viewer):?array {
    $s=$d->prepare('SELECT s.*,m.name AS genre,u.username FROM z6v_film s JOIN z6v_filmtype m ON m.idft=s.idft JOIN z6_users u ON u.id=s.idu WHERE s.idf=? AND '.video_access_sql());$s->bind_param('iii',$id,$viewer,$viewer);$s->execute();$row=$s->get_result()->fetch_assoc();$s->close();return $row;
}
function video_playlist(mysqli $d,int $id,int $viewer,bool $owner=false,bool $lock=false):?array {
    $s=$d->prepare('SELECT p.*,u.username FROM z6v_playlistname p JOIN z6_users u ON u.id=p.idu WHERE p.idpl=? AND '.($owner?'p.idu=?':'(p.idu=? OR p.public=1)').($lock?' FOR UPDATE':''));$s->bind_param('ii',$id,$viewer);$s->execute();$row=$s->get_result()->fetch_assoc();$s->close();return $row;
}
function video_own_playlists(mysqli $d,int $viewer):array {
    $s=$d->prepare('SELECT idpl,name FROM z6v_playlistname WHERE idu=? ORDER BY datetime DESC,idpl DESC');$s->bind_param('i',$viewer);$s->execute();$rows=$s->get_result()->fetch_all(MYSQLI_ASSOC);$s->close();return $rows;
}
function video_add_form(array $film,array $playlists,?int $current=null):void {
    if(!$playlists){echo '<a class="btn btn-outline-light btn-sm" href="video_playlists.php">Utwórz playlistę</a>';return;}
    echo '<form method="post" action="video_action.php" class="video-add-form"><input type="hidden" name="csrf" value="'.h(video_csrf()).'"><input type="hidden" name="action" value="add_film"><input type="hidden" name="film" value="'.(int)$film['idf'].'">';
    if($current!==null)echo '<input type="hidden" name="source_playlist" value="'.$current.'">';
    echo '<label class="visually-hidden" for="playlist-for-'.(int)$film['idf'].'">Playlista dla '.h($film['title']).'</label><select class="form-select form-select-sm" id="playlist-for-'.(int)$film['idf'].'" name="playlist" required><option value="">Wybierz playlistę</option>';
    foreach($playlists as $p)echo '<option value="'.(int)$p['idpl'].'">'.h($p['name']).'</option>';
    echo '</select><button class="btn btn-outline-primary btn-sm" type="submit">Dodaj do playlisty</button></form>';
}
function video_film_path(string $relative):string {
    if(!preg_match('/\A[A-Za-z0-9_.-]{3,20}\/[a-f0-9]{32}\.mp4\z/D',$relative))throw new RuntimeException('Nieprawidłowy plik wideo.');
    $dir=dirname($relative);if(is_link(FILMS_DIR.'/'.$dir)||is_link(FILMS_DIR.'/'.$relative))throw new RuntimeException('Nieprawidłowy plik wideo.');
    $path=realpath(FILMS_DIR.'/'.$relative);if($path===false||!str_starts_with($path,realpath(FILMS_DIR).'/')||!is_file($path))throw new RuntimeException('Nie znaleziono pliku wideo.');return $path;
}
function video_store(string $tmp,string $user,bool $uploaded=true):string {
    if(!preg_match('/\A[A-Za-z0-9_.-]{3,20}\z/D',$user))throw new InvalidArgumentException('Nieprawidłowy użytkownik.');
    $dir=FILMS_DIR.'/'.$user;if(is_link($dir))throw new RuntimeException('Nieprawidłowy katalog.');if(!is_dir($dir)&&!mkdir($dir,0700))throw new RuntimeException('Nie można utworzyć katalogu.');
    $relative=$user.'/'.bin2hex(random_bytes(16)).'.mp4';$path=FILMS_DIR.'/'.$relative;
    if(!($uploaded?move_uploaded_file($tmp,$path):copy($tmp,$path)))throw new RuntimeException('Nie udało się zapisać pliku wideo.');chmod($path,0600);return $relative;
}
function video_mp4(string $tmp,string $name):void {
    if(strtolower(pathinfo($name,PATHINFO_EXTENSION))!=='mp4'||filesize($tmp)===0)throw new InvalidArgumentException('Wybierz niepusty plik MP4.');
    $type=(new finfo(FILEINFO_MIME_TYPE))->file($tmp);
    if(!in_array($type,['video/mp4','application/mp4'],true))throw new InvalidArgumentException('Plik nie jest poprawnym filmem MP4.');
}
function video_save_cover(string $bytes,string $user):string {
    $size=@getimagesizefromstring($bytes);if(!$size||$size[0]>6000||$size[1]>6000||$size[0]*$size[1]>16000000)throw new InvalidArgumentException('Okładka może mieć maksymalnie 16 milionów pikseli i bok do 6000 px.');
    $source=@imagecreatefromstring($bytes);if(!$source)throw new InvalidArgumentException('Nieprawidłowy obraz okładki.');
    $scale=min(1,1200/$size[0],1200/$size[1]);$width=max(1,(int)round($size[0]*$scale));$height=max(1,(int)round($size[1]*$scale));$dest=imagecreatetruecolor($width,$height);$background=imagecolorallocate($dest,0,0,0);imagefill($dest,0,0,$background);imagecopyresampled($dest,$source,0,0,0,0,$width,$height,$size[0],$size[1]);imagedestroy($source);
    if(!preg_match('/\A[A-Za-z0-9_.-]{3,20}\z/D',$user)){imagedestroy($dest);throw new InvalidArgumentException('Nieprawidłowy użytkownik.');}$dir=FILMS_DIR.'/'.$user;if(is_link($dir))throw new RuntimeException('Nieprawidłowy katalog.');if(!is_dir($dir)&&!mkdir($dir,0700))throw new RuntimeException('Nie można utworzyć katalogu.');
    $relative=$user.'/'.bin2hex(random_bytes(16)).'.jpg';$ok=imagejpeg($dest,FILMS_DIR.'/'.$relative,88);imagedestroy($dest);if(!$ok)throw new RuntimeException('Nie udało się zapisać okładki.');chmod(FILMS_DIR.'/'.$relative,0600);return $relative;
}
function video_form_cover(string $user):?string {
    $file=$_FILES['cover']??null;if($file===null||(is_array($file)&&($file['error']??null)===UPLOAD_ERR_NO_FILE))return null;
    if(!is_array($file)||($file['error']??null)!==UPLOAD_ERR_OK||!is_string($file['tmp_name']??null)||!is_uploaded_file($file['tmp_name'])||filesize($file['tmp_name'])>8*1024*1024)throw new InvalidArgumentException('Wybierz obraz okładki do 8 MB.');return video_save_cover(file_get_contents($file['tmp_name']),$user);
}
function video_cover_html(?int $film,?int $playlist,?string $filename,string $alt,bool $large=false):string {
    $class='video-cover'.($large?' video-cover-large':'');
    if(!$filename)return '<span class="'.$class.' video-cover-empty" aria-hidden="true">🎬</span>';
    return '<img class="'.$class.'" src="film_artwork.php?'.($film!==null?'film='.$film:'playlist='.$playlist).'" alt="'.h($alt).'" loading="lazy">';
}

function video_duration(string $path):?int {
    $file=fopen($path,'rb');if(!$file)return null;
    $scan=function(int $end,int $depth=0)use($file,&$scan):?int{
        if($depth>2)return null;
        while(ftell($file)+8<=$end){$start=ftell($file);$header=fread($file,8);if(strlen($header)!==8)break;$size=unpack('N',substr($header,0,4))[1];$type=substr($header,4);$headerSize=8;
            if($size===1){$extra=fread($file,8);if(strlen($extra)!==8)break;$parts=unpack('Nhi/Nlo',$extra);$size=$parts['hi']*4294967296+$parts['lo'];$headerSize=16;}elseif($size===0)$size=$end-$start;
            if($size<$headerSize||$start+$size>$end)break;
            if($type==='moov'){$result=$scan($start+$size,$depth+1);if($result!==null)return $result;}
            elseif($type==='mvhd'){$data=fread($file,min(32,$size-$headerSize));$version=ord($data[0]??"\0");if($version===0&&strlen($data)>=20){$scale=unpack('N',substr($data,12,4))[1];$ticks=unpack('N',substr($data,16,4))[1];}elseif($version===1&&strlen($data)>=32){$scale=unpack('N',substr($data,20,4))[1];$parts=unpack('Nhi/Nlo',substr($data,24,8));$ticks=$parts['hi']*4294967296+$parts['lo'];}else return null;return $scale>0?(int)round($ticks/$scale):null;}
            fseek($file,$start+$size);
        }return null;
    };
    try{return $scan((int)fstat($file)['size']);}finally{fclose($file);}
}
function video_duration_label(?int $seconds):string {
    if($seconds===null)return '—';return $seconds>=3600?sprintf('%d:%02d:%02d',intdiv($seconds,3600),intdiv($seconds%3600,60),$seconds%60):sprintf('%d:%02d',intdiv($seconds,60),$seconds%60);
}

function video_membership_form(array $film,array $playlists,array $members):void {
    if(!$playlists){echo '<a class="btn btn-outline-light btn-sm" href="video_playlists.php">Utwórz playlistę</a>';return;}
    $present=in_array((int)$playlists[0]['idpl'],array_map('intval',$members),true);
    echo '<form method="post" action="video_action.php" class="video-add-form video-membership"><input type="hidden" name="csrf" value="'.h(video_csrf()).'"><input type="hidden" name="action" value="'.($present?'remove_film':'add_film').'"><input type="hidden" name="film" value="'.(int)$film['idf'].'"><input type="hidden" name="return_film" value="'.(int)$film['idf'].'"><label class="visually-hidden" for="film-membership">Playlista</label><select class="form-select form-select-sm" id="film-membership" name="playlist" required>';
    foreach($playlists as $p)echo '<option value="'.(int)$p['idpl'].'" data-present="'.(in_array((int)$p['idpl'],array_map('intval',$members),true)?'1':'0').'">'.h($p['name']).'</option>';
    echo '</select><button class="btn btn-outline-primary btn-sm" type="submit">'.($present?'Usuń z playlisty':'Dodaj do playlisty').'</button></form>';
}
