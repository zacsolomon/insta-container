#!/bin/bash

yellow=`tput setaf 3`
reset=`tput sgr0`
bold=`tput bold`

# insta-container asks a couple of questions about what kind of LXC container you want to create
# then it automates the boring parts of creating a container so you can get straight to work 

echo "${yellow}insta-container, a script for making containers, ${bold}by zac solomon${reset}"
echo "${bold}What would you like to name your container?${reset}"
read  CONTAINER_NAME
echo "${bold}What would you like to be your username?"
read USERNAME
echo "${bold}What would you like to be your password?"
read -s PASSWORD
echo "${bold}okay, I'll make you a container, and name it $CONTAINER_NAME${reset}"


# trying  to be cool by auto-answering the container download prompt
# still WIP...
# echo "ubuntu\nxenial\namd64" | 
sudo lxc-create -t download -n $CONTAINER_NAME > /dev/null 2&1 &
echo "creating $CONTAINER_NAME ..."

# Starting container and installing services
echo "starting up $CONTAINER_NAME"
lxc-start -n $CONTAINER_NAME
echo "creating user $USERNAME"
lxc-attach -n $CONTAINER_NAME -- adduser $USERNAME --gecos "First Last, RoomNumber,WorkPhone,HomePhone"
lxc-attach -n $CONTAINER_NAME -- echo $USERNAME:$PASSWORD | chpasswd
lxc-attach -n $CONTAINER_NAME -- usermod -aG sudo $USERNAME

# Installing and starting up ssh server
lxc-attach -n $CONTAINER_NAME -- echo "Y" | apt install openssh-server > /dev/null 2>&1
echo "installing ssh server on $CONTAINER_NAME"
lxc-attach -n $CONTAINER_NAME -- service ssh start > /dev/null 2>&1

# Add $USERNAME to ssh group.. or is that just sudo group? 

# Presenting info about container to user
echo "${yellow}${bold}Container Info{reset}"
echo "container:" 
echo "IP addr:"
echo "lxc-attach -n test -- ifconfig eth0 | grep "inet addr" | cut -d : -f2 | awk '{print $1}'
