#!/bin/sh
MAIN_LINK=https://github.com/titanlixio/klaudinit.git
MAIN_IFDEV=enp0s3
MAIN_KLAUDENV=dev
NODE_NAME=node01
NODE_DOMAIN=dev.ttlix

cat << EOF

ifup $MAIN_IFDEV
yum install -y openssh-server openssh-clients git
systemctl start sshd
cd /tmp
git clone $MAIN_LINK
###-----------------------------------------------###
###-----------------------------------------------###
KLAUDENV=dev \
  sh /tmp/klaudinit/extensions/setup/main.sh      \\
  -l localhost                                    \\
  -e NODE_NAME=node01 -e NODE_DOMAIN=dev.ttlix    \\
  -e VOLS_PART=True   -e VOL1_NAME=/dev/sdb       \\ 
  -e SWAP_PART=True   -e SWAP_PATH=/home/swapfile
###-----------------------------------------------###
###-----------------------------------------------###

EOF
