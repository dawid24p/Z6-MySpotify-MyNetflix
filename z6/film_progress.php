<?php
declare(strict_types=1);
require __DIR__.'/common.php';$u=cloud_user();video_post();
try{$id=video_id(posted('film'));}catch(InvalidArgumentException){http_response_code(400);exit;}
$position=filter_var(posted('position'),FILTER_VALIDATE_FLOAT);if($position===false||!is_finite($position)||$position<0||$position>604800){http_response_code(400);exit;}
$d=db();$film=video_film($d,$id,(int)$u['id']);if(!$film){http_response_code(404);exit;}
$duration=$film['duration_seconds']===null?null:(int)$film['duration_seconds'];if($duration!==null)$position=min($position,$duration);
$completed=posted('completed')==='1'&&($duration===null||$position>=$duration-2)?1:0;
$s=$d->prepare('INSERT INTO z6v_watch_progress(idu,idf,position_seconds,completed) VALUES (?,?,?,?) ON DUPLICATE KEY UPDATE position_seconds=VALUES(position_seconds),completed=VALUES(completed),updated_at=CURRENT_TIMESTAMP');$s->bind_param('iidi',$u['id'],$id,$position,$completed);$s->execute();$d->close();http_response_code(204);
