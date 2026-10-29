<?php declare(strict_types=1);
require __DIR__.'/common.php';start_session();
if(($_SESSION['loggedin']??false)!==true)redirect('index3.php');
$user=current_user();if(!$user){unset($_SESSION['loggedin'],$_SESSION['username']);redirect('index3.php');}
head('Panel użytkownika');
if(isset($_SESSION['login_warning'])){$w=$_SESSION['login_warning'];unset($_SESSION['login_warning']);echo '<div class="alert alert-danger" role="alert">Uwaga: wykryto trzy błędne próby logowania na Twoje konto. Ostatnie zdarzenie: '.h(cloud_time($w['datetime'])).', IP: '.h($w['ipaddress']).'.</div>';}
if(isset($_SESSION['account_flash'])){$f=$_SESSION['account_flash'];unset($_SESSION['account_flash']);echo '<div class="alert alert-'.h($f['type']).'" role="status">'.h($f['message']).'</div>';}
?>
<section class="card"><div class="card-body p-4 d-flex flex-column flex-sm-row align-items-start gap-4">
<img class="avatar avatar-profile" src="<?=h(avatar_url($user['avatar']))?>" alt="Avatar użytkownika <?=h($user['username'])?>">
<div><span class="badge text-bg-success mb-3">Jesteś zalogowany</span><h2 class="h4">Witaj, <?=h($user['username'])?>!</h2><div class="d-flex flex-wrap gap-2"><a class="btn btn-primary" href="account_edit.php">Edytuj konto</a><a class="btn btn-outline-light" href="logout.php">Wyloguj się</a></div></div>
</div></section>
<?php foot(); ?>