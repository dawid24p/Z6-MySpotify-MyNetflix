<?php
declare(strict_types=1);
require __DIR__.'/common.php';
$user=cloud_user();$d=db();
$s=$d->prepare("SELECT datetime,ipaddress,event_type FROM z6_goscieportalu WHERE username=? AND event_type IN ('login','login_failed','login_blocked') ORDER BY id DESC LIMIT 100");$s->bind_param('s',$user['username']);$s->execute();$rows=$s->get_result()->fetch_all(MYSQLI_ASSOC);$s->close();$d->close();
head('Historia logowania');
echo '<p class="text-body-secondary">Ostatnie 100 prób logowania na Twoje konto. Godziny w strefie Europe/Warsaw.</p><div class="table-responsive"><table class="table"><thead><tr><th scope="col">Data i godzina</th><th scope="col">Adres IP</th><th scope="col">Wynik</th></tr></thead><tbody>';
foreach($rows as $row){$labels=['login'=>['success','Poprawne logowanie'],'login_failed'=>['danger','Błędne logowanie'],'login_blocked'=>['warning','Próba podczas blokady']];[$color,$label]=$labels[$row['event_type']];echo '<tr><td>'.h(cloud_time($row['datetime'])).'</td><td>'.h($row['ipaddress']).'</td><td><span class="badge text-bg-'.$color.'">'.$label.'</span></td></tr>';}
if(!$rows)echo '<tr><td colspan="3">Brak zapisanych prób logowania.</td></tr>';
echo '</tbody></table></div><a class="btn btn-outline-light" href="index.php">Mój dysk</a>';foot();
