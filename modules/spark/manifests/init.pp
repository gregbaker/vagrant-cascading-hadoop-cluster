class spark {
  $spark_version = "1.4.0"
  $hadoop_version = "2.6"
  $spark_home = "/opt/spark-${spark_version}-bin-hadoop${hadoop_version}"
  $spark_tarball = "spark-${spark_version}-bin-hadoop${hadoop_version}.tgz"

  package { "scala" :
    ensure => present,
    require => Exec['apt-get update']
  }

  exec { "download_spark":
    command => "/tmp/grrr spark/spark-${spark_version}/spark-${spark_version}-bin-hadoop${hadoop_version}.tgz  -O /vagrant/$spark_tarball --read-timeout=5 --tries=0",
    timeout => 1800,
    path => $path,
    creates => "/vagrant/$spark_tarball",
    require => [ Package["scala"], Exec["download_grrr"]]
  }

  exec { "unpack_spark" :
    command => "tar xf /vagrant/${spark_tarball} -C /opt",
    path => $path,
    creates => "${spark_home}",
    require => Exec["download_spark"]
  }

  file { "/etc/profile.d/spark-path.sh":
    content => template("spark/spark-path.sh.erb"),
    owner => vagrant,
    group => root,
  }

}
