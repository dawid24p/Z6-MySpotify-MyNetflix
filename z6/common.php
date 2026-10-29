<?php
declare(strict_types=1);

function db(): mysqli {
    mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);
    $c=require (getenv('Z6_DB_CONFIG') ?: '/home/srv126086/z6-work/db.php');
    $link=new mysqli($c['host'],$c['user'],$c['pass'],$c['name']);
    $link->set_charset('utf8mb4');$link->query("SET time_zone = '+00:00'");return $link;
}
function h(string $s): string {return htmlspecialchars($s,ENT_QUOTES|ENT_SUBSTITUTE,'UTF-8');}
function posted(string $key): string {$v=$_POST[$key]??'';return is_string($v)?$v:'';}
function redirect(string $url): never {header('Location: '.$url,true,303);exit;}
function start_session(): void {
    if(session_status()===PHP_SESSION_ACTIVE)return;
    ini_set('session.use_strict_mode','1');ini_set('session.use_only_cookies','1');
    session_name('Z6SESSION');
    session_set_cookie_params(['path'=>'/z6/','httponly'=>true,'secure'=>!empty($_SERVER['HTTPS'])&&$_SERVER['HTTPS']!=='off','samesite'=>'Lax']);
    if(!session_start())throw new RuntimeException('Błąd sesji');
    header('Cache-Control: no-store');
}
function avatar_url(?string $file): string {
    if($file!==null && preg_match('/\A[a-f0-9]{64}\.png\z/D',$file) && is_file(__DIR__.'/media/avatars/'.$file))return 'media/avatars/'.$file;
    return 'media/default-avatar.svg';
}
function current_user(): ?array {
    if(($_SESSION['loggedin']??false)!==true)return null;
    $username=(string)($_SESSION['username']??'');$link=db();
    $s=$link->prepare('SELECT id,username,avatar FROM z6_users WHERE username=? LIMIT 1');$s->bind_param('s',$username);$s->execute();$record=$s->get_result()->fetch_assoc();$s->close();$link->close();
    return $record;
}
function head(string $title): void {
    start_session();header('Content-Type: text/html; charset=UTF-8');
    $visit=record_visit('visit');
    $meta=visit_attributes($visit);
    echo '<!DOCTYPE html><html lang="pl" data-bs-theme="dark"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1"><meta name="author" content="Dawid Michalak"><meta name="description" content="Zadanie 6: mySpotify i myNetflix — muzyka i filmy"><title>Michalak</title><link rel="icon" href="../favicon.jpg"><link rel="stylesheet" href="vendor/bootstrap.min.css"><link rel="stylesheet" href="twoj_css.css?v=menu-2"><link rel="stylesheet" href="cloud.css?v=1"><link rel="stylesheet" href="music.css?v=list-5"><link rel="stylesheet" href="spotify_player.css?v=neutral-4"><link rel="stylesheet" href="video.css?v=progress-5"><script defer src="vendor/jquery.min.js"></script><script defer src="vendor/bootstrap.bundle.min.js"></script><script defer src="twoj_js.js?v=continuous-5"></script><script defer src="cloud.js?v=1"></script><script defer src="music.js?v=list-8"></script><script defer src="spotify_player.js?v=music-only-9"></script><script defer src="video.js?v=progress-4"></script><script defer src="navigation.js?v=progress-4"></script><script defer src="vendor/ua-parser.min.js"></script><script defer src="geo_js.js?v=1"></script><script defer src="monitor.js?v=continuous-3"></script></head><body'.$meta.'><div id="myHeader"><nav class="navbar fixed-top bg-dark border-bottom"><div class="container"><a class="navbar-brand" href="index.php">Zadanie 6</a></div></nav></div><noscript><div class="container pt-5"><a href="index3.php">Logowanie</a> · <a href="rejestruj.php">Rejestracja</a></div></noscript><main class="container sekcja1"><h1 class="mb-4">'.h($title).'</h1>';
}
function foot(): void {echo '</main>';require __DIR__.'/footer.php';if(($_SESSION['loggedin']??false)===true)require __DIR__.'/player.php';echo '</body></html>';}
function result_page(string $title,string $message,string $back): never {
    head($title);$success=str_starts_with($message,'Logowanie OK');
    echo '<div class="alert '.($success?'alert-success':'alert-warning').'" role="status">'.h($message).'</div><a class="btn btn-outline-light" href="'.h($back).'">Powrót do formularza</a> <a class="btn btn-link" href="index.php">Menu zadania</a>';foot();exit;
}
function login_form(int $version): void {
    start_session();if($version===3 && ($_SESSION['loggedin']??false)===true)redirect('index4.php');
    $titles=[1=>'Logowanie — wersja podatna',2=>'Logowanie — weryfikacja w dwóch fazach',3=>'Logowanie do systemu'];
    head($titles[$version]);
    echo '<section class="card auth-card"><div class="card-body p-4">';
    if($version===3 && isset($_SESSION['flash'])){echo '<div class="alert alert-info" role="status">'.h($_SESSION['flash']).'</div>';unset($_SESSION['flash']);}
    echo '<form method="post" action="weryfikuj'.$version.'.php"><div class="form-floating mb-3"><input class="form-control" type="text" id="user" name="user" maxlength="20" autocomplete="username" placeholder="Login" required><label for="user">Login</label></div><div class="form-floating mb-4"><input class="form-control" type="password" id="pass" name="pass" maxlength="20" autocomplete="current-password" placeholder="Hasło" required><label for="pass">Hasło</label></div><button class="btn btn-primary w-100" type="submit">Zaloguj</button></form><p class="mt-3 mb-0 text-center"><a href="rejestruj.php">Nie masz konta? Zarejestruj się</a></p></div></section><p class="mt-4"><a href="index.php">Powrót do menu głównego</a></p>';
    foot();
}
function guarded_login(int $form,string $user,callable $verify): array { return cloud_guarded_login($form,$user,$verify); }
require_once __DIR__.'/geo_common.php';

require_once __DIR__.'/monitor_common.php';
require_once __DIR__.'/cloud_common.php';
require_once __DIR__.'/music_common.php';
require_once __DIR__.'/video_common.php';


start_session();
$entry=basename((string)($_SERVER['SCRIPT_FILENAME']??''));
$public=['index3.php','weryfikuj3.php','rejestruj.php','add.php','polecenie2_1.php','polecenie2_2.php','header.php','visit_meta.php'];
if(($_SESSION['loggedin']??false)!==true && !in_array($entry,$public,true)){
    if(in_array($entry,['geo_api.php','visit_meta.php','monitor_api.php'],true)){
        http_response_code(401);
        header('Content-Type: application/json; charset=UTF-8');
        echo '{"error":"Wymagane logowanie"}';
        exit;
    }
    redirect('index3.php');
}