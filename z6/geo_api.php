<?php declare(strict_types=1);
require __DIR__.'/common.php';start_session();header('Content-Type: application/json; charset=UTF-8');
$token=$_SERVER['HTTP_X_GEO_TOKEN']??'';
if(!isset($_SESSION['geo_csrf'])||!hash_equals($_SESSION['geo_csrf'],$token)){http_response_code(403);echo '{"error":"Brak tokenu"}';exit;}
$ip=$_GET['ip']??client_ip();if(!is_string($ip)||!filter_var($ip,FILTER_VALIDATE_IP)){http_response_code(400);echo '{"error":"Nieprawidłowy IP"}';exit;}
if($ip!==client_ip()&&($_SESSION['loggedin']??false)!==true){http_response_code(403);echo '{"error":"Wymagane logowanie"}';exit;}
$count=$_SESSION['geo_requests']??['time'=>time(),'count'=>0];if($count['time']<time()-60)$count=['time'=>time(),'count'=>0];$count['count']++;$_SESSION['geo_requests']=$count;
if($count['count']>30){http_response_code(429);echo '{"error":"Limit zapytań, spróbuj za minutę"}';exit;}
session_write_close();echo json_encode(ip_details($ip),JSON_UNESCAPED_UNICODE|JSON_INVALID_UTF8_SUBSTITUTE);