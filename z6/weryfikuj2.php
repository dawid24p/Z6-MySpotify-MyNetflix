<?php declare(strict_types=1);
require __DIR__.'/common.php';
if (($_SERVER['REQUEST_METHOD']??'')!=='POST') redirect('index2.php');
$rawUser=posted('user');

$user=htmlentities($rawUser,ENT_QUOTES|ENT_SUBSTITUTE,'UTF-8');
$pass=htmlentities(posted('pass'),ENT_QUOTES|ENT_SUBSTITUTE,'UTF-8');
try{
    $result=guarded_login(2,$rawUser,function(mysqli $link)use($user,$pass):array{
        $record=$link->query("SELECT * FROM z6_users WHERE username='$user' LIMIT 1")->fetch_assoc();
        if(!$record)return ['ok'=>false,'message'=>'Brak użytkownika o takim loginie!'];
        if(!hash_equals($record['password'],$pass))return ['ok'=>false,'message'=>'Błąd w haśle!'];
        return ['ok'=>true,'message'=>'Logowanie OK. Użytkownik: '.$record['username']];
    });
    if($result['ok'])$_SESSION['pending_login_visit']=record_visit('login');
    $message=$result['message'];
}catch(Throwable $e){error_log('PAS z1: błąd weryfikacji 2 ('.get_class($e).')');$message='Logowanie jest chwilowo niedostępne.';}
result_page('Weryfikacja w dwóch fazach',$message,'index2.php');