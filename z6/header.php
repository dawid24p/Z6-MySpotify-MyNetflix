<?php declare(strict_types=1);
require __DIR__.'/common.php';start_session();
header('Content-Type: text/html; charset=UTF-8');
$user=current_user();
if(!$user){
    echo '<header><nav class="navbar navbar-dark fixed-top border-bottom" aria-label="Logowanie"><div class="container"><a class="navbar-brand fw-semibold" href="index3.php">Zadanie 6</a><div class="d-flex gap-2"><a class="btn btn-outline-light btn-sm" href="index3.php">Zaloguj</a><a class="btn btn-primary btn-sm" href="rejestruj.php">Rejestracja</a></div></div></nav></header>';
    exit;
}
?>
<header><nav class="navbar navbar-expand-lg navbar-dark fixed-top border-bottom" aria-label="Menu główne">
<div class="container">
<a class="navbar-brand fw-semibold" href="tasks.php">Zadanie 6 <span class="badge text-bg-primary ms-1">mySpotify / myNetflix</span></a>
<button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#main_nav" aria-controls="main_nav" aria-expanded="false" aria-label="Rozwiń lub zwiń menu"><span class="menu-bars" aria-hidden="true"><span></span><span></span><span></span></span></button>
<div class="collapse navbar-collapse" id="main_nav">
<?php $taskMenus=require __DIR__.'/task_menu.php';$taskAdmin=in_array($user['username'],['admin','Dawid24p'],true); ?>
<ul class="navbar-nav me-auto mb-2 mb-md-0">
<?php foreach($taskMenus as $number=>$task): ?>
<li class="nav-item dropdown">
<button class="nav-link dropdown-toggle" type="button" id="task<?=$number?>-menu" data-bs-toggle="dropdown" aria-expanded="false">Zadanie <?=$number?></button>
<ul class="dropdown-menu" aria-labelledby="task<?=$number?>-menu">
<li><h2 class="dropdown-header"><?=h($task['title'])?></h2></li>
<?php foreach($task['items'] as $item): if(($item['admin']??false)&&!$taskAdmin)continue; ?>
<?php if(isset($item['heading'])): ?><li><hr class="dropdown-divider"></li><li><h2 class="dropdown-header"><?=h($item['heading'])?></h2></li>
<?php else: ?><li><a class="dropdown-item" href="<?=h($item['href'])?>"><?=h($item['label'])?></a></li><?php endif; ?>
<?php endforeach; ?>
</ul></li>
<?php endforeach; ?>
</ul>
<div class="d-flex align-items-center gap-2 pb-2 pb-md-0">
<?php if($user): ?>
<a class="nav-profile d-flex align-items-center gap-2" href="index4.php"><img class="avatar avatar-sm" src="<?=h(avatar_url($user['avatar']))?>" alt="Avatar użytkownika"><span><?=h($user['username'])?></span></a>
<a class="btn btn-outline-light btn-sm d-inline-flex align-items-center gap-1" href="logout.php"><img src="media/menu_icons/sign-out.svg" width="16" height="16" alt="">Wyloguj</a>
<?php else: ?>
<a class="btn btn-outline-light btn-sm" href="index3.php">Zaloguj</a><a class="btn btn-primary btn-sm" href="rejestruj.php">Rejestracja</a>
<?php endif; ?>
</div></div></div></nav></header>