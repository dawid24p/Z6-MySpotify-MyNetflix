<?php declare(strict_types=1);
require __DIR__.'/common.php';
if(($_SERVER['REQUEST_METHOD']??'')!=='POST')redirect('rejestruj.php');
start_session();$user=posted('user');$pass=posted('pass');$repeat=posted('pass_repeat');$avatar=null;$path=null;$link=null;$newHome=null;
try {
    if(!isset($_SESSION['csrf'])||!hash_equals($_SESSION['csrf'],posted('csrf')))throw new InvalidArgumentException('Formularz wygasł. Spróbuj ponownie.');
    if(!preg_match('/\A[A-Za-z0-9_.-]{3,20}\z/D',$user))throw new InvalidArgumentException('Login musi mieć od 3 do 20 dozwolonych znaków.');
    if(mb_strlen($pass,'UTF-8')<4||mb_strlen($pass,'UTF-8')>20)throw new InvalidArgumentException('Hasło musi mieć od 4 do 20 znaków.');
    if($pass!==$repeat)throw new InvalidArgumentException('Podane hasła różnią się.');
    $file=$_FILES['avatar']??null;
    if($file!==null && (!is_array($file)||!isset($file['error'])||!is_int($file['error'])))throw new InvalidArgumentException('Nieprawidłowy plik avataru.');
    if($file!==null && $file['error']!==UPLOAD_ERR_NO_FILE){
        if($file['error']!==UPLOAD_ERR_OK)throw new InvalidArgumentException('Nie udało się przesłać avataru.');
        if(!is_string($file['tmp_name'])||!is_uploaded_file($file['tmp_name'])||filesize($file['tmp_name'])>2*1024*1024)throw new InvalidArgumentException('Avatar może mieć maksymalnie 2 MB.');
        $mime=(new finfo(FILEINFO_MIME_TYPE))->file($file['tmp_name']);$size=@getimagesize($file['tmp_name']);
        if(!in_array($mime,['image/png','image/jpeg','image/webp'],true)||!$size||$size[0]>2048||$size[1]>2048)throw new InvalidArgumentException('Wybierz PNG, JPG lub WebP do 2048 × 2048 px.');
        $src=@imagecreatefromstring(file_get_contents($file['tmp_name']));
        if($src===false)throw new InvalidArgumentException('Obraz avataru jest uszkodzony.');
        
        $dest=imagecreatetruecolor(256,256);imagealphablending($dest,false);imagesavealpha($dest,true);
        $side=min($size[0],$size[1]);imagecopyresampled($dest,$src,0,0,(int)(($size[0]-$side)/2),(int)(($size[1]-$side)/2),256,256,$side,$side);
        $avatar=bin2hex(random_bytes(32)).'.png';$path=__DIR__.'/media/avatars/'.$avatar;
        if(!imagepng($dest,$path)){imagedestroy($src);imagedestroy($dest);throw new RuntimeException('Błąd zapisu avataru');}
        imagedestroy($src);imagedestroy($dest);
    }
    $pass=password_hash($pass,PASSWORD_DEFAULT);
    $link=db();$link->begin_transaction();
    $s=$link->prepare('INSERT INTO z6_users (username,password,avatar) VALUES (?,?,?)');$s->bind_param('sss',$user,$pass,$avatar);$s->execute();$s->close();
    $candidate=CLOUD_STORAGE.'/'.$user;
    if(file_exists($candidate)||is_link($candidate))throw new RuntimeException('Katalog tego użytkownika już istnieje.');
    $newHome=cloud_home_for($user);
    $link->commit();$link->close();$link=null;
    unset($_SESSION['csrf']);$_SESSION['flash']='Konto zostało utworzone. Możesz się zalogować.';redirect('index3.php');
} catch(Throwable $e) {
    if($link!==null){$link->rollback();$link->close();}
    if($path!==null && is_file($path))unlink($path);
    if($newHome!==null && is_dir($newHome))rmdir($newHome);
    if($e instanceof InvalidArgumentException)$_SESSION['registration_flash']=$e->getMessage();
    elseif($e instanceof mysqli_sql_exception && $e->getCode()===1062)$_SESSION['registration_flash']='Ten login jest już zajęty.';
    else {error_log('PAS z2: błąd rejestracji ('.get_class($e).')');$_SESSION['registration_flash']='Nie udało się utworzyć konta. Spróbuj później.';}
    redirect('rejestruj.php');
}