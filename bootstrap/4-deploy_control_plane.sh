kubeadm init

sleep 60

mkdir -p /home/ubuntu/.kube
sudo cp -f /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
sudo chown ubuntu:ubuntu /home/ubuntu/.kube/config
sudo chown ubuntu:ubuntu /home/ubuntu/.kube
