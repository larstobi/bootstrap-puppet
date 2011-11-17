function package_installed {
    name=$1
    if `rpm -q $name 1>/dev/null`; then
	return 0
    else
	return 1
    fi
}

function install_package {
    `yum install --quiet -y $1 1>/dev/null`
    RET=$?
    if [ $RET == 0 ]; then
	return 0
    else
	echo "ERROR: Could not install package $1"
	exit 1
    fi
}

function ensure_package_installed {
    if ! package_installed $1 ; then
	echo "Installing ${1}"
	install_package $1
    fi
}

function ensure_packages_installed {
    for package in $1; do
	ensure_package_installed $package
    done
}

function user_present {
    if `grep -q "^$1:" /etc/passwd`; then
	return 0
    else
	return 1
    fi
}

function ensure_user_present {
    if ! user_present $1; then
	echo "Adding user $1"
	DIR=/var/empty/$1
	useradd -d $DIR $1
	chown root:root $DIR
	chmod 711 $DIR
    fi
}

function ensure_directory_absent {
    if [ "${1}" == "/" ]; then
	echo "ERROR: Trying to delete root filesystem."
	exit 1
    else
	echo "rm -rf ${1}"
	rm -rf "${1}"
    fi
}

function ensure_directory {
    if ! [ -d "${1}" ]; then
	mkdir "${1}"
    fi
}

function download_file {
    cd $BOOTSTRAP_DIR
    wget --quiet --no-check-certificate ${URL}${1}
}

function ensure_file_absent {
    rm -f "${1}"
}

function ensure_file {
    path=$1
    source=$2

    if ! [ -f $source ]; then
	download_file $source
    fi

    if ! [ -f $path ]; then
	cp $BOOTSTRAP_DIR/$source $path && \
	    return 0
    elif ! diff -q $BOOTSTRAP_DIR/$source $path; then
	return 0
    fi
}

function exec_puppet_apply {
    manifest=$1
    puppet apply $manifest
}
