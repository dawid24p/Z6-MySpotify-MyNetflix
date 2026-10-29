<?php
declare(strict_types=1);
const CLOUD_STORAGE='/home/srv126086/z6-work/storage';
function cloud_home_for(string $user): string {
    if(!preg_match('/\A[A-Za-z0-9_.-]{3,20}\z/D',$user))throw new RuntimeException('Nieprawidłowy katalog użytkownika.');
    $home=CLOUD_STORAGE.'/'.$user;
    if(is_link($home))throw new RuntimeException('Nieprawidłowy katalog użytkownika.');
    if(!is_dir($home)&&!mkdir($home,0700))throw new RuntimeException('Nie można utworzyć katalogu użytkownika.');
    $real=realpath($home);
    if($real===false||dirname($real)!==CLOUD_STORAGE)throw new RuntimeException('Nieprawidłowy katalog użytkownika.');
    return $real;
}
function cloud_user(): array {
    require_login();$u=current_user();
    if(!$u)redirect('logout.php');
    $_SESSION['cloud_home']=cloud_home_for($u['username']);
    return $u;
}
function cloud_name(string $name): string {
    if($name===''||$name==='.'||$name==='..'||strlen($name)>255||!mb_check_encoding($name,'UTF-8')||str_contains($name,'/')||str_contains($name,'\\')||preg_match('/[\x00-\x1f\x7f]/u',$name))throw new InvalidArgumentException('Podaj poprawną nazwę bez ukośników i znaków sterujących.');
    return $name;
}
function cloud_relative(string $path,int $depth=2): string {
    if($path==='')return '';
    $parts=explode('/',$path);
    if(count($parts)>$depth)throw new InvalidArgumentException('Nieprawidłowa ścieżka.');
    foreach($parts as $part)cloud_name($part);
    return implode('/',$parts);
}
function cloud_resolve(string $relative,bool $directory=false): string {
    $relative=cloud_relative($relative,$directory?1:2);
    $root=$_SESSION['cloud_home']??throw new RuntimeException('Brak katalogu użytkownika.');
    $candidate=$root;
    foreach($relative===''?[]:explode('/',$relative) as $part){$candidate.='/'.$part;if(is_link($candidate))throw new InvalidArgumentException('Dowiązania nie są obsługiwane.');}
    $real=realpath($candidate);
    if($real===false||($real!==$root&&!str_starts_with($real,$root.'/'))||($directory&&!is_dir($real)))throw new InvalidArgumentException('Nie znaleziono pliku lub katalogu.');
    return $real;
}
function cloud_lock(){
    $f=fopen('/home/srv126086/z6-work/storage-locks/'.hash('sha256',(string)$_SESSION['username']).'.lock','c');
    if($f===false||!flock($f,LOCK_EX))throw new RuntimeException('Nie można zablokować operacji dyskowej.');
    return $f;
}
function cloud_csrf(): string {return $_SESSION['cloud_csrf']??=bin2hex(random_bytes(32));}
function cloud_post(): void {
    if(($_SERVER['REQUEST_METHOD']??'')!=='POST'){http_response_code(405);header('Allow: POST');exit('Wymagane żądanie POST.');}
    if(!hash_equals(cloud_csrf(),posted('csrf'))){http_response_code(403);exit('Formularz wygasł. Odśwież stronę i spróbuj ponownie.');}
}
function cloud_url(string $endpoint,array $params=[]): string {return $endpoint.($params?'?'.http_build_query($params,'','&',PHP_QUERY_RFC3986):'');}
function cloud_size(int $bytes): string {
    $units=['B','KB','MB','GB','TB'];$i=0;$value=(float)$bytes;
    while($value>=1024&&$i<count($units)-1){$value/=1024;$i++;}
    return number_format($value,$i?1:0,',',' ').' '.$units[$i];
}
function cloud_time(string $utc): string {return (new DateTimeImmutable($utc,new DateTimeZone('UTC')))->setTimezone(new DateTimeZone('Europe/Warsaw'))->format('d.m.Y H:i:s');}
function cloud_media(string $path): ?string {
    $ext=strtolower(pathinfo($path,PATHINFO_EXTENSION));
    $types=['jpg'=>'image/jpeg','jpeg'=>'image/jpeg','png'=>'image/png','gif'=>'image/gif','webp'=>'image/webp','avif'=>'image/avif','mp3'=>'audio/mpeg','wav'=>'audio/wav','ogg'=>'audio/ogg','m4a'=>'audio/mp4','mp4'=>'video/mp4','webm'=>'video/webm'];
    if(!isset($types[$ext]))return null;
    $mime=(new finfo(FILEINFO_MIME_TYPE))->file($path);
    
    if(str_starts_with($types[$ext],'image/'))return @getimagesize($path)!==false?$types[$ext]:null;
    if(str_starts_with((string)$mime,'audio/')||str_starts_with((string)$mime,'video/')||in_array($mime,['application/ogg','application/octet-stream'],true))return $types[$ext];
    return null;
}
function cloud_log_attempt(mysqli $d,string $user,string $event): int {
    $user=mb_substr($user,0,128,'UTF-8');$ip=client_ip();$page=mb_substr((string)($_SERVER['SCRIPT_NAME']??''),0,200,'UTF-8');$ua=mb_substr(mb_scrub((string)($_SERVER['HTTP_USER_AGENT']??''),'UTF-8'),0,1000,'UTF-8');
    $s=$d->prepare('INSERT INTO z6_goscieportalu(ipaddress,datetime,event_type,page,username,user_agent) VALUES (?,UTC_TIMESTAMP(),?,?,?,?)');$s->bind_param('sssss',$ip,$event,$page,$user,$ua);$s->execute();$id=(int)$d->insert_id;$s->close();return $id;
}
function cloud_guarded_login(int $form,string $user,callable $verify): array {
    $d=db();$key=hash('sha256',mb_strtolower(trim($user),'UTF-8'));$form+=40;$now=time();
    try{
        $d->begin_transaction();
        $s=$d->prepare('INSERT IGNORE INTO z6_login_attempts(form_id,login_key,locked_until,updated_at,failures) VALUES (?,?,0,?,0)');$s->bind_param('isi',$form,$key,$now);$s->execute();$s->close();
        $s=$d->prepare('SELECT locked_until,failures FROM z6_login_attempts WHERE form_id=? AND login_key=? FOR UPDATE');$s->bind_param('is',$form,$key);$s->execute();$state=$s->get_result()->fetch_assoc();$s->close();
        if((int)$state['locked_until']>$now){$visitId=cloud_log_attempt($d,$user,'login_blocked');$d->commit();$d->close();return ['ok'=>false,'visit_id'=>$visitId,'blocked'=>true,'message'=>'Konto jest zablokowane. Spróbuj ponownie za '.((int)$state['locked_until']-$now).' s.'];}
        if(geo_policy_enabled()&&!country_allowed((string)(ip_details(client_ip())['country']??''),true))$result=['ok'=>false,'message'=>'Logowanie jest dozwolone tylko z Polski.'];
        else $result=$verify($d);
        $failures=$result['ok']?0:((int)$state['locked_until']>0?1:(int)$state['failures']+1);
        $until=(!$result['ok']&&$failures>=3)?$now+60:0;
        if($result['ok']){
            $username=(string)($result['username']??$user);
            $s=$d->prepare("SELECT b.datetime,b.ipaddress FROM z6_break_ins b WHERE b.username=? AND b.datetime>=COALESCE((SELECT MAX(g.datetime) FROM z6_goscieportalu g WHERE g.username=? AND g.event_type='login'),'1970-01-01') ORDER BY b.id DESC LIMIT 1");$s->bind_param('ss',$username,$username);$s->execute();$result['warning']=$s->get_result()->fetch_assoc();$s->close();
        }
        $result['visit_id']=cloud_log_attempt($d,$result['ok']?(string)($result['username']??$user):$user,$result['ok']?'login':'login_failed');
        if($until){$ip=client_ip();$name=mb_substr($user,0,128,'UTF-8');$s=$d->prepare('INSERT INTO z6_break_ins(username,ipaddress,datetime) VALUES (?,?,UTC_TIMESTAMP())');$s->bind_param('ss',$name,$ip);$s->execute();$s->close();$result['message'].=' Trzy błędne próby — konto zablokowane na 60 s.';}
        elseif(!$result['ok'])$result['message'].=' Pozostało prób: '.(3-$failures).'.';
        $s=$d->prepare('UPDATE z6_login_attempts SET failures=?,locked_until=?,updated_at=? WHERE form_id=? AND login_key=?');$s->bind_param('iiiis',$failures,$until,$now,$form,$key);$s->execute();$s->close();$d->commit();$d->close();return $result;
    }catch(Throwable $e){$d->rollback();$d->close();throw $e;}
}
