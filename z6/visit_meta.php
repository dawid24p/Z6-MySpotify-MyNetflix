<?php declare(strict_types=1);
require __DIR__.'/common.php';start_session();header('Content-Type: application/json; charset=UTF-8');
if(($_SERVER['REQUEST_METHOD']??'')!=='POST'){http_response_code(405);echo '{}';exit;}
$input=file_get_contents('php://input',false,null,0,10000);$p=json_decode($input,true);if(!is_array($p)){http_response_code(400);echo '{}';exit;}
$id=(int)($p['id']??0);$token=$p['token']??'';
if($id<1||!is_string($token)||!isset($_SESSION['visit_secret'])||!hash_equals(visit_token($id),$token)){http_response_code(403);echo '{}';exit;}
function bounded(array $p,string $k,int $max): ?int {$v=$p[$k]??null;return is_numeric($v)&&$v>=0&&$v<=$max?(int)$v:null;}
$sw=bounded($p,'screen_width',20000);$sh=bounded($p,'screen_height',20000);$ww=bounded($p,'window_width',20000);$wh=bounded($p,'window_height',20000);$depth=bounded($p,'color_depth',64);
$cookies=is_bool($p['cookies_enabled']??null)?(int)$p['cookies_enabled']:null;$java=is_bool($p['java_enabled']??null)?(int)$p['java_enabled']:null;
$lang=is_string($p['language']??null)?mb_substr(mb_scrub($p['language'],'UTF-8'),0,35):null;$browser=is_string($p['browser']??null)?mb_substr(mb_scrub($p['browser'],'UTF-8'),0,120):null;$os=is_string($p['operating_system']??null)?mb_substr(mb_scrub($p['operating_system'],'UTF-8'),0,120):null;
$ratio=is_numeric($p['pixel_ratio']??null)&&$p['pixel_ratio']>0&&$p['pixel_ratio']<=20?(float)$p['pixel_ratio']:null;$ip=client_ip();
$d=visitor_db();$s=$d->prepare('UPDATE z6_goscieportalu SET screen_width=?,screen_height=?,window_width=?,window_height=?,color_depth=?,cookies_enabled=?,java_enabled=?,language=?,browser=?,operating_system=?,pixel_ratio=? WHERE id=? AND ipaddress=?');$s->bind_param('iiiiiiisssdis',$sw,$sh,$ww,$wh,$depth,$cookies,$java,$lang,$browser,$os,$ratio,$id,$ip);$s->execute();$s->close();$d->close();echo '{"ok":true}';