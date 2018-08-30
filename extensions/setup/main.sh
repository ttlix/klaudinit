#!/bin/sh
PRJ_NAME=klaudinit
SCM_NAME=titanlixio/$PRJ_NAME
SCM_URL=https://github.com/$SCM_NAME.git
SCM_CLEAN=${SCM_CLEAN:-1}
ANS_BOOK=${ANS_BOOK:-"base"}
ANS_CONF=$@
KLAUDENV=${KLAUDENV:-"dev"}

yum install -y \
  git \
  ansible 

mkdir -p $HOME/.ssh
chmod 700 $HOME/.ssh
[ ! -f $HOME/.ssh/id_rsa ] \
  && ssh-keygen -N '' -f $HOME/.ssh/id_rsa \
  && cat $HOME/.ssh/id_rsa.pub | tee -a $HOME/.ssh/authorized_keys \
  && chmod 600 $HOME/.ssh/authorized_keys


cd /tmp
[ $SCM_CLEAN -gt 0 ] \
  && rm -rf $PRJ_NAME
[ ! -d $PRJ_NAME ] \
  && git clone $SCM_URL
[ -d $PRJ_NAME ] \
  && cd $PRJ_NAME \
  && ansible-playbook \
    -i envs/${KLAUDENV}.ini \
    $ANS_CONF \
    plays/${ANS_BOOK}.yaml
