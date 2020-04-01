#!/bin/bash

REPO=https://github.com/jgibbons-cp/node-webhook-scripts.git
REPO_NAME=node-webhook-scripts
NVM_HOME=/home/$USER/.nvm
NVM_INSTALL_URL=https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh
NVM_INSTALL_SCRIPT=install.sh
NVM_SETUP_SCRIPT=nvm.sh

#add ssh key
ssh-add $KEY_LOCATION

#install git
ssh $USER@$HOST sudo yum -y install git

#pull repo
ssh $USER@$HOST git clone $REPO

#configure install of node
ssh $USER@$HOST "mkdir $NVM_HOME ; curl -O $NVM_INSTALL_URL ; sh $NVM_INSTALL_SCRIPT ; sh $NVM_HOME/$NVM_SETUP_SCRIPT ;"

#install node
ssh $USER@$HOST "nvm install node"

#copy sample script
ssh $USER@$HOST "cp $REPO_NAME/$SCRIPT_NAME ~/"

#start listener
ssh -f $USER@$HOST "cd $REPO_NAME ; npm install express ; nohup node index.js &>/dev/null"
