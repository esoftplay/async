<?php
/**
 * php -S 127.0.0.1:5888 -t web
 */

use \esoftplay\gearman\tools\WebPanelHandler;

error_reporting(E_ALL | E_STRICT);
date_default_timezone_set('Asia/Jakarta');
define('ROOT_PATH', dirname(__DIR__));

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

$wph = new WebPanelHandler([
    'basePath' => __DIR__,
    'logPath' => dirname(__DIR__) . '/logs/',
    'logFileName' => 'esoftplay_%s.log',
]);

$route = $wph->get('r');
// $route = 'jobs-info';
// $route = $wph->getServerValue('REQUEST_URI');
// var_dump($route, $_SERVER);


$wph
    ->setRoutes([
        'home' => 'index',
        'proj-info' => 'projInfo',
        'server-info' => 'serverInfo',
        'jobs-info' => 'jobsInfo',
        'job-info' => 'jobDetail',
    ])
    ->dispatch($route);


