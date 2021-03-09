# Quickstart Kubernetes

This repository aims to facilitate the deployment of a Kubernetes cluster that has more than one node.

For this repository to work, you need **ssh access** to the nodes and some allowed ports for access the **Control Plane Node** through [**kubectl**](https://kubernetes.io/pt/docs/reference/kubectl/cheatsheet/). 

Follow the order of the documentation for a better experience!

## Node Requirements

A Node in Kubernetes is literally the machine (bare metal or virtual machine) on which the K8s components will be installed.

To know more about the Node concept, [click here](https://kubernetes.io/docs/concepts/architecture/nodes/).

Node minimal setup:

* CPU: 2
* RAM: 2GB
* OS: Ubuntu 20.04

For the proper functioning of the scripts, **ensure that you have SSH access to the instances.**

## Client Requirements

The client is the machine where **kubectl** will be configured, which is the command we use to interact with the **Control Plane Node**. 

Requirements:

* python 3.6+
* virtualenv
* OS: Debian-based distro

You need **superuser access** to be able to install the requirements.

## Network Access Requirements

To configure the required port accesses for the nodes, see [**Check required ports**](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#check-required-ports).

In the case of using VMs, the cloud providers have the area for configuring **Security Groups**.

## Run

If you followed the previous steps, ensuring that the restrictions for each section are resolved, set the environment variable of the key which will be used to access the nodes:
```bash
$ export SSH_KEYFILE="~/.ssh/NODE_PK"
```

Edit the [**nodes file**](nodes) with the IPs of the hosts:
```bash
$ # edit this file with your node/host/VM IPs
$ cat nodes

[control-plane]
10.0.0.1

[worker]
10.0.0.2
10.0.0.3
```

Finally, run:
```bash
$ bash run.sh
```

Installation and configuration usually takes a few minutes...

After every setup finished, test if you can see the nodes of your Kubernetes cluster:
```bash
$ kubectl get nodes

NAME                     STATUS       ROLES     AGE     VERSION
kubernetes-node-1        Ready        master    1h      v1.13.0
kubernetes-node-2        Ready        <none>    1h      v1.13.0
kubernetes-node-3        Ready        <none>    1h      v1.13.0
```

Done! **Your cluster is ready for the action!**

## Troubleshooting

### 1. SSH Issue: REMOTE HOST IDENTIFICATION HAS CHANGED!

To use this repository successfully, **you must ensure that you have ssh access to the instances where the nodes will be configured**.

A very common issue is remote host identification. This problem happens because the host trying to be accessed via ssh contains an old identification fingerprint. This fingerprint can be seen in the **/home/YOURUSER/.ssh/known_hosts** file.

```bash
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                       
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @                       
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                       
IT IS POSSIBLE THAT SOMEONE IS DOING SOMETHING NASTY!                             
Someone could be eavesdropping on you right now (man-in-the-middle attack)!       
It is also possible that a host key has just been changed.                        
The fingerprint for the ECDSA key sent by the remote host is                      
SHA256:Ftc30kXYMapvIdIbeIpel+dhfsL9LRFt7LEGa1I1lfk.                               
Please contact your system administrator.
Add correct host key in /home/YOURUSER/.ssh/known_hosts to get rid of this message.
Offending ECDSA key in /home/YOURUSER/.ssh/known_hosts:47                          
  remove with:
  ssh-keygen -f "/home/YOURUSER/.ssh/known_hosts" -R "10.0.0.1"                 
ECDSA host key for 10.0.0.1 has changed and you have requested strict checking.
Host key verification failed.
```

To solve, just **execute the command described in the error log, changing only the IP of the host you want to access**:
```bash
ssh-keygen -f "/home/roberto/.ssh/known_hosts" -R "10.0.0.1" 
```
