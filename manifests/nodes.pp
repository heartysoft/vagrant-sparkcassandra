
$seeds = '192.168.40.2,192.168.40.3'
$spark_master = '192.168.40.4'

#fix needed for puppet 3.7
#include puppet_templatedir_fix

node 'spark1', 'spark2' {
	class { 'jdk': }

	#package { 'libjna-java':
	#	ensure => "installed",
	#	before => Class["cassandra"],
	#}
	->
	class { 'cassandra':
		seeds => $seeds,
		cassyVersion => "2.1.0",
		downloadUrl => "http://mirror.ox.ac.uk/sites/rsync.apache.org/cassandra/2.1.0/apache-cassandra-2.1.0-bin.tar.gz",
		listen_address => $::ipaddress_eth1,
		broadcast_address => $::ipaddress_eth1,
		#rpc_address => "0.0.0.0",
		downloadDir => "/vagrant/cassandra",
		dc => 'dev1',
		rack => 'devrack1',
		backup_root => '/mnt/backups/cassandra',
	}
	->
	class { 'spark':
		mode => 'worker',
		master_node => $spark_master,
		download_dir => '/vagrant/spark',
	}
}

node 'spark3' {
	class { 'jdk': }
	->
	class { 'spark':
		mode => 'master',
		master_node => $ipaddress_eth1,
		download_dir => '/vagrant/spark',
	}
}

