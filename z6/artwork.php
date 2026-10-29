<?php
declare(strict_types=1);
require __DIR__.'/common.php';$u=cloud_user();
try{
    $d=db();if(isset($_GET['song']))$record=music_song($d,music_id($_GET['song']),(int)$u['id']);else $record=music_playlist($d,music_id($_GET['playlist']??null),(int)$u['id']);$d->close();$relative=$record['coverfilename']??null;
    if(!is_string($relative)||!preg_match('/\A[A-Za-z0-9_.-]{3,20}\/[a-f0-9]{32}\.jpg\z/D',$relative)||is_link(SONGS_DIR.'/'.dirname($relative))||is_link(SONGS_DIR.'/'.$relative))throw new RuntimeException('Brak okładki.');$path=realpath(SONGS_DIR.'/'.$relative);if(!$path||!str_starts_with($path,realpath(SONGS_DIR).'/')||!is_file($path))throw new RuntimeException('Brak okładki.');
}catch(Throwable){http_response_code(404);exit;}
session_write_close();header('Content-Type: image/jpeg');header('Content-Length: '.filesize($path));header('Cache-Control: private, max-age=3600');header('X-Content-Type-Options: nosniff');if(($_SERVER['REQUEST_METHOD']??'')!=='HEAD')readfile($path);
