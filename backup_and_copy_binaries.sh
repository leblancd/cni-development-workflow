#!/bin/bash

cd $GOPATH/src/github.com/containernetworking/cni/bin

echo Backing up binaries on kube-master
ssh kube@kube-master << EOT
sudo cp --backup=t /opt/cni/bin/bridge{,.bak}
sudo cp --backup=t /opt/cni/bin/host-local{,.bak}
EOT
echo Backing up binaries on kube-minion-1
ssh kube@kube-minion-1 << EOT
sudo cp --backup=t /opt/cni/bin/bridge{,.bak}
sudo cp --backup=t /opt/cni/bin/host-local{,.bak}
EOT
echo Backing up files on kube-minion-2
ssh kube@kube-minion-2 << EOT
sudo cp --backup=t /opt/cni/bin/bridge{,.bak}
sudo cp --backup=t /opt/cni/bin/host-local{,.bak}
EOT

echo Secure copying new binaries to /home/kube on kube-master
scp bridge host-local kube@kube-master:/home/kube
echo Secure copying new binaries to /home/kube on kube-minion-1
scp bridge host-local kube@kube-minion-1:/home/kube
echo Secure copying new binaries to /home/kube on kube-minion-2
scp bridge host-local kube@kube-minion-2:/home/kube

echo Copying new binaries to /bin on kube-master
ssh kube@kube-master << EOT
sudo cp /home/kube/bridge /opt/cni/bin
sudo cp /home/kube/host-local /opt/cni/bin
EOT
echo Copying new binaries to /bin on kube-minion-1
ssh kube@kube-minion-1 << EOT
sudo cp /home/kube/bridge /opt/cni/bin
sudo cp /home/kube/host-local /opt/cni/bin
EOT
echo Copying new binaries to /bin on kube-minion-2
ssh kube@kube-minion-2 << EOT
sudo cp /home/kube/bridge /opt/cni/bin
sudo cp /home/kube/host-local /opt/cni/bin
EOT

