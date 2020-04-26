# K8s的安装与部署

## 使用kubeadm(国内Aliyun镜像)

### 一、环境准备与安装

1. 为每一台主机配置hosts

```bash
172.16.122.128 master.suofeiya.com master
172.16.122.132 node1.suofeiya.com node1
172.16.122.133 node2.suofeiya.com node2
```

2. 开启透明网桥

```bash
echo "net.bridge.bridge-nf-call-iptables=1" >> /etc/sysctl.conf
# 修改/proc/sys/net/bridge/bridge-nf-call-iptables 的值也可以
echo "net.bridge.bridge-nf-call-ip6tables=1" >> /etc/sysctl.conf
sysctl -p
```

3. 在k8s早期版本，需要关闭系统的swap

```bash
# 注释掉以下内容，重启机器即可
/dev/mapper/centos-swap swap                    swap    defaults        0 0
```

3. 添加阿里云docker-ce镜像

**Debian / Ubuntu**

```bash
# step 1: 安装必要的一些系统工具
sudo apt-get update
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
# step 2: 安装GPG证书
curl -fsSL https://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
# Step 3: 写入软件源信息
sudo add-apt-repository "deb [arch=amd64] https://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
# Step 4: 更新并安装Docker-CE
sudo apt-get -y update
sudo apt-get -y install docker-ce

# 安装指定版本的Docker-CE:
# Step 1: 查找Docker-CE的版本:
# apt-cache madison docker-ce
#   docker-ce | 17.03.1~ce-0~ubuntu-xenial | https://mirrors.aliyun.com/docker-ce/linux/ubuntu xenial/stable amd64 Packages
#   docker-ce | 17.03.0~ce-0~ubuntu-xenial | https://mirrors.aliyun.com/docker-ce/linux/ubuntu xenial/stable amd64 Packages
# Step 2: 安装指定版本的Docker-CE: (VERSION例如上面的17.03.1~ce-0~ubuntu-xenial)
# sudo apt-get -y install docker-ce=[VERSION]
```

**CentOS / RHEL / Fedora**

```bash
# step 1: 安装必要的一些系统工具
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
# Step 2: 添加软件源信息
sudo yum-config-manager --add-repo https://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
# Step 3: 更新并安装Docker-CE
sudo yum makecache fast

# 注意：
# 官方软件源默认启用了最新的软件，您可以通过编辑软件源的方式获取各个版本的软件包。例如官方并没有将测试版本的软件源置为可用，您可以通过以下方式开启。同理可以开启各种测试版本等。
# vim /etc/yum.repos.d/docker-ee.repo
#   将[docker-ce-test]下方的enabled=0修改为enabled=1
#
# 安装指定版本的Docker-CE:
# Step 1: 查找Docker-CE的版本:
# yum list docker-ce.x86_64 --showduplicates | sort -r
#   Loading mirror speeds from cached hostfile
#   Loaded plugins: branch, fastestmirror, langpacks
#   docker-ce.x86_64            17.03.1.ce-1.el7.centos            docker-ce-stable
#   docker-ce.x86_64            17.03.1.ce-1.el7.centos            @docker-ce-stable
#   docker-ce.x86_64            17.03.0.ce-1.el7.centos            docker-ce-stable
#   Available Packages
# Step2: 安装指定版本的Docker-CE: (VERSION例如上面的17.03.0.ce.1-1.el7.centos)
# sudo yum -y install docker-ce-[VERSION]
```

4. 添加阿里云k8s相关镜像

**Debian / Ubuntu**

```bash
apt-get update && apt-get install -y apt-transport-https
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add - 
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF  
```

**CentOS / RHEL / Fedora**

```bash
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
EOF
```

5. 安装docker-ce，k8s相关（ kubelet kubeadm kubectl），并设置为开机启动

```bash
yum install -y docker-ce kubelet kubeadm kubectl
systemctl enable docker kubelet
```

### 二、初始化master

```bash
kubeadm init --kubernetes-version=v1.17.0 --pod-network-cidr=10.244.0.0/16 --service-cidr=10.96.0.0/12 
```

完成之后会有以下提示信息：

```bash
Your Kubernetes control-plane has initialized successfully!

To start using your cluster, you need to run the following as a regular user:
# ==========手动完成==========
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
# ===========================
You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

Then you can join any number of worker nodes by running the following on each as root:
# 记录好下面这条命令，以便node节点的加入
kubeadm join 172.16.122.128:6443 --token a2i1tb.rcyxusi4wij2n9ec \
    --discovery-token-ca-cert-hash sha256:8fccc1b289a2bc890686a89af7fd6cc4ccfd97e9fd02f92ffea8ed6cfc0eb5e9 
```

