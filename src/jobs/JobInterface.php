<?php
/**
 * Created by PhpStorm.
 * User: esoftplay
 * Date: 2017-04-27
 * Time: 16:06
 */

namespace esoftplay\gearman\jobs;

/**
 * Class JobInterface
 * @package esoftplay\gearman\jobs
 */
interface JobInterface
{
    /**
     * do the job
     * @param string $workload
     * @param \GearmanJob $job
     * -param ManagerInterface $manager
     * @return mixed
     */
    public function run($workload, \GearmanJob $job);
}
