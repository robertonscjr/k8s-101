# Quickstart Kubernetes

This repository aims to facilitate the deployment of a Kubernetes cluster that has more than one node.

For this repository to work, you need **ssh access** to the nodes and some allowed ports for access the **Control Plane Node** through [**kubectl**](https://kubernetes.io/pt/docs/reference/kubectl/cheatsheet/). 

---

## Node Requirements

A Node in Kubernetes is literally the machine (bare metal or virtual machine) on which the K8s components will be installed.

To know more about the Node concept, [click here](https://kubernetes.io/docs/concepts/architecture/nodes/).

Node minimal setup:

* CPU: 2
* RAM: 2GB
* OS: Ubuntu 20.04

---

## Client Requirements

The client is the machine where **kubectl** will be configured, which is the command we use to interact with the **Control Plane Node**. 

Requirements:

* Python 3.5+

---

## Network Access Requirements

To configure the required port accesses for the nodes, see [**Check required ports**](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#check-required-ports).

In the case of using VMs, the cloud providers have the area for configuring **Security Groups**.
