<?php
/**
 * Created by PhpStorm.
 * User: esoftplay
 * Date: 2017/5/11
 * Time: 下午11:42
 */

namespace esoftplay\gearman\jobs;

use esoftplay\gearman\tools\FileLogger;

/**
 * Class UseLogJob
 * @package esoftplay\gearman\jobs
 */
abstract class UseLogJob extends Job
{
    /**
     * {@inheritDoc}
     */
    protected function beforeRun($workload, \GearmanJob $job)
    {
        $this->info("workload=$workload");
    }

    /**
     * {@inheritDoc}
     */
    protected function onException(\Exception $e)
    {
        $this->err("Error({$e->getCode()}): {$e->getMessage()} \nTrace \n" . $e->getTraceAsString());
    }

    /**
     * @param $msg
     * @param array $data
     */
    protected function debug($msg, array $data = [])
    {
        FileLogger::debug("id={$this->id} " . $msg, $data, $this->name);
    }

    /**
     * @param $msg
     * @param array $data
     */
    protected function info($msg, array $data = [])
    {
        FileLogger::info("id={$this->id} " . $msg, $data, $this->name);
    }

    /**
     * @param $msg
     * @param array $data
     */
    protected function err($msg, array $data = [])
    {
        FileLogger::err("id={$this->id} " . $msg, $data, $this->name);
    }
}
