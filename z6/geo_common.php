<?php declare(strict_types=1);
function visitor_db(): mysqli {
    $path='/home/srv126086/z6-work/visitor-db.php';
    if(!is_file($path))return db();
    $c=require $path;$d=new mysqli($c['host'],$c['user'],$c['pass'],$c['name']);$d->set_charset('utf8mb4');return $d;
}
function client_ip(): string { $ip=$_SERVER['REMOTE_ADDR']??'';return filter_var($ip,FILTER_VALIDATE_IP)?$ip:'127.0.0.1'; }
function record_visit(string $event): ?int {
    try{
        $d=visitor_db();$ip=client_ip();$ua=mb_substr(mb_scrub((string)($_SERVER['HTTP_USER_AGENT']??''),'UTF-8'),0,1000);$page=mb_substr((string)($_SERVER['SCRIPT_NAME']??''),0,200);$user=($_SESSION['loggedin']??false)?(string)$_SESSION['username']:null;
        $s=$d->prepare('INSERT INTO z6_goscieportalu (ipaddress,datetime,event_type,page,username,user_agent) VALUES (?,UTC_TIMESTAMP(),?,?,?,?)');$s->bind_param('sssss',$ip,$event,$page,$user,$ua);$s->execute();$id=(int)$d->insert_id;$s->close();$d->close();return $id;
    }catch(Throwable $e){error_log('PAS z3: błąd zapisu wizyty');return null;}
}
function visit_token(int $id): string {$_SESSION['visit_secret']??=bin2hex(random_bytes(32));return hash_hmac('sha256',(string)$id,$_SESSION['visit_secret']);}
function visit_attributes(?int $id): string {
    $_SESSION['geo_csrf']??=bin2hex(random_bytes(32));
    $out=' data-geo-csrf="'.h($_SESSION['geo_csrf']).'"';
    if($id!==null)$out.=' data-visit-id="'.$id.'" data-visit-token="'.visit_token($id).'"';
    if(isset($_SESSION['pending_login_visit'])){$login=(int)$_SESSION['pending_login_visit'];$out.=' data-login-visit-id="'.$login.'" data-login-visit-token="'.visit_token($login).'"';unset($_SESSION['pending_login_visit']);}
    return $out;
}
function geo_policy_enabled(): bool {$d=visitor_db();$r=$d->query("SELECT value FROM z6_settings WHERE name='poland_only'")->fetch_assoc();$d->close();return ($r['value']??'0')==='1';}
function is_geo_admin(): bool {return ($_SESSION['loggedin']??false)===true && ($_SESSION['username']??'')==='Dawid24p';}
function require_login(): void {start_session();if(($_SESSION['loggedin']??false)!==true)redirect('index3.php');}
function normalize_geo_result(string $ip, array $data, string $provider): ?array {
    if(isset($data['error']) || ($data['success']??true)!==true)return null;
    if(!is_string($data['ip']??null) || @inet_pton($data['ip'])!==inet_pton($ip))return null;
    $country=$provider==='IPinfo'?($data['country']??null):($data['country_code']??null);
    if(!is_string($country) || !preg_match('/^[A-Z]{2}$/D',$country))return null;
    if($provider==='IPinfo'){
        $loc=$data['loc']??null;
        if(!is_string($loc) || !preg_match('/^(-?\d+(?:\.\d+)?),(-?\d+(?:\.\d+)?)$/D',$loc,$m))return null;
        $latitude=(float)$m[1];$longitude=(float)$m[2];
    }else{
        if(!is_numeric($data['latitude']??null) || !is_numeric($data['longitude']??null))return null;
        $latitude=(float)$data['latitude'];$longitude=(float)$data['longitude'];
        $loc=$latitude.','.$longitude;
    }
    if(!is_finite($latitude) || !is_finite($longitude) || abs($latitude)>90 || abs($longitude)>180)return null;
    return ['ip'=>$ip,'country'=>$country,
        'city'=>is_string($data['city']??null)?$data['city']:'',
        'region'=>is_string($data['region']??null)?$data['region']:'',
        'loc'=>$loc,'provider'=>$provider,
        'map'=>'https://www.google.com/maps/search/?api=1&query='.rawurlencode($loc)];
}
function ip_details(string $ip): array {
    if(!filter_var($ip,FILTER_VALIDATE_IP,FILTER_FLAG_NO_PRIV_RANGE|FILTER_FLAG_NO_RES_RANGE))return ['ip'=>$ip,'country'=>'','error'=>'Adres lokalny lub zarezerwowany — brak geolokalizacji.'];
    $directory='/home/srv126086/z6-work/cache';
    $cache=$directory.'/'.hash('sha256',inet_pton($ip)).'.json';
    $cached=is_file($cache)?json_decode((string)@file_get_contents($cache),true):null;
    
    if(is_array($cached) && ($cached['version']??0)===2 && ($cached['ip']??'')===$ip){
        $ttl=isset($cached['error'])?60:86400;
        if(filemtime($cache)>time()-$ttl)return $cached;
    }
    $result=['version'=>2,'ip'=>$ip,'country'=>'','error'=>'Usługa geolokalizacji jest chwilowo niedostępna. Spróbuj ponownie za minutę.'];
    $providers=['IPinfo'=>'https://ipinfo.io/'.rawurlencode($ip).'/geo',
        'IPwho.is'=>'https://ipwho.is/'.rawurlencode($ip)];
    foreach($providers as $provider=>$url){
        $cooldown=$directory.'/provider-'.hash('sha256',$provider).'.json';
        $state=is_file($cooldown)?json_decode((string)@file_get_contents($cooldown),true):null;
        if(is_array($state) && (int)($state['retry_at']??0)>time())continue;
        $retryAfter=0;
        $c=curl_init($url);
        curl_setopt_array($c,[CURLOPT_RETURNTRANSFER=>true,CURLOPT_CONNECTTIMEOUT=>2,
            CURLOPT_TIMEOUT=>4,CURLOPT_PROTOCOLS=>CURLPROTO_HTTPS,CURLOPT_FOLLOWLOCATION=>false,
            CURLOPT_USERAGENT=>'StudentGeolocationLab/2.0',
            CURLOPT_HTTPHEADER=>['Accept: application/json'],
            CURLOPT_HEADERFUNCTION=>static function($curl,string $header)use(&$retryAfter):int{
                if(preg_match('/^Retry-After:\s*(.+)$/i',trim($header),$m)){
                    $value=trim($m[1]);
                    $retryAfter=ctype_digit($value)?(int)$value:max(0,(int)strtotime($value)-time());
                }
                return strlen($header);
            }]);
        $body=curl_exec($c);$status=(int)curl_getinfo($c,CURLINFO_HTTP_CODE);curl_close($c);
        
        if($status===429 || $status===0 || $status>=500){
            $pause=$status===429?max(900,min(86400,$retryAfter)):60;
            @file_put_contents($cooldown,json_encode(['retry_at'=>time()+$pause]),LOCK_EX);
        }
        if($status!==200 || !is_string($body))continue;
        $data=json_decode($body,true);
        if(!is_array($data))continue;
        $normalized=normalize_geo_result($ip,$data,$provider);
        if($normalized===null)continue;
        $result=['version'=>2]+$normalized;
        break;
    }
    
    if(isset($result['error']) && is_array($cached) && !isset($cached['error'])
        && ($cached['version']??0)===2 && ($cached['ip']??'')===$ip
        && filemtime($cache)>time()-604800)return $cached;
    
    @file_put_contents($cache,json_encode($result,JSON_UNESCAPED_UNICODE|JSON_INVALID_UTF8_SUBSTITUTE),LOCK_EX);
    return $result;
}

function command_output(string $command): string {
    if(!function_exists('exec'))return 'Polecenie zablokowane przez hosting.';
    $lines=[];$status=0;exec($command.' 2>&1',$lines,$status);$text=implode("\n",array_slice($lines,0,100));
    return $status===0?($text?:'Polecenie nie zwróciło danych.'):'Polecenie niedostępne na hostingu (kod '.$status.").\n".$text;
}
function diagnostics_page(string $title,string $command,string $note=''): void {require_login();head($title);if($note!=='')echo '<p class="text-body-secondary">'.h($note).'</p>';echo '<pre class="diagnostic-output">'.h(command_output($command)).'</pre>';foot();}
function country_allowed(string $country,bool $enabled):bool{return !$enabled || $country==='PL';}
