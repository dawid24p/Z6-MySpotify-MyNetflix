<?php
declare(strict_types=1);
require __DIR__.'/common.php';$u=cloud_user();music_post();
if(strlen(posted('state'))>200000){http_response_code(413);exit;}
try{$state=json_decode(posted('state'),true,32,JSON_THROW_ON_ERROR);}catch(JsonException){http_response_code(400);exit;}
if(!is_array($state)||!is_array($state['queue']??null)||count($state['queue'])>500){http_response_code(400);exit;}
$d=db();$queue=[];$index=0;$selected=$state['queue'][(int)($state['index']??0)]['id']??0;
foreach($state['queue'] as $track){$id=(int)($track['id']??0);$song=music_song($d,$id,(int)$u['id']);if(!$song)continue;if($id===$selected)$index=count($queue);$queue[]=['id'=>$id,'title'=>$song['title'],'musician'=>$song['musician'],'url'=>'song_file.php?id='.$id];}
if(!$queue){http_response_code(400);exit;}
$repeat=max(0,min(2,(int)($state['repeat']??0)));$shuffle=(bool)($state['shuffle']??false);if($shuffle&&$repeat===1)$repeat=2;
$clean=['queue'=>$queue,'index'=>$index,'time'=>max(0,min(604800,(float)($state['time']??0))),'playing'=>false,'shuffle'=>$shuffle,'repeat'=>$repeat,'volume'=>max(0,min(1,(float)($state['volume']??.75))),'muted'=>(bool)($state['muted']??false)];
$json=json_encode($clean,JSON_THROW_ON_ERROR|JSON_UNESCAPED_UNICODE);$s=$d->prepare('INSERT INTO z6_player_state(idu,state) VALUES (?,?) ON DUPLICATE KEY UPDATE state=VALUES(state)');$s->bind_param('is',$u['id'],$json);$s->execute();$d->close();http_response_code(204);
