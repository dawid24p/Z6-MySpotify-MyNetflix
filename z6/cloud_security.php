<?php
declare(strict_types=1);
require __DIR__.'/common.php';
$user=cloud_user();
if(!in_array($user['username'],['admin','Dawid24p'],true)){http_response_code(403);head('Brak dostępu');echo '<div class="alert alert-danger">Ta strona jest dostępna tylko administratorowi.</div>';foot();exit;}
$d=db();$rows=$d->query('SELECT username,datetime,ipaddress FROM z6_break_ins ORDER BY id DESC LIMIT 200')->fetch_all(MYSQLI_ASSOC);$d->close();
head('Bezpieczeństwo MyCloud');echo '<p class="text-body-secondary">Ostatnie 200 blokad kont po trzech kolejnych błędnych próbach logowania.</p><div class="table-responsive"><table class="table"><thead><tr><th scope="col">Konto</th><th scope="col">Data i godzina</th><th scope="col">Adres IP</th></tr></thead><tbody>';
foreach($rows as $row)echo '<tr><td>'.h($row['username']).'</td><td>'.h(cloud_time($row['datetime'])).'</td><td>'.h($row['ipaddress']).'</td></tr>';
if(!$rows)echo '<tr><td colspan="3">Nie zarejestrowano blokad kont.</td></tr>';
echo '</tbody></table></div><a class="btn btn-outline-light" href="index.php">Mój dysk</a>';foot();
