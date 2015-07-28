class hive {
  $hive_version = "1.1.1"
  $hive_tarball = "apache-hive-${hive_version}-bin.tar.gz"
  $hive_home = "/opt/apache-hive-${hive_version}-bin"

  exec { "download_hive":
    command => "/tmp/grrr hive/hive-${hive_version}/apache-hive-${hive_version}-bin.tar.gz -O /vagrant/$hive_tarball --read-timeout=5 --tries=0",
    timeout => 1800,
    path => $path,
    creates => "/vagrant/$hive_tarball",
    require => [ Exec["download_grrr"]]
  }

  exec { "unpack_hive" :
    command => "tar xf /vagrant/${hive_tarball} -C /opt",
    path => $path,
    creates => "${hive_home}",
    require => Exec["download_hive"]
  }

  file { "/etc/profile.d/hive-path.sh":
    content => template("hive/hive-path.sh.erb"),
    owner => vagrant,
    group => root,
  }

}
