<?php
declare(strict_types=1);
require __DIR__.'/common.php';
$user=cloud_user();$dir='';$lock=null;
try{
    $input=$_GET['dir']??'';if(!is_string($input))throw new InvalidArgumentException('Nieprawidłowy folder.');
    $dir=cloud_relative($input,1);$lock=cloud_lock();$current=cloud_resolve($dir,true);$entries=[];
    foreach(new DirectoryIterator($current) as $item){
        if($item->isDot()||$item->isLink()||(!$item->isDir()&&!$item->isFile()))continue;
        $entries[]=['name'=>$item->getFilename(),'dir'=>$item->isDir(),'size'=>$item->isDir()?null:$item->getSize(),'time'=>$item->getMTime(),'mime'=>$item->isDir()?null:cloud_media($item->getPathname())];
    }
    usort($entries,fn($a,$b)=>($b['dir']<=>$a['dir'])?:strnatcasecmp($a['name'],$b['name']));
}catch(Throwable $e){if(is_resource($lock))fclose($lock);http_response_code(404);head('Nie znaleziono folderu');echo '<div class="alert alert-warning">Nie znaleziono folderu.</div><a href="drive.php" class="btn btn-primary">Mój dysk</a>';foot();exit;}
if(is_resource($lock)){flock($lock,LOCK_UN);fclose($lock);}
$mode=($_GET['view']??($_SESSION['cloud_view']??'preview'))==='list'?'list':'preview';$_SESSION['cloud_view']=$mode;
$folders=count(array_filter($entries,fn($e)=>$e['dir']));$total=array_sum(array_column($entries,'size'));$csrf=cloud_csrf();
head('MyCloud');
?>
<div class="cloud-heading mb-4"><div><p class="text-body-secondary mb-1">Twój prywatny dysk</p><p class="mb-0">Witaj, <strong><?=h($user['username'])?></strong>.</p></div><div class="cloud-summary"><span><?=count($entries)-$folders?> plików</span><span><?=$folders?> folderów</span><span><?=cloud_size((int)$total)?></span></div></div>
<?php if(isset($_SESSION['login_warning'])): $warning=$_SESSION['login_warning'];unset($_SESSION['login_warning']); ?>
<div class="alert alert-danger" role="alert">Uwaga: wykryto trzy błędne próby logowania na Twoje konto. Ostatnie zdarzenie: <?=h(cloud_time($warning['datetime']))?>, IP: <?=h($warning['ipaddress'])?>.</div>
<?php endif; ?>
<?php if(isset($_SESSION['cloud_flash'])): $flash=$_SESSION['cloud_flash'];unset($_SESSION['cloud_flash']); ?>
<div class="alert alert-<?=h($flash['type'])?>" role="status"><?=h($flash['message'])?></div>
<?php endif; ?>
<section class="card cloud-disk"><div class="card-body p-3 p-md-4">
<div class="cloud-toolbar mb-4"><nav aria-label="Ścieżka folderu"><ol class="breadcrumb mb-0"><li class="breadcrumb-item<?=$dir===''?' active':''?>"><?php if($dir===''): ?>Mój dysk<?php else: ?><a href="drive.php">Mój dysk</a><?php endif; ?></li><?php if($dir!==''): ?><li class="breadcrumb-item active" aria-current="page"><?=h($dir)?></li><?php endif; ?></ol></nav>
<div class="btn-group" role="group" aria-label="Sposób wyświetlania"><a class="btn btn-sm btn-outline-light<?=$mode==='list'?' active':''?>" href="<?=h(cloud_url('drive.php',['dir'=>$dir,'view'=>'list']))?>"<?=$mode==='list'?' aria-current="true"':''?>>☰ Lista</a><a class="btn btn-sm btn-outline-light<?=$mode==='preview'?' active':''?>" href="<?=h(cloud_url('drive.php',['dir'=>$dir,'view'=>'preview']))?>"<?=$mode==='preview'?' aria-current="true"':''?>>▦ Podgląd</a></div></div>
<div class="cloud-controls mb-4">
<?php if($dir===''): ?>
<form method="post" action="cloud_action.php" class="cloud-folder-form"><input type="hidden" name="csrf" value="<?=h($csrf)?>"><input type="hidden" name="action" value="mkdir"><input type="hidden" name="dir" value=""><label for="folder-name" class="form-label">Nowy folder</label><div class="input-group"><input class="form-control" id="folder-name" name="name" placeholder="Nazwa folderu" required maxlength="255"><button class="btn btn-outline-primary" type="submit">📁 Utwórz folder</button></div></form>
<?php else: ?><a class="btn btn-outline-light align-self-end" href="drive.php" aria-label="Poziom wyżej, do katalogu głównego">⬆ Poziom wyżej</a><?php endif; ?>
<form method="post" action="cloud_action.php" enctype="multipart/form-data" class="cloud-upload-form"><input type="hidden" name="csrf" value="<?=h($csrf)?>"><input type="hidden" name="action" value="upload"><input type="hidden" name="dir" value="<?=h($dir)?>"><label for="cloud-files" class="form-label">Prześlij pliki<?=$dir!==''?' do tego folderu':''?></label><div class="input-group"><input class="form-control" type="file" id="cloud-files" name="files[]" multiple required><button class="btn btn-primary" type="submit">⬆ Prześlij</button></div><p class="form-text mb-0">Dowolny typ pliku. Pliki o tej samej nazwie nie są nadpisywane.</p><p class="cloud-upload-status form-text mb-0" role="status"></p></form>
</div>
<?php if(!$entries): ?>
<div class="cloud-empty"><span class="cloud-empty-icon" aria-hidden="true">☁</span><h2 class="h4">Ten folder jest pusty</h2><p class="text-body-secondary mb-0">Prześlij pierwszy plik<?=$dir===''?' lub utwórz folder':''?>.</p></div>
<?php else: ?>
<div class="table-responsive"><table class="table align-middle cloud-table mb-0"><thead><tr><th scope="col">Nazwa</th><th scope="col">Rozmiar</th><th scope="col">Zmodyfikowano</th><th scope="col" class="text-end">Operacje</th></tr></thead><tbody>
<?php foreach($entries as $entry): $relative=($dir!==''?$dir.'/':'').$entry['name'];$url=cloud_url('cloud_file.php',['path'=>$relative]);$preview=cloud_url('cloud_file.php',['path'=>$relative,'inline'=>'1']); ?>
<tr><td class="cloud-name"><?php if($entry['dir']): ?><a class="cloud-entry-link" href="<?=h(cloud_url('drive.php',['dir'=>$entry['name']]))?>"><span aria-hidden="true">📁</span><span><?=h($entry['name'])?></span></a><?php else: ?><a class="cloud-entry-link" href="<?=h($url)?>"><span aria-hidden="true"><?=str_starts_with($entry['mime']??'','image/')?'🖼':(str_starts_with($entry['mime']??'','audio/')?'🎵':(str_starts_with($entry['mime']??'','video/')?'🎬':'📄'))?></span><span><?=h($entry['name'])?></span></a>
<?php if($mode==='preview'&&$entry['mime']): ?>
<div class="cloud-preview mt-2"><?php if(str_starts_with($entry['mime'],'image/')): ?><a href="<?=h($preview)?>" target="_blank" rel="noopener" aria-label="Otwórz podgląd <?=h($entry['name'])?>"><img class="cloud-thumbnail" src="<?=h($preview)?>" alt="Podgląd <?=h($entry['name'])?>" loading="lazy"></a><?php elseif(str_starts_with($entry['mime'],'audio/')): ?><audio controls preload="none" src="<?=h($preview)?>">Twoja przeglądarka nie obsługuje audio.</audio><?php else: ?><video controls preload="none" playsinline src="<?=h($preview)?>">Twoja przeglądarka nie obsługuje wideo.</video><?php endif; ?></div>
<?php endif; ?>
<?php endif; ?></td><td class="text-nowrap text-body-secondary"><?=$entry['dir']?'—':cloud_size((int)$entry['size'])?></td><td class="text-nowrap text-body-secondary"><time datetime="<?=gmdate('c',$entry['time'])?>"><?=h(cloud_time(gmdate('Y-m-d H:i:s',$entry['time'])))?></time></td><td class="text-end"><div class="cloud-row-actions"><?php if(!$entry['dir']): ?><a class="btn btn-outline-light btn-sm" href="<?=h($url)?>" aria-label="Pobierz <?=h($entry['name'])?>">⬇ <span class="d-none d-md-inline">Pobierz</span></a><?php endif; ?><form method="post" action="cloud_action.php" class="cloud-delete"><input type="hidden" name="csrf" value="<?=h($csrf)?>"><input type="hidden" name="action" value="delete"><input type="hidden" name="dir" value="<?=h($dir)?>"><input type="hidden" name="name" value="<?=h($entry['name'])?>"><button class="btn btn-outline-danger btn-sm" type="submit" aria-label="Usuń <?=h($entry['name'])?>">🗑 <span class="d-none d-md-inline">Usuń</span></button></form></div></td></tr>
<?php endforeach; ?>
</tbody></table></div>
<?php endif; ?>
</div></section>
<p class="small text-body-secondary mt-3">Pliki są widoczne wyłącznie na Twoim koncie. Aby usunąć folder, najpierw usuń jego zawartość.</p>
<?php foot(); ?>
