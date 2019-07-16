##说明
这是云链挖矿节点Docker安装方案

###系统需求
1. 可连接公网 有公网IP或者端口(30399 TCP/UDP)映射到了公网
2. 系统中已经安装了Docker

### 安装方法
git clone https://github.com/CSDCFund/Docker.git eswarm

cd eswarm

./start.sh

*备注*
执行脚本需要从dockhub上下载镜像，因此需要一段安装时间

### 验证执行结果
tail -f ./out.log 能够看到实时的输出