此时使用`kubectl get nodes`发现`master`节点的是`NotReady`未就绪状态

```bash
[root@master ~]\# kubectl get nodes
NAME     STATUS     ROLES    AGE    VERSION
master   NotReady   master   3h2m   v1.17.0
```

因此，我们还需要安装`fannel`来部署k8s网络，以激活节点。

去往`fannel`[官方github站点](https://github.com/coreos/flannel#deploying-flannel-manually)，使用手动部署（k8s版本1.7+）：

```bash
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

等待docker拉取完镜像之后，再次使用`kubectl get nodes0`就会发现`master`节点已就绪。

---

#### init时可能遇到的问题

1. `[WARNING IsDockerSystemdCheck]: detected "cgroupfs" as the Docker cgroup driver. The recommended driver is "systemd".`，意思就是`[警告IsDockerSystemdCheck]：检测到“cgroupfs”作为Docker cgroup驱动程序。 推荐的驱动程序是“systemd”`。解决方法就是修改docker的驱动的驱动程序为`systemd`，具体步骤如下：

```bash
# 编辑docker配置文件/etc/docker/daemon.json，如果没有则创建
####
{
"exec-opts":["native.cgroupdriver=systemd"]
}
####
```

然后重启docker服务即可

2. `[ERROR Swap]: running with swap on is not supported. Please disable swap`，意思是`运行不支持swap，请关闭swap`，解决方法：

（1）关闭swap(见环境配置)

（2）忽略警告

```bash
# ①编辑配置文件/etc/sysconfig/kubelet
####
KUBELET_EXTRA_ARGS="--fail-swap-on=false"
####
# ②初始化init时添加`--ignore-preflight-errors=Swap`参数
```

**kubeadm init时，会因为无法访问外网，从而导致镜像下载失败，解决方法有以下两种：**

（1）配置docker使用代理（已失效×）

```bash
vim /usr/lib/systemd/system/docker.service
####
Environment="HTTPS_PROXY=http://www.ik8s.io:10080"
Environment="NO_PROXY=127.0.0.0/8,172.16.122.0/16"
####
```

（2）提前从阿里云下载好所需镜像，并重新打标

使用脚本自动完成：

```bash
[root@master scripts]# cat get_k8s_img_from_aliyun.sh
#!/bin/bash
# need get images
images=(
k8s.gcr.io/kube-apiserver:v1.17.0
k8s.gcr.io/kube-controller-manager:v1.17.0
k8s.gcr.io/kube-scheduler:v1.17.0
k8s.gcr.io/kube-proxy:v1.17.0
k8s.gcr.io/pause:3.1
k8s.gcr.io/etcd:3.4.3-0
k8s.gcr.io/coredns:1.6.5
)
k8s_registry=k8s.gcr.io
aliyun_registry=registry.cn-hangzhou.aliyuncs.com
# get images from aliyun registry
function get_aliyun_k8s_images() {
for k8s_image in ${images[*]};do
image=` echo $k8s_image | awk -F '/' '{print $2}'`
docker pull $aliyun_registry/google_containers/$image
done
}
# tag images to k8s.gcr.io registry
function tag_images() {
for k8s_image in ${images[*]};do
image=` echo $k8s_image | awk -F '/' '{print $2}'`
docker tag $aliyun_registry/google_containers/$image $k8s_registry/$image
done
}
get_aliyun_k8s_images
tag_images
docker pull quay.io/coreos/flannel:v0.11.0-amd64
docker images
```

### 三、将node添加进master集群中

node节点需要准备以下三个镜像（国内有墙才需要预先下载）

```bash
k8s.gcr.io/kube-proxy:v1.17.0
k8s.gcr.io/pause:3.1
quay.io/coreos/flannel:v0.11.0-amd64
```

拉取完后使用`kubeadm join`即可

```bash
kubeadm join 172.16.122.128:6443 --token a2i1tb.rcyxusi4wij2n9ec \
    --discovery-token-ca-cert-hash sha256:8fccc1b289a2bc890686a89af7fd6cc4ccfd97e9fd02f92ffea8ed6cfc0eb5e9 --ignore-preflight-errors=Swap
```

接着在master节点上查看pod相关信息

```bash
[root@master ~]\# kubectl get nodes
NAME     STATUS   ROLES    AGE     VERSION
master   Ready    master   3h29m   v1.17.0
node1    Ready    <none>   3m26s   v1.17.0
```

node1节点已成功加入并处于就绪状态，说明node1加入集群成功

### 注意事项

1. master和node节点上如果`kubeadm`执行不成功，或者需要重新执行，需要先使用`kubeadm reset `恢复初始状态
2. master和node节点上的`kubelet`需要设置为自启动，否则主机重启后组件类容器不能启动

## 一键安装

