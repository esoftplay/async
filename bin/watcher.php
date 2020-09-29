<?php
class aWatcher
{
	protected $host = "127.0.0.1";
	protected $port = 4730;

	public function __construct($host=null,$port=null)
	{
		if( !is_null($host) )
		{
			$this->host = $host;
		}
		if( !is_null($port) )
		{
			$this->port = $port;
		}
	}

	public function clean_db()
	{
		$file = '/root/bin/db_del';
		if (file_exists($file))
		{
			$text = @file_get_contents($file);
			if (!empty($text) && preg_match('~mysqli_connect\(([^\)]+)~is', $text, $match))
			{
				$arr = @json_decode('['.str_replace("'", '"', $match[1]).']', 1);
				if (is_array($arr) && !empty($arr))
				{
					$DBLINK = mysqli_connect($arr[0], $arr[1], $arr[2]);// or die("SQL Error : Cannot login to MySQL");
					if ($DBLINK)
					{
						$result = mysqli_query($DBLINK, 'SHOW FULL PROCESSLIST');
						while ($row=mysqli_fetch_array($result))
						{
							// print_r($row);
							if ($row['Command'] == 'Sleep')
							{
								// echo "\n\n== ".$row['Command']." -- ".$row['Id'];
								$process_id=$row['Id'];
								if ($process_id != 2)
								{
									$q = 'KILL '.$process_id;
									mysqli_query($DBLINK, 'KILL '.$process_id);
									print_r($q);
								}
							}else{
								// echo "\n\n-- ".$row['Command']." -- ".$row['Id'];
							}
							// echo "\n";
						}
						mysqli_close($DBLINK);
					}
				}
			}
		}
	}

	public function getStatus()
	{
		$status = null;
		try {
			$handle = @fsockopen($this->host,$this->port,$errorNumber,$errorString,30);
			if($handle!=null)
			{
				fwrite($handle,"status\n");
				while (!feof($handle))
				{
					$line = fgets($handle, 4096);
					if( $line==".\n")
					{
						break;
					}
					if( preg_match("~^(.*)[ \t](\d+)[ \t](\d+)[ \t](\d+)~",$line,$matches) )
					{
						$function = $matches[1];
						$status['operations'][$function] = array(
							'function'         => $function,
							'total'            => $matches[2],
							'running'          => $matches[3],
							'connectedWorkers' => $matches[4],
						);
					}
				}
				fwrite($handle,"workers\n");
				while (!feof($handle))
				{
					$line = fgets($handle, 4096);
					if( $line==".\n")
					{
						break;
					}
					// FD IP-ADDRESS CLIENT-ID : FUNCTION
					if( preg_match("~^(\d+)[ \t](.*?)[ \t](.*?) : ?(.*)~",$line,$matches) )
					{
						$fd = $matches[1];
						$status['connections'][$fd] = array(
							'fd'       => $fd,
							'ip'       => $matches[2],
							'id'       => $matches[3],
							'function' => $matches[4],
						);
					}
				}
				fclose($handle);
			}
		} catch (Exception $e) {
			// print_r($e);
		}
		return $status;
	}

	public function watcher()
	{
		// $this->clean_db();
		$out = $this->getStatus();
		if (!$out)
		{
			$file = '/usr/local/bin/ars';
			if (file_exists($file))
			{
				shell_exec('/bin/sh '.$file);
			}else{
				file_put_contents($file, '#!/bin/sh'
					."\n".''
					."\n".'SERVERINI=`hostname`'
					."\n".'FILE="/tmp/async-tmp.txt"'
					."\n".'if [ -f "$FILE" ]; then'
					."\n".'	echo "please wait..."'
					."\n".'else'
					."\n".'	echo \'1\' > "$FILE"'
					."\n".'	echo "/etc/init.d/esoftplay_async restart && /usr/local/bin/tm \'restart async di ${SERVERINI} sudah selesai\' -345399808  && /bin/rm -f ${FILE}" >> /tmp/tmp.sh'
					."\n".'fi');
				shell_exec('chown root:root '.$file);
				shell_exec('chmod 755 '.$file);
				shell_exec('chcon system_u:object_r:bin_t:s0 '.$file);
			}
		}
		return $out;
	}
}

$p = new aWatcher();
$r = $p->watcher();
print_r($r);