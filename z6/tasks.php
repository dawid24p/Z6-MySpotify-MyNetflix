<?php
declare(strict_types=1);
require __DIR__.'/common.php';
$user=cloud_user();$tasks=require __DIR__.'/task_menu.php';
$selected=$_GET['task']??null;
if($selected!==null&&(!is_string($selected)||!preg_match('/\A[1-6]\z/D',$selected))){http_response_code(404);head('Nie znaleziono zadania');echo '<a class="btn btn-primary" href="tasks.php">Wszystkie zadania</a>';foot();exit;}
if($selected===null){
    head('Panel zadań');
    echo '<p class="text-body-secondary mb-4">Wybierz zadanie, aby zobaczyć dostępne funkcje.</p><div class="row g-3">';
    foreach($tasks as $number=>$task){
        echo '<div class="col-12 col-sm-6 col-lg-4"><a class="btn btn-outline-primary text-start p-4 w-100 h-100" href="tasks.php?task='.$number.'"><span class="h4 d-block mb-2">Zadanie '.$number.'</span><span>'.h($task['title']).'</span></a></div>';
    }
    echo '</div>';
}else{
    $task=$tasks[(int)$selected];$admin=in_array($user['username'],['admin','Dawid24p'],true);
    head('Zadanie '.$selected.' — '.$task['title']);
    echo '<a class="btn btn-outline-light mb-4" href="tasks.php">← Wszystkie zadania</a><div class="row g-3">';
    foreach($task['items'] as $item){
        if(($item['admin']??false)&&!$admin)continue;
        if(isset($item['heading'])){echo '<div class="col-12"><h2 class="h5 mt-3 mb-0">'.h($item['heading']).'</h2></div>';continue;}
        echo '<div class="col-12 col-sm-6 col-lg-4"><a class="btn btn-outline-primary text-start p-4 w-100 h-100" href="'.h($item['href']).'">'.h($item['label']).'</a></div>';
    }
    echo '</div>';
}
foot();
