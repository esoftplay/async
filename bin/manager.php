<?php
use \esoftplay\gearman\Manager;
use esoftplay\gearman\tools\FileLogger;

error_reporting(E_ALL | E_STRICT);
date_default_timezone_set('Asia/Jakarta');
define('ROOT_PATH', dirname(__DIR__));
define('LOG_PATH', ROOT_PATH.'/logs');

spl_autoload_register(function($class)
{
    // e.g. "esoftplay\gearman\examples\jobs\TestJob"
    if (0 === strpos($class,'esoftplay\\gearman\\examples\\')) {
        $path = str_replace('\\', '/', substr($class, strlen('esoftplay\\gearman\\examples\\')));
        $file = ROOT_PATH . "examples/{$path}.php";

        if (is_file($file)) {
            include $file;
        }
    // e.g. "esoftplay\gearman\Helper"
    } elseif (0 === strpos($class,'esoftplay\\gearman\\')) {
        $path = str_replace('\\', '/', substr($class, strlen('esoftplay\\gearman\\')));
        $file = ROOT_PATH . "/src/{$path}.php";

        if (is_file($file)) {
            include $file;
        }
    }
});



$config = [
    'name' => 'esoftplay',
    'daemon' => true,
    'pid_file' => LOG_PATH . '/esoftplay.pid',

    'log_level' => Manager::LOG_DEBUG,
    'log_file' => LOG_PATH . '/esoftplay.log',

    'stat_file' => LOG_PATH . '/stat.json',
    'loader_file' => ROOT_PATH . '/workers/esoftplay_async.php',
    'worker_num' => 5
];
$mgr = new Manager($config);
$mgr->start();
