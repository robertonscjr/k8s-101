kubeadm init

sleep 60

mkdir -p /home/ubuntu/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
sudo chown ubuntu:ubuntu /home/ubuntu/.kube/config
sudo chown ubuntu:ubuntu /home/ubuntu/.kube

kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
