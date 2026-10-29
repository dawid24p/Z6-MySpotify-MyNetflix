<?php
declare(strict_types=1);
require __DIR__.'/common.php';cloud_user();$d=db();$genres=$d->query('SELECT * FROM z6_musictype ORDER BY idmt')->fetch_all(MYSQLI_ASSOC);$d->close();head('Dodaj utwór');music_toolbar('select.php');
?>
<form class="card music-upload" method="post" action="upload.php" enctype="multipart/form-data"><div class="card-body p-4">
<input type="hidden" name="csrf" value="<?=h(music_csrf())?>">
<div class="row g-4"><div class="col-12 col-lg-7">
<label class="form-label" for="song-file">Plik MP3</label><input class="form-control mb-2" type="file" id="song-file" name="song" accept=".mp3,audio/mpeg" required><p class="form-text mb-4" id="tag-status" role="status">Tytuł, wykonawca i gatunek zostaną uzupełnione, jeśli plik zawiera tagi.</p>
<label class="form-label" for="song-title">Tytuł</label><input class="form-control mb-3" id="song-title" name="title" maxlength="250" required>
<label class="form-label" for="song-musician">Wykonawca</label><input class="form-control mb-3" id="song-musician" name="musician" maxlength="250" required>
<label class="form-label" for="song-album">Album</label><input class="form-control mb-3" id="song-album" name="album" maxlength="250">
<label class="form-label" for="song-genre">Gatunek</label><select class="form-select mb-4" id="song-genre" name="genre" required><option value="">Wybierz gatunek</option><?php foreach($genres as $g): ?><option value="<?=$g['idmt']?>"><?=h($g['name'])?></option><?php endforeach; ?></select>
<button class="btn btn-primary" type="submit">Dodaj utwór</button> <a class="btn btn-outline-light" href="music.php">Anuluj</a>
</div><div class="col-12 col-lg-5"><label class="form-label" for="song-cover">Okładka (opcjonalnie)</label><input class="form-control mb-2" type="file" id="song-cover" name="cover" accept="image/png,image/jpeg,image/webp"><p class="form-text mb-4">Wybierz własne zdjęcie lub pozostaw okładkę z tagów MP3.</p><label class="form-label" for="song-lyrics">Tekst utworu <span class="text-body-secondary">(opcjonalnie)</span></label><textarea class="form-control" rows="13" id="song-lyrics" name="lyrics" maxlength="16000"></textarea></div></div>
</div></form>
<?php foot(); ?>
