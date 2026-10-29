<?php
declare(strict_types=1);
require __DIR__.'/common.php';
cloud_user();
$lock=null;
try{
    if(!in_array($_SERVER['REQUEST_METHOD']??'GET',['GET','HEAD'],true)){http_response_code(405);header('Allow: GET, HEAD');exit;}
    $relative=$_GET['path']??'';if(!is_string($relative)||$relative==='')throw new InvalidArgumentException('Nie znaleziono pliku.');
    $lock=cloud_lock();$path=cloud_resolve($relative);
    if(!is_file($path))throw new InvalidArgumentException('Nie znaleziono pliku.');
    $file=fopen($path,'rb');if(!$file)throw new RuntimeException('Nie można otworzyć pliku.');
    $size=fstat($file)['size'];$media=cloud_media($path);$inline=($_GET['inline']??'')==='1'&&$media!==null;
    flock($lock,LOCK_UN);fclose($lock);$lock=null;
}catch(Throwable $e){if(is_resource($lock))fclose($lock);http_response_code(404);header('Content-Type: text/plain; charset=UTF-8');exit('Nie znaleziono pliku.');}
session_write_close();
$filename=basename($path);$fallback=preg_replace('/[^A-Za-z0-9._-]/','_',$filename);
header('Content-Type: '.($inline?$media:'application/octet-stream'));
header('Content-Disposition: '.($inline?'inline':'attachment').'; filename="'.$fallback.'"; filename*=UTF-8\'\''.rawurlencode($filename));
header('X-Content-Type-Options: nosniff');header('Cache-Control: private, no-store');
header("Content-Security-Policy: default-src 'none'; sandbox");header('Accept-Ranges: bytes');
$start=0;$end=$size-1;
$range=$_SERVER['HTTP_RANGE']??'';
if($range!==''){
    $valid=preg_match('/\Abytes=(\d*)-(\d*)\z/D',$range,$m)&&($m[1]!==''||$m[2]!=='')&&$size>0;
    if($valid){
        if($m[1]===''){$suffix=(int)$m[2];$valid=$suffix>0;$start=max(0,$size-$suffix);}
        else {$start=(int)$m[1];$end=$m[2]===''?$size-1:min((int)$m[2],$size-1);}
        $valid=$valid&&$start<$size&&$start<=$end;
    }
    if(!$valid){http_response_code(416);header('Content-Range: bytes */'.$size);fclose($file);exit;}
    http_response_code(206);header("Content-Range: bytes $start-$end/$size");
}
$length=max(0,$end-$start+1);header('Content-Length: '.$length);
if(($_SERVER['REQUEST_METHOD']??'')==='HEAD'){fclose($file);exit;}
while(ob_get_level())ob_end_clean();
if($start)fseek($file,$start);
$remaining=$length;set_time_limit(0);
while($remaining>0&&!feof($file)&&!connection_aborted()){
    $chunk=fread($file,min(1048576,$remaining));if($chunk===false||$chunk==='')break;
    echo $chunk;$remaining-=strlen($chunk);flush();
}
fclose($file);
