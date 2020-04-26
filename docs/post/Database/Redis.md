> **This is Redis StudyNote.**

# Ubuntu下安装使用Redis

```bash
sudo apt-get update
sudo apt-get install redis-server
```

### 启动Redis

```bash
redis-server
```

### 查看Redis是否启动

```bash
redis-cli
```

### 出现以下则证明redis已成功启动

```bash
┬─[suofeiya@suofeiya-PC:~]─[19时11分00秒]
╰─>$ redis-cli
127.0.0.1:6379> ping
PONG
```

### 通过以下命令可以避免出现中文乱码

```bash
redis-cli --raw
```

### Redis 的配置文件在/etc/redis.conf，为Redis添加密码

```bash
requirepass yourpassword
```

### Redis-dump查看Redis中的数据

```bash
suofeiya@suofeiya-PC:~$ redis-dump -u :123@localhost:6379
/var/lib/gems/2.5.0/gems/redis-dump-0.4.0/lib/redis/dump.rb:32: warning: Insecure world writable dir /usr/local/bin in PATH, mode 042777
{"db":0,"key":"name_1","ttl":-1,"type":"string","value":"suofeiya","size":8}
{"db":0,"key":"name","ttl":-1,"type":"string","value":"suofeiya","size":8}
```





















