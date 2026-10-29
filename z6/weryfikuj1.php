<?php declare(strict_types=1);
require __DIR__.'/common.php';
if (($_SERVER['REQUEST_METHOD']??'')!=='POST') redirect('index1.php');
$user=posted('user');$pass=posted('pass');
try{
    $result=guarded_login(1,$user,function(mysqli $link)use($user,$pass):array{
        
        try{$record=$link->query("SELECT * FROM z6_users WHERE (username='$user') AND (password='$pass')")->fetch_assoc();}
        catch(mysqli_sql_exception $e){return ['ok'=>false,'message'=>'Błąd zapytania SQL.'];}
        return ['ok'=>(bool)$record,'message'=>$record?'Logowanie OK. Użytkownik: '.$record['username']:'Błąd nazwy użytkownika lub hasła.'];
    });
    if($result['ok'])$_SESSION['pending_login_visit']=record_visit('login');
    $message=$result['message'];
}catch(Throwable $e){error_log('PAS z1: błąd weryfikacji 1 ('.get_class($e).')');$message='Logowanie jest chwilowo niedostępne.';}
result_page('Weryfikacja — wersja podatna',$message,'index1.php');