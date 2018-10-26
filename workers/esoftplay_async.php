<?php

$mgr->addHandler('esoftplay_async', function ($string, GearmanJob $job) {
	if (file_exists('/var/www/html/master/includes/class/async.php'))
	{
		shell_exec(PHP_BINARY.' /var/www/html/master/includes/class/async.php \''.$string.'\'');
	}
});