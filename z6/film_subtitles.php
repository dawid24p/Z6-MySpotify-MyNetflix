<?php
declare(strict_types=1);
require __DIR__.'/common.php';$u=cloud_user();try{$d=db();$film=video_film($d,video_id($_GET['id']??null),(int)$u['id']);$d->close();if(!$film||trim($film['subtitles']??'')==='')throw new RuntimeException();}catch(Throwable){http_response_code(404);exit;}
$text=str_replace(["\r\n","\r"],"\n",$film['subtitles']);$text=preg_replace('/(\d{2}:\d{2}:\d{2}),(\d{3})/','$1.$2',$text);if(!str_starts_with(ltrim($text),'WEBVTT'))$text="WEBVTT\n\n".$text;
session_write_close();header('Content-Type: text/vtt; charset=UTF-8');header('Cache-Control: private, no-store');header('X-Content-Type-Options: nosniff');echo $text;
