#!/bin/bash

# Cluster resilience
## https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#resilience

SRC_FOLDER="/var/lib/etcd"
BKP_FOLDER="etcd-$(date +"%m-%d-%y-%H-%M-%S")"

echo "generating backup"
cp -rf $SRC_FOLDER $BKP_FOLDER

echo "compress backup"
tar -zcvf $BKP_FOLDER.tar.gz $BKP_FOLDER

echo "sending backup to owncloud"
source $VENV_PWD/bin/activate
python3 $REPO_PWD/send_backup_to_owncloud.py --bkp-file $BKP_FOLDER.tar.gz --login $OC_USER --password $OC_PASS

echo "clean"
rm -rf $BKP_FOLDER
rm -rf $BKP_FOLDER.tar.gz

echo "backup done"
