<?php declare(strict_types=1);
require __DIR__.'/common.php';
if (($_SERVER['REQUEST_METHOD']??'')!=='POST') redirect('index3.php');
start_session();
unset($_SESSION['loggedin'],$_SESSION['username']);
$user=posted('user');$pass=posted('pass');
try{
    $result=guarded_login(3,$user,function(mysqli $link)use($user,$pass):array{
        $s=$link->prepare('SELECT username,password FROM z6_users WHERE username=? LIMIT 1');
        $s->bind_param('s',$user);$s->execute();$record=$s->get_result()->fetch_assoc();$s->close();
        
        $ok=$user!=='' && $pass!=='' && $record && (password_verify($pass,$record['password']) || (password_get_info($record['password'])['algo']===null && hash_equals($record['password'],$pass)));
        return ['ok'=>(bool)$ok,'username'=>$ok?$record['username']:'','message'=>'Nieprawidłowy login lub hasło.'];
    });
    if(isset($result['visit_id']))$_SESSION['pending_login_visit']=(int)$result['visit_id'];
    if($result['ok']){
        if(!session_regenerate_id(true))throw new RuntimeException('Błąd odnowienia sesji');
        $_SESSION['cloud_home']=cloud_home_for($result['username']);
        $_SESSION['loggedin']=true;$_SESSION['username']=$result['username'];
        if(!empty($result['warning']))$_SESSION['login_warning']=$result['warning'];
        redirect('index4.php');
    }
    $_SESSION['flash']=$result['message'];
}catch(Throwable $e){error_log('PAS z1: błąd logowania ('.get_class($e).')');$_SESSION['flash']='Logowanie jest chwilowo niedostępne.';}
redirect('index3.php');