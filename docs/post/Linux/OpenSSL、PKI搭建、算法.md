> **This is OpenSSL、PKI搭建、加密算法和类型 StudyNote.**

#  几种加密算法优缺点以及对应的协议

##		1、 对称加密：加密和解密使用同一秘钥

* 常见的算法有：`DES`,`3DES`,`AES`

* 特性以及缺点

  * >特性：
    >
    >​				加密解密使用同一秘钥
    >
    >​				将原始数据划分成多个块，并逐个进行加密
    >
    >缺点：
    >
    >​				产生的秘钥过多
    >
    >​				秘钥分发比较困难

* 基本用途：用来数据加密（保密性）

* 详情参考：[对称加密_百度百科](http://www.baidu.com/link?url=9cR8rk4ajXh5Ckpk6xq0xg4pxp8Woz4QanAudazXwL8g742oYrrvBqrn-BfywsBjni6qTOsyDwBMtBPfj_LVAjemhNk87a1Wf389o0KrwNFn6Xv73jMphkCq0jQKuzqQ&wd=&eqid=fab8283f00af7c39000000035d9d31de)

##  2、非对称加密(公钥加密):分为公钥和私钥

* `公钥`(public key)从私钥中提取产生，可公开给所有人，`私钥`(secret key)由用户自行产生，需保证其完整性
* 常见的算法有：`RSA`,`DSA`,`ELGamal`,其中`DSA`一般只用来数字签名
* 基本用途：
  * `数字签名`：让接收方确认发送方的身份
  * `密钥交换`：发送方用对方的公钥加密一个对称密钥，并发送给对方
  * `数据加密`
* 详情参考：[非对称加密算法_百度百科](http://www.baidu.com/link?url=E4o847EGZyDdQCMoX4DEhEwzl9zCDdD_bXs1eyTGN6YxC9kxJbuslB1rlUAz3kY4Sg-qjUrADM_tUxHVrrJtF3EAngVOW4wxb4tTX5_Bjv4zLR_2czlN2m4UWrkGTeg7BPU6cn5g16Zw6A44VgnrcIdV3le4-cIhkuvOtqhB-Wa&wd=&eqid=83d3a9f400b72f53000000035d9d3232)

## 3、单向加密：提取出数据指纹,只能加密,不能解密

* 常用算法有`md5`(Message Digest5),`sha1/224/256/384/512`(Secure Hash Algorithm)
* 特性：定长输出，雪崩效应
  * `雪崩效应`：雪崩效应就是一种不稳定的平衡状态也是加密算法的一种特征，它指明文或密钥的少量变化会引起密文的很大变化
* 基本用途：保证数据的完整性

# 密钥交换

* IKE：Internet Key Exchange
* 常用算法：`RSA`,`DH`
* DH(Diffie-Hellman)算法：[算法描述](https://baike.baidu.com/item/Diffie-Hellman/9827194?fr=aladdin#3)，目的在于使得两个用户安全地交换一个秘密密钥以便用于以后的报文加密，变种`ECDH`(椭圆曲线DH)，`ECDHE`(临时椭圆曲线DH)

* ](https://zh.wikipedia.org/wiki/X.509#证书组成结构)

#  SSL和TLS

* `SSL`：Secure Socket Layer  安全套接字层，发行版本v1.0 v2.0 v3.0

* `TLS`：Transport Layer Security  传输安全层，版本v1.0 v1.1 v1.2 v1.3

* <img src="/home/suofeiya/myGitbook/images/IMG_20191009_200222.jpg" alt="SSL会话主要不步骤" style="zoom:50%;" />

* 参考资料：[wiki百科_传输层安全性协议](https://zh.wikipedia.org/wiki/傳輸層安全性協定)

* OpenSSL命令行工具的使用：

  * >（1）对称加密
    >
    >​				所用工具：`openssl enc`,`gpg`
    >
    >​				支持的算法有：`3DES`,`AES`,`blowfish`
    >
    >```bash
    > openssl enc -e  -a -salt -in TESTFILE   -out TESTFILE.cipher		# -e表示加密文件，-a表示base64编码，-salt加盐添加杂质更安全
    >openssl enc -d  -a -salt –in TESTFILE.cipherr  -out OUT_TESTFILE			# -d表示解密
    >```
    >
    >
    >
    >（2）单向加密
    >
    >​				所用工具：`openssl dgst`
    >
    >```bash
    >openssl dgst /PATH/TO/SOMEFILE
    >```
    >
    >（3）随机生成用户密码
    >
    >​				所用工具：`openssl passwd`
    >
    >```bash
    ># 交互式密码生成工具
    >openssl passwd -1 -salt SALT			# 参数-1代表使用md5加密，-salt加入混杂
    >```
    >
    >（4）生成随机数
    >
    >​			 所用工具：`openssl rand`
    >
    >```bash
    >openssl rand -hex NUMBER
    >openssl rand -base64 NUMBER
    >```
    >
    >（5）**公钥加密**
    >
    >```bash
    ># 生成私钥
    >(umask 077; openssl genrsa -out /PATH/TO/PRIVATE_KEY_FILE NUM_BITS)
    ># 提出公钥
    >openssl rsa -in /PATH/TO/PRIVATE_KEY_FILE -pubout
    >```
    >
    >---
    >
    >>Linux系统上的随机数生成器：
    >>
    >>​			`/dev/random`：仅从熵池中返回随机数，当随机数用尽时阻塞
    >>
    >>​			`/dev/urandom`：从熵池中返回随机数，当随机数用尽时会利用软件生成伪随机数，非阻塞
    >>
    >>伪随机数并不安全，不推荐使用
    >>
    >>熵池中随机数的来源：
    >>
    >>​			硬盘IO中断的时间间隔
    >>
    >>​			键盘IO中断的时间间隔	

# PKI(Public Key Infrastructure):公钥基础设施

- 公钥基础设施有：

  - > 签证机构：CA
    >
    > 注册机构：RA
    >
    > 证书吊销列表：CRL
    >
    > 证书存取库
    >
    > 
    >
    > 参考：[https://baike.baidu.com/item/%E5%85%AC%E9%92%A5%E5%9F%BA%E7%A1%80%E8%AE%BE%E6%96%BD/10881894?fromtitle=PKI&fromid=212376#2](https://baike.baidu.com/item/公钥基础设施/10881894?fromtitle=PKI&fromid=212376#2)

- X.509：公钥证书的格式标准https://zh.wikipedia.org/wiki/X.509#%E8%AF%81%E4%B9%A6%E7%BB%84%E6%88%90%E7%BB%93%E6%9E%84

- 建立私有CA

  - >可以使用[`openssl`](https://www.openssl.org/)和[`openca`](https://www.openca.org/)命令
    >
    >`openssl`的三个组件：
    >
    >   			 openssl: 多用途的命令行工具，包openssl
    >	
    >   			 libcrypto: 加密算法库，包openssl-libs
    >
    >​    			libssl：加密模块应用库，实现了ssl及tls，包nss
    >
    >openssl命令：
    >
    >​			配置文件：`/etc/pki/openssl.cnf`
    >
    >（1）生成私钥
    >
    >```bash
    >(umask 077; openssl genrsa -out /etc/pki/CA/private/cakey.pem 4096)
    >```
    >
    >（2）生成自签证书
    >
    >```bash
    >openssl req -new -x509 -key /etc/pki/CA/private/cakey.pem -out /etc/pki/CA/cacert.pem -days 3650
    >
    ># 查看生成的自签名证书
    >openssl x509 -in /etc/pki/CA/cacert.pem -noout  -text
    >```
    >
    >（3）为CA提供所需文件
    >
    >```bash
    >touch /etc/pki/CA/{serial,index.txt}
    >echo 01 > /etc/pki/CA/serials
    >```
    >
    >---
    >
    >（用户端）
    >
    >1）生成私钥
    >
    >   ```bash
    >(umask 077;openssl genrsa -out app.key 1024)
    >   ```
    >
    >2）生成证书申请文件
    >
    >      ```bash
    > openssl  req  -new -key app.key  -out app.csr
    >      ```
    >
    >3）将生成的csr证书问价发送给CA服务器
    >
    >---
    >
    >（4）CA服务器颁发证书
    >
    >```bash
    >openssl ca -in app.csr -out /etc/pki/CA/certs/app.crt -days 100
    >
    ># 查看证书中的信息
    >openssl x509 -in /etc/pki/CA/certs/app.crt -noout -serial -subject
    >```
    >
    >（5）将生成的crt证书发回客户端即可
    >
    >---
    >
    >* 吊销证书参考：https://www.cnblogs.com/along21/p/7595912.html#auto_id_5

