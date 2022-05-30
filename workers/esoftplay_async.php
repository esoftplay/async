<?php

$mgr->addHandler('esoftplay_async', function ($string, GearmanJob $job) {
	if (file_exists('/var/www/html/master/includes/class/async.php'))
	{
		$string = str_replace("'", "&#39;", $string);
		$string = str_replace("\n", "\\\n", $string);
		shell_exec(PHP_BINARY.' /var/www/html/master/includes/class/async.php \''.$string.'\'');
	}
});