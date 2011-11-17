#!/bin/bash
CUR_DIR=`pwd`
BOOTSTRAP_DIR="/tmp/bootstrap"
URL="https://puppet.example.net/bootstrap/"

if [ ! -f /usr/bin/wget ]; then
    yum install --quiet -y wget 1>/dev/null
fi
if [ ! -f bootstrap.functions.sh ]; then
    mkdir ${BOOTSTRAP_DIR}
    wget --quiet --no-check-certificate --output-document=${BOOTSTRAP_DIR}/bootstrap.functions.sh ${URL}/bootstrap.functions.sh
fi
source ${BOOTSTRAP_DIR}/bootstrap.functions.sh

ensure_directory_absent $BOOTSTRAP_DIR
ensure_directory $BOOTSTRAP_DIR
ensure_packages_installed "ruby ruby-irb rubygems"
ensure_user_present "puppet"
ensure_directory "/etc/puppet"
ensure_file "/etc/puppet/puppet.conf" "puppet.client.conf"
ensure_file "/etc/yum.repos.d/example.repo"  "example.repo"
ensure_package_installed "rubygem-puppet"
ensure_file "puppet.client.pp" "puppet.client.pp"
ensure_file "puppet.client.conf.erb" "puppet.client.conf.erb"
exec_puppet_apply "${BOOTSTRAP_DIR}/puppet.client.pp"

ensure_directory_absent $BOOTSTRAP_DIR
ensure_file_absent "${CUR_DIR}/bootstrap.client.sh"

echo "Remove the --noop parameter when you are ready."
echo "You may now run: puppet agent --test --noop"
