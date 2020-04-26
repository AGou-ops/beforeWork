> **This is MongoDB StudyNote.**

# MongoDB安装（CenOS）

* ```bash
  #　MonogoDB官网https://www.mongodb.com/download-center#community
  # 下载到本地
curl -O https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.0.6.tgz
  #　解压
  tar -zxvf mongodb-linux-x86_64-3.0.6.tg
  # 拷贝解压包到指定文件夹
  mv  mongodb-linux-x86_64-3.0.6/ /usr/local/mongodb 
  # 在/etc/profile中添加环境变量
  export PATH=<mongodb-install-directory>/bin:$PATH
  # 使环境变量生效
  source /etc/profile
  ```
  
*  ```bash
    # mongoDB 配置文件
    [root@centos mongodb]# cat mongodb.conf
    port=27017 #端口
    dbpath= /data/db #数据库存文件存放目录
    logpath= /usr/local/mongodb/log/mongodb.log #日志文件存放路径
    logappend=true #使用追加的方式写日志
    fork=true #以守护进程的方式运行，创建服务器进程
    maxConns=100 #最大同时连接数
    noauth=true #不启用验证
    journal=true #每次写入会记录一条操作日志（通过journal可以重新构造出写入的数据）。
    #即使宕机，启动时wiredtiger会先将数据恢复到最近一次的checkpoint点，然后重放后续的journal日志来恢复。
    storageEngine=wiredTiger  #存储引擎有mmapv1、wiretiger、mongorocks
    bind_ip = 0.0.0.0  #这样就可外部访问了，例如从win10中去连虚拟机中的MongoDB
  ```
  
* ```bash
  # 为MonogoDB创建后台服务
  sudo vim /etc/systemd/system/mongdb.service
  [Unit]
  Description=High-performance, schema-free document-oriented database
  After=network.target
  [Service]
  User=mongodb
  ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf
  [Install]
   WantedBy=multi-user.target
  ```

* 

* #### mongoDB中的数据表称为collection

* #### 一行数据称为table

* #### 数据字段称为field

* #### mongoDB不支持join表连接

* #### use 数据库名称,可以用来创建数据库

* #### db.集合名称.insert\({"username"："suofeiya","age":"21"}\) db.dropDatabase\(\)

* #### db.集合名称.deleteOne\({}\)

* #### db.集合名称.deleteMany\({}\)



