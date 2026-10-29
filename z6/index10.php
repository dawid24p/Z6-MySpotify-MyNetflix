<?php declare(strict_types=1);require __DIR__.'/common.php';head('DNS i nazwy hostów');
$records=@dns_get_record('pbs.edu.pl',DNS_A|DNS_AAAA|DNS_MX|DNS_NS|DNS_TXT);
echo '<h2 class="h5">dns_get_record("pbs.edu.pl")</h2><pre class="diagnostic-output">'.h(print_r($records,true)).'</pre>';
$ip=client_ip();echo '<div class="table-responsive"><table class="table"><thead><tr><th>Funkcja</th><th>Wynik</th></tr></thead><tbody>';
foreach(['gethostbyname(pbs.edu.pl)'=>gethostbyname('pbs.edu.pl'),'REMOTE_ADDR — IP gościa'=>$ip,'gethostbyaddr(8.8.8.8)'=>gethostbyaddr('8.8.8.8'),'gethostbyaddr(IP gościa)'=>@gethostbyaddr($ip)] as $name=>$value)echo '<tr><td>'.h($name).'</td><td>'.h((string)$value).'</td></tr>';
echo '</tbody></table></div>';foot();