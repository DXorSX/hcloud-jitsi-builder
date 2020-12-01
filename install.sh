#!/bin/bash

source ./ENVSETTINGS
SERVERNAME=test002
SERVERTYPE=ccx51
SSHPUBKEY=~/.ssh/hetzner_key.pub
SSHPRIVKEY=~/.ssh/hetzner_key
GITREPO=https://github.com/DXorSX/hcloud-jitsi-builder.git
SRVSTATUS=`hcloud server list -o columns=status -o noheader`
HCCONTEXT=`hcloud context active`

if [ ! -r "$SSHPRIVKEY" ]; then
	echo "SSH Key does not exist"
	echo "Generating Key ..."
	ssh-keygen -t rsa -N "" -f "$SSHPRIVKEY"
	ssh-add $SSHPRIVKEY
else
	ssh-add $SSHPRIVKEY
fi


if [ "$HCCONTEXT" = "" ]; then
	echo "hcloud context not set, please run: hcloud context create"
fi

echosyntax ()
{
        echo "Syntax: $0"
}

if [ "$SRVSTATUS" = "running" ]; then
	IPv4=`hcloud server ip $SERVERNAME`
	echo "Cloud node is still running with ip: $IPv4"
		exit
fi

hcloud server create --type $SERVERTYPE --name "$SERVERNAME" --image debian-10 --ssh-key $SSHPUBKEY --datacenter fsn1-dc14
IPv4=`hcloud server ip $SERVERNAME`


ssh-keygen -R "$IPv4"

SSHUP=255
while [ $SSHUP != 0 ]; do
	sleep 1
	echo "Trying to connect ..."
	ssh -l root -o="StrictHostKeyChecking off" $IPv4 pwd
	SSHUP=$?
done

ssh -l root "$IPv4" "apt --yes update && \
	apt --yes install git && \
	cd /root && \
	git clone $GITREPO && \
	cd /root/hcloud-jitsi-builder/ && \
	/root/hcloud-jitsi-builder/run.sh"





