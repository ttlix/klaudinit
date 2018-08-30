#!/bin/sh
MAIN_LINK=https://raw.githubusercontent.com/titanlixio/klaudinit/master/extensions/setup/main.sh
MAIN_IFDEV=enp0s3
MAIN_KLAUDENV=dev
NODE_NAME=node01
NODE_DOMAIN=dev.ttlix

cat << EOF

ifup $MAIN_IFDEV
yum install -y openssh-server openssh-clients
systemctl start sshd
curl -o /tmp/main.sh $MAIN_LINK
###-----------------------------------------------###
###-----------------------------------------------###
KLAUDENV=dev sh /tmp/main.sh \\
  -l localhost                                    \\
  -e NODE_NAME=node01 -e NODE_DOMAIN=dev.ttlix    \\
  -e VOLS_PART=True   -e VOL1_NAME=/dev/sdb       \\ 
  -e SWAP_PART=True   -e SWAP_PATH=/home/swapfile
###-----------------------------------------------###
###-----------------------------------------------###

EOF
