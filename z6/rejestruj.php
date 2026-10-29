<?php declare(strict_types=1);
require __DIR__.'/common.php';start_session();$_SESSION['csrf']??=bin2hex(random_bytes(32));head('Rejestracja nowego użytkownika');
if(isset($_SESSION['registration_flash'])){echo '<div class="alert alert-warning" role="status">'.h($_SESSION['registration_flash']).'</div>';unset($_SESSION['registration_flash']);}
?>
<form method="post" action="add.php" enctype="multipart/form-data">
<input type="hidden" name="csrf" value="<?=h($_SESSION['csrf'])?>">
<div class="row g-4"><div class="col-12 col-md-8 col-lg-7"><section class="card"><div class="card-body p-4">
<h2 class="h5 mb-4">Dane konta</h2>
<label class="form-label" for="user">Login</label><input class="form-control mb-1" type="text" id="user" name="user" minlength="3" maxlength="20" pattern="[A-Za-z0-9_.-]{3,20}" autocomplete="username" aria-describedby="loginHelp" required>
<div class="form-text mb-3" id="loginHelp">3–20 liter, cyfr, kropek, podkreśleń lub myślników.</div>
<label class="form-label" for="pass">Hasło</label><input class="form-control mb-1" type="password" id="pass" name="pass" minlength="4" maxlength="20" autocomplete="new-password" aria-describedby="passwordHelp" required>
<div class="form-text mb-3" id="passwordHelp">Od 4 do 20 znaków.</div>
<label class="form-label" for="pass_repeat">Powtórz hasło</label><input class="form-control mb-4" type="password" id="pass_repeat" name="pass_repeat" minlength="4" maxlength="20" autocomplete="new-password" required>
<button class="btn btn-primary" type="submit">Zarejestruj</button> <a class="btn btn-link" href="index3.php">Mam już konto</a>
</div></section></div><div class="col-12 col-md-4 col-lg-5"><section class="card"><div class="card-body p-4">
<h2 class="h5">Avatar <span class="badge text-bg-secondary">opcjonalny</span></h2>
<img class="avatar avatar-preview d-block my-3" id="avatarPreview" src="media/default-avatar.svg" alt="Podgląd avataru">
<label class="form-label" for="avatar">Wybierz obraz</label><input class="form-control" id="avatar" type="file" name="avatar" accept="image/png,image/jpeg,image/webp" aria-describedby="avatarHelp">
<div class="form-text" id="avatarHelp">PNG, JPG lub WebP, do 2 MB i 2048 × 2048 px. Bez pliku otrzymasz domyślną ikonę.</div>
</div></section></div></div>
</form>
<?php foot(); ?>