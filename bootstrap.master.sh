#!/bin/bash
BOOTSTRAP_DIR="/root/bootstrap"
source bootstrap.functions.sh

ensure_packages_installed "git ruby ruby-irb rubygems httpd"
ensure_user_present "puppet"
ensure_directory "/etc/puppet"
ensure_file "/etc/puppet/puppet.conf" "puppet.master.conf"
ensure_file "/etc/yum.repos.d/example.repo" "example.repo"
ensure_file "/etc/httpd/conf.d/yum.conf" "yum.conf"
ensure_package_installed "rubygem-puppet"
exec_puppet_apply "puppet.master.pp"
