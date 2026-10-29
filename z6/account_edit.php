<?php
declare(strict_types=1);
require __DIR__.'/common.php';
$user=cloud_user();
$_SESSION['account_csrf']??=bin2hex(random_bytes(32));
if(($_SERVER['REQUEST_METHOD']??'')==='POST'){
    $d=null;$newPath=null;$committed=false;
    try{
        if(!hash_equals($_SESSION['account_csrf'],posted('csrf'))){http_response_code(403);exit('Formularz wygasł. Odśwież stronę.');}
        $new=posted('new_password');$repeat=posted('password_repeat');$remove=posted('remove_avatar')==='1';
        if($new!==''&&(mb_strlen($new,'UTF-8')<4||mb_strlen($new,'UTF-8')>20))throw new InvalidArgumentException('Nowe hasło musi mieć od 4 do 20 znaków.');
        if($new!==$repeat)throw new InvalidArgumentException('Nowe hasła różnią się.');
        $file=$_FILES['avatar']??null;
        if($file!==null&&(!is_array($file)||!is_int($file['error']??null)))throw new InvalidArgumentException('Nieprawidłowy avatar.');
        $upload=$file!==null&&$file['error']!==UPLOAD_ERR_NO_FILE;
        if($remove&&$upload)throw new InvalidArgumentException('Wybierz nowy avatar albo usunięcie obecnego.');
        if($new===''&&!$remove&&!$upload)throw new InvalidArgumentException('Wprowadź nowe hasło lub zmień avatar.');
        $d=db();$d->begin_transaction();
        $s=$d->prepare('SELECT password,avatar FROM z6_users WHERE id=? FOR UPDATE');$s->bind_param('i',$user['id']);$s->execute();$record=$s->get_result()->fetch_assoc();$s->close();
        $current=posted('current_password');
        if(!$record||$current===''||!(password_verify($current,$record['password'])||(password_get_info($record['password'])['algo']===null&&hash_equals($record['password'],$current))))throw new InvalidArgumentException('Obecne hasło jest nieprawidłowe.');
        $avatar=$remove?null:$record['avatar'];$oldAvatar=$record['avatar'];
        if($upload){
            if($file['error']!==UPLOAD_ERR_OK||!is_string($file['tmp_name']??null)||!is_uploaded_file($file['tmp_name']))throw new InvalidArgumentException('Nie udało się przesłać avatara.');
            if(filesize($file['tmp_name'])>2*1024*1024)throw new InvalidArgumentException('Avatar może mieć maksymalnie 2 MB.');
            $mime=(new finfo(FILEINFO_MIME_TYPE))->file($file['tmp_name']);$size=@getimagesize($file['tmp_name']);
            if(!in_array($mime,['image/png','image/jpeg','image/webp'],true)||!$size||$size[0]>2048||$size[1]>2048)throw new InvalidArgumentException('Wybierz PNG, JPG lub WebP do 2048 × 2048 px.');
            $src=@imagecreatefromstring(file_get_contents($file['tmp_name']));if($src===false)throw new InvalidArgumentException('Obraz jest uszkodzony.');
            $dest=imagecreatetruecolor(256,256);imagealphablending($dest,false);imagesavealpha($dest,true);$side=min($size[0],$size[1]);
            imagecopyresampled($dest,$src,0,0,(int)(($size[0]-$side)/2),(int)(($size[1]-$side)/2),256,256,$side,$side);
            $avatar=bin2hex(random_bytes(32)).'.png';$newPath=__DIR__.'/media/avatars/'.$avatar;
            $saved=imagepng($dest,$newPath);imagedestroy($src);imagedestroy($dest);if(!$saved)throw new RuntimeException('Błąd zapisu avatara.');
        }
        $password=$new!==''?password_hash($new,PASSWORD_DEFAULT):$record['password'];
        $s=$d->prepare('UPDATE z6_users SET password=?,avatar=? WHERE id=?');$s->bind_param('ssi',$password,$avatar,$user['id']);$s->execute();$s->close();$d->commit();$committed=true;
        if($oldAvatar!==$avatar&&is_string($oldAvatar)&&preg_match('/\A[a-f0-9]{64}\.png\z/D',$oldAvatar)){
            $s=$d->prepare('SELECT COUNT(*) FROM z6_users WHERE avatar=?');$s->bind_param('s',$oldAvatar);$s->execute();$count=(int)$s->get_result()->fetch_row()[0];$s->close();
            if($count===0&&is_file(__DIR__.'/media/avatars/'.$oldAvatar))@unlink(__DIR__.'/media/avatars/'.$oldAvatar);
        }
        $d->close();$d=null;session_regenerate_id(true);unset($_SESSION['account_csrf']);
        $_SESSION['account_flash']=['type'=>'success','message'=>'Zmiany na koncie zostały zapisane.'];redirect('index4.php');
    }catch(Throwable $e){
        if($d!==null){if(!$committed)$d->rollback();$d->close();}
        if(!$committed&&$newPath!==null&&is_file($newPath))unlink($newPath);
        $_SESSION['account_flash']=['type'=>$committed?'success':'danger','message'=>$committed?'Zmiany na koncie zostały zapisane.':($e instanceof InvalidArgumentException?$e->getMessage():'Nie udało się zapisać zmian. Spróbuj ponownie.')];
        if(!$e instanceof InvalidArgumentException)error_log('MyCloud account edit: '.get_class($e));
        redirect($committed?'index4.php':'account_edit.php');
    }
}
head('Edytuj konto');
if(isset($_SESSION['account_flash'])){$f=$_SESSION['account_flash'];unset($_SESSION['account_flash']);echo '<div class="alert alert-'.h($f['type']).'" role="status">'.h($f['message']).'</div>';}
?>
<form method="post" action="account_edit.php" enctype="multipart/form-data">
<input type="hidden" name="csrf" value="<?=h($_SESSION['account_csrf'])?>">
<div class="row g-4"><div class="col-12 col-md-7"><section class="card"><div class="card-body p-4">
<h2 class="h5 mb-3">Dane konta</h2>
<label class="form-label" for="account-login">Login</label><input class="form-control" id="account-login" value="<?=h($user['username'])?>" readonly aria-describedby="account-login-help"><p class="form-text" id="account-login-help">Login jest nazwą Twojego prywatnego katalogu i pozostaje stały.</p>
<label class="form-label" for="current-password">Obecne hasło</label><input class="form-control mb-3" type="password" id="current-password" name="current_password" autocomplete="current-password" required>
<label class="form-label" for="new-password">Nowe hasło</label><input class="form-control" type="password" id="new-password" name="new_password" autocomplete="new-password" minlength="4" maxlength="20" aria-describedby="new-password-help"><p class="form-text" id="new-password-help">4–20 znaków. Zostaw puste, jeśli zmieniasz tylko avatar.</p>
<label class="form-label" for="password-repeat">Powtórz nowe hasło</label><input class="form-control mb-4" type="password" id="password-repeat" name="password_repeat" autocomplete="new-password" minlength="4" maxlength="20">
<button class="btn btn-primary" type="submit">Zapisz zmiany</button> <a class="btn btn-outline-light" href="index4.php">Anuluj</a>
</div></section></div><div class="col-12 col-md-5"><section class="card"><div class="card-body p-4">
<h2 class="h5">Avatar</h2><img class="avatar avatar-preview d-block my-3" id="avatarPreview" src="<?=h(avatar_url($user['avatar']))?>" alt="Podgląd avatara">
<label class="form-label" for="avatar">Wybierz nowy obraz</label><input class="form-control" type="file" id="avatar" name="avatar" accept="image/png,image/jpeg,image/webp" aria-describedby="avatarHelp"><div class="form-text" id="avatarHelp">PNG, JPG lub WebP, do 2 MB i 2048 × 2048 px.</div>
<?php if($user['avatar']!==null): ?><div class="form-check mt-3"><input class="form-check-input" type="checkbox" id="remove-avatar" name="remove_avatar" value="1"><label class="form-check-label" for="remove-avatar">Usuń obecny avatar</label></div><?php endif; ?>
</div></section></div></div></form>
<?php foot(); ?>
