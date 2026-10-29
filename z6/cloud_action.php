<?php
declare(strict_types=1);
require __DIR__.'/common.php';
cloud_user();cloud_post();
$dir='';$lock=null;$moved=[];
try{
    $dir=cloud_relative(posted('dir'),1);$lock=cloud_lock();$current=cloud_resolve($dir,true);
    $action=posted('action');
    if($action==='mkdir'){
        if($dir!=='')throw new InvalidArgumentException('Nowe foldery można tworzyć tylko w katalogu głównym.');
        $name=cloud_name(posted('name'));$path=$current.'/'.$name;
        if(file_exists($path)||is_link($path))throw new InvalidArgumentException('Plik lub folder o tej nazwie już istnieje.');
        if(!mkdir($path,0700))throw new RuntimeException('Nie udało się utworzyć folderu.');
        $message='Utworzono folder „'.$name.'”.';
    }elseif($action==='delete'){
        $name=cloud_name(posted('name'));$path=cloud_resolve(($dir!==''?$dir.'/':'').$name);
        if(is_dir($path)){
            if(count(scandir($path))>2)throw new InvalidArgumentException('Folder nie jest pusty. Najpierw usuń znajdujące się w nim pliki.');
            if(!rmdir($path))throw new RuntimeException('Nie udało się usunąć folderu.');
        }elseif(is_file($path)){
            if(!unlink($path))throw new RuntimeException('Nie udało się usunąć pliku.');
        }else throw new InvalidArgumentException('Nieprawidłowy plik.');
        $message='Usunięto „'.$name.'”.';
    }elseif($action==='upload'){
        $files=$_FILES['files']??null;
        if(!is_array($files)||!is_array($files['name']??null)||count($files['name'])===0)throw new InvalidArgumentException('Wybierz pliki do przesłania. Jeśli plik jest bardzo duży, sprawdź limit przesyłania na hostingu.');
        $batch=[];
        foreach($files['name'] as $i=>$name){
            if(!is_string($name))throw new InvalidArgumentException('Nieprawidłowy plik.');
            $name=cloud_name($name);$error=$files['error'][$i]??UPLOAD_ERR_NO_FILE;$tmp=$files['tmp_name'][$i]??'';
            if($error!==UPLOAD_ERR_OK){$messages=[UPLOAD_ERR_INI_SIZE=>'Plik przekracza limit przesyłania ustawiony na hostingu.',UPLOAD_ERR_FORM_SIZE=>'Plik przekracza limit formularza.',UPLOAD_ERR_PARTIAL=>'Plik przesłał się tylko częściowo. Spróbuj ponownie.',UPLOAD_ERR_NO_FILE=>'Wybierz plik do przesłania.'];throw new InvalidArgumentException($messages[$error]??'Hosting nie mógł zapisać przesłanego pliku.');}
            if(!is_string($tmp)||!is_uploaded_file($tmp))throw new InvalidArgumentException('Nieprawidłowy plik.');
            $path=$current.'/'.$name;
            if(file_exists($path)||is_link($path)||isset($batch[$name]))throw new InvalidArgumentException('Plik „'.$name.'” już istnieje. Zmień nazwę lub usuń poprzedni plik.');
            $batch[$name]=[$tmp,$path];
        }
        foreach($batch as [$tmp,$path]){
            if(!move_uploaded_file($tmp,$path))throw new RuntimeException('Nie udało się zapisać pliku.');
            $moved[]=$path;chmod($path,0600);
        }
        $message='Przesłano pliki: '.count($batch).'.';
    }else throw new InvalidArgumentException('Nieznana operacja.');
    $_SESSION['cloud_flash']=['type'=>'success','message'=>$message];
}catch(Throwable $e){
    foreach($moved as $path)if(is_file($path))unlink($path);
    $_SESSION['cloud_flash']=['type'=>'danger','message'=>$e instanceof InvalidArgumentException?$e->getMessage():'Operacja nie powiodła się. Spróbuj ponownie.'];
    if(!$e instanceof InvalidArgumentException)error_log('MyCloud operation: '.get_class($e));
}finally{if(is_resource($lock)){flock($lock,LOCK_UN);fclose($lock);}}
redirect(cloud_url('drive.php',['dir'=>$dir]));
