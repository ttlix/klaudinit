#!/bin/bash

# check 
function pre_check {
[ -z "$(type -a realpath)" ]  \
  && echo 1 && return
echo 0
}

function init_user {
temp=/tmp/init_user
file=""
grps=${1:-"501#ttlix"}
usrs=${2:-"2001#ttlix#ttlix,staff"}
pass=${3:-"passw0rd"}
[ "-f" = "$pass" ] \
  && file=${4:-"default.passwd"}
[ ! -z "$file" ] && [ -f "$temp/$file" ] \
  && pass=$(cat "$temp/$file"|head -n 1)
for grp in $grps; do
  _gid=$(echo $grp|awk -F# '{print $1}')
  _gnm=$(echo $grp|awk -F# '{print $2}')
  groupadd -g $_gid $_gnm
done
for usr in $usrs; do
  _uid=$(echo $usr|awk -F# '{print $1}')
  _unm=$(echo $usr|awk -F# '{print $2}')
  _grp=$(echo $usr|awk -F# '{print $3}')
  _gnm=$(echo $_grp|awk -F, '{print $1}')
  useradd -u $_uid -g $_gnm -G $_grp $_unm
  echo "$_unm:$pass" | chpasswd
  [ -z "$file" ] && file="$_uid#$_unm.passwd"
  [ ! -f "$temp/$file" ] \
    && mkdir -p $temp \
    && chown root:root $temp \
    && chmod 600 $temp \
    && echo $pass > "$temp/$file"
done
}

# init_packages 
function init_packages {
yum install -y curl wget unzip net-tools sshpass psmisc
}

# init_mysql
function init_mysql {
MYSQL_REPO=${MYSQL_REPO:-http://repo.mysql.com}
MYSQL_VERSION=${MYSQL_VERSION:-5.6}
MYSQL_RELEASE=mysql-community-release-el7-5.noarch.rpm
MYSQL_MAINPKG=$MYSQL_REPO/yum/mysql-${MYSQL_VERSION}-community/el/7/x86_64/$MYSQL_RELEASE
MYSQL_SERVER_ROLE=${MYSQL_SERVER_ROLE:-1}
yum install -y $MYSQL_MAINPKG
yum install -y mysql-community-client
[ $MYSQL_SERVER_ROLE -gt 0 ] && yum install -y mysql-community-server
}

# init_crond
function init_crond {
yum install -y cronie
systemctl start crond
}

# init_node
function init_node {
[ "$(pre_check)" -gt 0 ] \
  && exit 1
init_user '500#staff' '1000#cloud-user#staff' 'passw0rd'
init_user '501#ttlix' '2001#ttlix#staff,ttlix' 'ttlix'
init_packages
init_crond
init_mysql
echo init node done
}

# init
function init {
init_node $@
echo init all done
}

# main
function main {
init $@
}

main $@
