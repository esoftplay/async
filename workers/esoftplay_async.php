<?php

$mgr->addHandler('esoftplay_async', function ($string, GearmanJob $job) {
	shell_exec(PHP_BINARY.' /var/www/html/binary/includes/class/async.php \''.$string.'\'');
});