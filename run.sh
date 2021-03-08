#!/bin/bash

CONTROL_PLANE_NODE_IP=`cat nodes | grep -A 1 control | grep -v control`
WORKER_NODE_IP=`cat nodes | grep -A 1 worker | grep -v worker`

if [ -z "${CONTROL_PLANE_NODE_IP}" ] || [ -z "${WORKER_NODE_IP}" ]; then
    echo "[control-plane] or [worker] not defined in 'nodes' file"
else
    if [ -d venv ]; then
        rm -rf venv
    fi

    echo "configuring python3 venv"
    virtualenv -p python3 venv
    source venv/bin/activate
    
    echo "install ansible"
    pip3 install ansible
    
    echo "start control plane node setup"
    ansible-playbook -i nodes control-plane.yml --key-file "$SSH_KEYFILE"
    
    echo "setup kubectl on client"
    bash bootstrap/3-install_kubetools.sh
    
    echo "configure kubectl access"
    if [ -d "$HOME/.kube" ]; then
        rm -rf $HOME/.kube
    fi
    mkdir -p $HOME/.kube
    scp -i $SSH_KEYFILE ubuntu@$CONTROL_PLANE_NODE_IP:/home/ubuntu/.kube/config $HOME/.kube/config
    
    echo "get token info to join workers"
    DISCOVERY_TOKEN_HASH=`ssh -i $SSH_KEYFILE ubuntu@$CONTROL_PLANE_NODE_IP openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | openssl rsa -pubin -outform der 2>/dev/null | openssl dgst -sha256 -hex | sed 's/^.* //'`
    TOKEN=`kubeadm token list | grep -v TOKEN | awk '{print $1}'`
    
    echo "start worker nodes setup"
    ansible-playbook -i nodes worker.yml -e CONTROL_PLANE_NODE_IP=$CONTROL_PLANE_NODE_IP -e TOKEN=$TOKEN -e DISCOVERY_TOKEN_HASH=$DISCOVERY_TOKEN_HASH --key-file "$SSH_KEYFILE"
fi
