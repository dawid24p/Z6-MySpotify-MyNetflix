<?php declare(strict_types=1);require __DIR__.'/common.php';require_login();head('PHPinfo — informacje o PHP');
echo '<p>Konfiguracja PHP pokazuje ustawienia usług; nie potwierdza, że porty rzeczywiście nasłuchują. Sprawdź je w Netstat.</p>';
ob_start();phpinfo(INFO_GENERAL|INFO_CONFIGURATION|INFO_MODULES);$info=ob_get_clean();preg_match('/<body>(.*?)<\/body>/si',$info,$m);
echo '<div class="phpinfo-output">'.($m[1]??'Brak raportu').'</div>';foot();