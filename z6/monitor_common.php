<?php declare(strict_types=1);
function monitor_user():array {require_login();$u=current_user();if(!$u)redirect('logout.php');$_SESSION['user_id']=(int)$u['id'];return $u;}
function monitor_admin(array $u):bool{return $u['username']==='admin';}
function monitor_csrf():string {start_session();return $_SESSION['monitor_csrf']??=bin2hex(random_bytes(32));}
function monitor_post():void {if(($_SERVER['REQUEST_METHOD']??'')!=='POST'||!hash_equals(monitor_csrf(),posted('csrf'))){http_response_code(403);exit('Nieprawidłowy token formularza.');}}
function monitor_rows(mysqli $d,array $u):array {if(monitor_admin($u))return $d->query('SELECT d.*,u.username FROM z6_domeny d JOIN z6_users u ON u.id=d.user_id ORDER BY d.id')->fetch_all(MYSQLI_ASSOC);$s=$d->prepare('SELECT d.*,u.username FROM z6_domeny d JOIN z6_users u ON u.id=d.user_id WHERE d.user_id=? ORDER BY d.id');$s->bind_param('i',$u['id']);$s->execute();return $s->get_result()->fetch_all(MYSQLI_ASSOC);}
function monitor_target(string $host,int $port):array {
 $host=strtolower(trim($host));if($port<1||$port>65535||strlen($host)>190)throw new InvalidArgumentException('Podaj poprawny host i port 1–65535.');
 if(!filter_var($host,FILTER_VALIDATE_IP)&&!preg_match('/\A(?=.{1,190}\z)(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.)+[a-z0-9-]{2,63}\z/D',$host))throw new InvalidArgumentException('Wpisz domenę lub IP bez protokołu i ścieżki.');
 if(preg_match('/\.(gov|mil)(\.|$)|\.(gov|mil)\.pl$/',$host))throw new InvalidArgumentException('Nie monitorujemy domen rządowych ani wojskowych.');
 return [$host,$port];
}
function monitor_probe(string $host,int $port):array {
 if(str_ends_with($host,'.invalid'))return [false,'Nieistniejąca domena testowa.'];
 $ips=filter_var($host,FILTER_VALIDATE_IP)?[$host]:gethostbynamel($host);if(!$ips)return [false,'Nie można rozwiązać nazwy DNS.'];
 foreach($ips as $ip)if(!filter_var($ip,FILTER_VALIDATE_IP,FILTER_FLAG_NO_PRIV_RANGE|FILTER_FLAG_NO_RES_RANGE))return [false,'Adres lokalny lub zarezerwowany — test zablokowany.'];
 $ip=$ips[0];$target=str_contains($ip,':')?'['.$ip.']':$ip;$fp=@fsockopen($target,$port,$errno,$error,1.5);if($fp){fclose($fp);return [true,'Połączenie TCP poprawne.'];}return [false,mb_substr(mb_scrub("$errno $error",'UTF-8'),0,250)];
}
function monitor_refresh(mysqli $d,array $u):array {
 $rows=monitor_rows($d,$u);
 foreach($rows as $row){$id=(int)$row['id'];$lock='z6_service_'.$id;$s=$d->prepare('SELECT GET_LOCK(?,0) AS acquired');$s->bind_param('s',$lock);$s->execute();if((int)$s->get_result()->fetch_assoc()['acquired']!==1)continue;
 try{$s=$d->prepare('SELECT *,TIMESTAMPDIFF(SECOND,checked_at,UTC_TIMESTAMP()) AS age FROM z6_domeny WHERE id=?');$s->bind_param('i',$id);$s->execute();$fresh=$s->get_result()->fetch_assoc();if(!$fresh||($fresh['checked_at']!==null&&(int)$fresh['age']<10))continue;
 [$ok,$detail]=monitor_probe($fresh['host'],(int)$fresh['port']);$status=$ok?'ok':'failure';
 $sql=$ok?"UPDATE z6_domeny SET status=?,detail=?,errors=0,failure=NULL,checked_at=UTC_TIMESTAMP() WHERE id=?":"UPDATE z6_domeny SET status=?,detail=?,errors=errors+1,total_errors=total_errors+1,failure=COALESCE(failure,UTC_TIMESTAMP()),checked_at=UTC_TIMESTAMP() WHERE id=?";
 $s=$d->prepare($sql);$s->bind_param('ssi',$status,$detail,$id);$s->execute();
 }finally{$s=$d->prepare('SELECT RELEASE_LOCK(?)');$s->bind_param('s',$lock);$s->execute();$s->get_result()->fetch_all();}}
 $rows=monitor_rows($d,$u);foreach($rows as &$r){$r['failure_seconds']=$r['failure']?max(0,time()-strtotime($r['failure'].' UTC')):0;$seconds=(int)$r['total_errors']*10;$r['downtime']=sprintf('%02d:%02d:%02d',intdiv($seconds,3600),intdiv($seconds%3600,60),$seconds%60);if($r['failure'])$r['failure']=(new DateTimeImmutable($r['failure'],new DateTimeZone('UTC')))->setTimezone(new DateTimeZone('Europe/Warsaw'))->format('Y-m-d H:i:s');}return $rows;
}
