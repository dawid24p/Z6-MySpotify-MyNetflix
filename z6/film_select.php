<?php
declare(strict_types=1);
require __DIR__.'/common.php';cloud_user();$d=db();$genres=$d->query('SELECT * FROM z6v_filmtype ORDER BY idft')->fetch_all(MYSQLI_ASSOC);$d->close();head('Dodaj film');video_toolbar('film_select.php');
?>
<form class="card video-upload" method="post" action="film_upload.php" enctype="multipart/form-data"><div class="card-body p-4"><input type="hidden" name="csrf" value="<?=h(video_csrf())?>"><div class="row g-4"><div class="col-12 col-lg-7">
<label class="form-label" for="film-file">Plik MP4</label><input class="form-control mb-4" type="file" id="film-file" name="film" accept=".mp4,video/mp4" required>
<label class="form-label" for="film-title">Tytuł</label><input class="form-control mb-3" id="film-title" name="title" maxlength="250" required>
<label class="form-label" for="film-director">Reżyser</label><input class="form-control mb-3" id="film-director" name="director" maxlength="250" required>
<label class="form-label" for="film-genre">Gatunek</label><select class="form-select mb-4" id="film-genre" name="genre" required><option value="">Wybierz gatunek</option><?php foreach($genres as $g): ?><option value="<?=$g['idft']?>"><?=h($g['name'])?></option><?php endforeach; ?></select>
<label class="form-label" for="film-description">Opis filmu (opcjonalnie)</label><textarea class="form-control mb-4" rows="4" id="film-description" name="description" maxlength="10000"></textarea><button class="btn btn-primary" type="submit">Dodaj film</button> <a class="btn btn-outline-light" href="films.php">Anuluj</a><p id="video-upload-status" class="form-text mt-2" role="status"></p></div><div class="col-12 col-lg-5">
<label class="form-label" for="film-cover">Okładka (opcjonalnie)</label><input class="form-control mb-4" type="file" id="film-cover" name="cover" accept="image/png,image/jpeg,image/webp">
<label class="form-label" for="film-subtitles">Napisy (opcjonalnie)</label><textarea class="form-control mb-3" rows="8" id="film-subtitles" name="subtitles" maxlength="60000"></textarea><label class="form-label" for="subtitle-file">Lub plik napisów SRT / VTT</label><input class="form-control" type="file" id="subtitle-file" name="subtitle_file" accept=".srt,.vtt,text/vtt,text/plain">
</div></div></div></form>
<?php foot(); ?>
