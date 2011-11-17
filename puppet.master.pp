package {
  "rubygem-puppet-server":
    ensure => installed;
}

$puppetmaster = "puppet.example.net"
file {
  "/etc/puppet":
    ensure => directory;

  "puppet.conf":
    ensure => present,
    path => "/etc/puppet/puppet.conf",
    content => template("/root/bootstrap/puppet.master.conf.erb"),
    require => Package["rubygem-puppet-server"];
}

service {
  "puppetmaster":
    ensure => running,
    require => File["puppet.conf"];
}
