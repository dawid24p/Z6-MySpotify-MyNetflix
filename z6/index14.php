<?php declare(strict_types=1);require __DIR__.'/common.php';head('Narzędzia, trasa połączenia i VPN'); ?>
<section class="card"><div class="card-body"><h2 class="h5">Testy z własnego komputera i telefonu</h2><ol>
<li>Sprawdź swoje IP i lokalizację na <a href="https://ipinfo.io/" target="_blank" rel="noopener noreferrer">IPinfo</a> i w zakładce <a href="index11.php">Moje IP</a>.</li>
<li>Porównaj wynik przy włączonym i wyłączonym VPN oraz po zmianie jego regionu.</li>
<li>Na telefonie porównaj Wi-Fi i transmisję komórkową. Wynik może być przybliżony.</li>
<li>Uruchom <a href="https://www.yougetsignal.com/tools/visual-tracert/" target="_blank" rel="noopener noreferrer">Visual Trace Route</a> dla srv126086.seohost.com.pl; powtórz po 10 sekundach.</li>
<li>W terminalu swojego komputera sprawdź polecenie <code>netstat</code>.</li>
</ol><h2 class="h5">Wąski test portów z własnego komputera</h2><p>Jeżeli masz Nmap, sprawdź tylko HTTP i HTTPS:</p><pre class="diagnostic-output">nmap -sT -Pn -p 80,443 --max-retries 1 --host-timeout 20s srv126086.seohost.com.pl</pre><p class="text-body-secondary">PHPinfo nie dowodzi, że port jest otwarty. Połączenie testowane z wnętrza hostingu może dać inny wynik niż z Twojego komputera.</p></div></section>
<?php foot(); ?>