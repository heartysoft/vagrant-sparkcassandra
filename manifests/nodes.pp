
$spark_master = '192.168.40.2'
$seeds = '192.168.40.3,192.168.40.4'


#fix needed for puppet 3.7
#include puppet_templatedir_fix

node 'spark1' {
	host { "${spark_driver_hostname}":
		ip => "${spark_driver_ip}"
	}
	->
	class { 'jdk': }
	->
	class { 'spark':
		mode => 'master',
		master_node => $ipaddress_eth1,
		download_dir => '/vagrant/spark',
        version => 'spark-1.2.1-bin-hadoop2.4',
	}
}

node 'spark2', 'spark3' {
	host { "${spark_driver_hostname}":
		ip => "${spark_driver_ip}"
	}
	->
	class { 'jdk': }

	#package { 'libjna-java':
	#	ensure => "installed",
	#	before => Class["cassandra"],
	#}
	->
	class { 'spark':
		mode => 'worker',
		master_node => $spark_master,
		download_dir => '/vagrant/spark',
		max_worker_cores => 2,
		max_worker_ram => 1G,
        version => 'spark-1.2.1-bin-hadoop2.4',
	}
	->
	class { 'cassandra':
		seeds => $seeds,
		cassyVersion => "2.1.2",
		downloadUrl => "http://mirror.ox.ac.uk/sites/rsync.apache.org/cassandra/2.1.4/apache-cassandra-2.1.4-bin.tar.gz",
		listen_address => $::ipaddress_eth1,
		broadcast_address => $::ipaddress_eth1,
		rpc_address => $::ipaddress_eth1,
		downloadDir => "/vagrant/cassandra",
		dc => 'dev1',
		rack => 'devrack1',
		backup_root => '/mnt/backups/cassandra',
	}
}


