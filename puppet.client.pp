package {
  "rubygem-puppet":
    ensure => installed;
}

$puppetmaster = "puppet.example.net"
file {
  "/etc/puppet":
    ensure => directory;

  "puppet.conf":
    ensure => present,
    path => "/etc/puppet/puppet.conf",
    content => template("/tmp/bootstrap/puppet.client.conf.erb"),
    require => Package["rubygem-puppet"];
}
