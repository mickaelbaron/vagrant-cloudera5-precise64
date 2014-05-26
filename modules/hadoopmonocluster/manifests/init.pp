class hadoopmonocluster::prepare {
  exec { "apt-update":
     command => "/usr/bin/apt-get -y update",
     timeout => 3600;
  }
  
  package {
    ["openjdk-7-jdk", "curl"]:
    ensure => installed;
  }
  
  exec { 
	"addgrouphadoop":
		command => "/usr/sbin/addgroup hadoop",
		timeout => 0;
	"addhdsuer":
		command => "/usr/sbin/adduser --ingroup hadoop --disabled-password --gecos '' hduser",
		timeout => 0,
		require => Exec['addgrouphadoop'];
	"changepassword":
		command => "/bin/echo -e 'hduser\nhduser' | /usr/bin/passwd hduser",
		timeout => 0,
		require => Exec['addhdsuer'];
	"wgetcdh5":                                                                                                                                
		cwd => "/vagrant/modules/files",
		command => "/usr/bin/wget http://archive.cloudera.com/cdh5/one-click-install/precise/amd64/cdh5-repository_1.0_all.deb",
		timeout => 0,
		creates => "/vagrant/modules/files/cdh5-repository_1.0_all.deb",
		require => Exec['addhdsuer'];
	"dpkgcdh5":
		command => "/usr/bin/dpkg -i cdh5-repository_1.0_all.deb",
		cwd => "/vagrant/modules/files",
		timeout => 0,
		require => Exec['wgetcdh5'];
	"curlcdh5":
		command => "/usr/bin/curl -s http://archive.cloudera.com/cdh5/ubuntu/precise/amd64/cdh/archive.key | sudo apt-key add -",
		cwd => "/vagrant/modules/files",
		timeout => 0,
		require => Exec['dpkgcdh5'];
  }    
}

class hadoopmonocluster::install {
  exec { "apt-update-cloudera":
     command => "/usr/bin/apt-get -y update",
     timeout => 3600;
  }

  package {
	["hadoop-yarn-resourcemanager", "hadoop-hdfs-namenode", "hadoop-yarn-nodemanager", "hadoop-hdfs-datanode", "hadoop-mapreduce", "hadoop-mapreduce-historyserver"]:
	ensure => installed,
	require => Exec['apt-update-cloudera'];
  }
  
  service {
	["hadoop-hdfs-datanode", "hadoop-hdfs-namenode", "hadoop-yarn-nodemanager", "hadoop-yarn-resourcemanager"]:
	ensure=> "stopped";
  }
}

class hadoopmonocluster::postinstall {
	file { 
	"/etc/hadoop/conf/core-site.xml":
		ensure => present,
		source => "puppet:///modules/hadoopmonocluster/core-site.xml";
	"/etc/hadoop/conf/hdfs-site.xml":
		ensure => present,
		source => "puppet:///modules/hadoopmonocluster/hdfs-site.xml";
	"/etc/hadoop/conf/mapred-site.xml":
		ensure => present,
		source => "puppet:///modules/hadoopmonocluster/mapred-site.xml";
	"/home/vagrant/hadoop-start":
		ensure => present,
		source => "puppet:///modules/hadoopmonocluster/hadoop-start",
		mode => 777;
	"/home/vagrant/hadoop-stop":
		ensure => present,
		source => "puppet:///modules/hadoopmonocluster/hadoop-stop",
		mode => 777;
	}
}
