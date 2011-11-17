file {
  "/var/spool/gitolite":
    ensure => directory,
    owner => "git",
    group => "git";

  "admin.pub":
    ensure => present,
    path => "/var/spool/gitolite/admin.pub",
    content => "ssh-rsa AAAAB3Nza...LcxczOQ== admin@example.net";
}

package {
  "git":
    ensure => installed;

  "gitolite":
    ensure => installed;
}

user {
  "git":
    ensure => present,
    home => "/var/spool/gitolite",
    managehome => true,
    require => Package["git"];
}

exec {
  "gl-setup":
    user => "git",
    path => "/usr/bin:/bin",
    environment => ["HOME=/var/spool/gitolite", "GL_BINDIR=/usr/bin"],
    logoutput => true,
    command => "/usr/bin/gl-setup -q /var/spool/gitolite/admin.pub",
    creates => "/var/spool/gitolite/.gitolite.rc",
    require => [Package["gitolite"],File["admin.pub"]];
}
