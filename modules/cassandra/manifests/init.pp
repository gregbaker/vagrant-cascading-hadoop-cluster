class cassandra {
  $cassandra_version = "3.7"
  $cassandra_home = "/opt/apache-cassandra-${cassandra_version}"
  $cassandra_tarball = "apache-cassandra-${cassandra_version}-bin.tar.gz"

  exec { "download_cassandra":
    command => "/tmp/grrr /cassandra/${cassandra_version}/${cassandra_tarball} -O /vagrant/${cassandra_tarball} --read-timeout=5 --tries=0",
    timeout => 1800,
    path => $path,
    creates => "/vagrant/${cassandra_tarball}",
    require => [ Package["openjdk-8-jdk"], Exec["download_grrr"]]
  }

  exec { "unpack_cassandra":
    command => "tar xf /vagrant/${cassandra_tarball} -C /opt",
    path => $path,
    creates => "${cassandra_home}",
    require => Exec["download_cassandra"]
  }

  file { "/etc/profile.d/cassandra-path.sh":
    content => template("cassandra/cassandra-path.sh.erb"),
    owner => vagrant,
    group => root,
  }

}
