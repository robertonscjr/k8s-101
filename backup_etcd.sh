#!/bin/bash

# Cluster resilience
## https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#resilience

SRC_FOLDER="/var/lib/etcd"
BKP_FOLDER="etcd-$(date +"%m-%d-%y-%H-%M-%S")"
S3_BUCKET="s3://YOUR-S3-BUCKET"

echo "generating backup"
cp -rf $SRC_FOLDER $BKP_FOLDER

echo "compress backup"
tar -zcvf $BKP_FOLDER.tar.gz $BKP_FOLDER

echo "sending backup to owncloud"
source $VENV_PWD/bin/activate
python3 $REPO_PWD/send_backup_to_owncloud.py --bkp-file $BKP_FOLDER.tar.gz --login $OC_USER --password $OC_PASS

echo "sending backup to aws s3"
source $VENV_PWD/bin/activate
rm -rf __tmp__
mkdir __tmp__
mv $BKP_FOLDER.tar.gz __tmp__
aws s3 sync __tmp__ $S3_BUCKET

echo "clean"
rm -rf __tmp__
rm -rf $BKP_FOLDER
rm -rf $BKP_FOLDER.tar.gz

echo "backup done"
