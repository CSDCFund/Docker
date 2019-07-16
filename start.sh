#!/bin/bash
repositoryname=xiaoqian666/csdc

workdir=$(pwd)
port=30399
httport=8500
#delet old image begin
imageoldid=`/usr/bin/docker images| grep xiaoqian666/csdc|grep -v image| awk '{print $3}'|head -n 1`
if [ ! -n "$imageoldid" ]; then
  echo "imageoldid is null"
else
  containerid=`/usr/bin/docker ps -a| grep ${imageoldid}|grep -v CONTAINER| awk '{print $1}'|head -n 1`
  if [ ! -n "$containerid" ]; then
    echo "containerid is null"
  else
  /usr/bin/docker stop ${containerid}  >/dev/null 2>&1
  /usr/bin/docker rm   ${containerid}  >/dev/null 2>&1
  echo delete container ${containerid}
  fi  
  /usr/bin/docker image rm -f ${imageoldid} 
  echo delete image ${imageoldid}
fi
#delet old image end
#download new image and start container begin
docker pull ${repositoryname}:latest
imagenewid=`/usr/bin/docker images| grep xiaoqian666/csdc|grep -v image| awk '{print $3}'|head -n 1`
if [ ! -d "${workdir}/docker" ];then
  mkdir ${workdir}/docker -p
    else
  echo "the dockerdirect is exits"
    fi
    if [ ! -f "${workdir}/run.sh" ];then
      echo "run.sh not exits"
        else
     cp ${workdir}/run.sh ${workdir}/docker/
        fi
     if [ ! -f "${workdir}/swarm.toml" ];then
       echo "swarm.toml not exits"
        else
      cp ${workdir}/swarm.toml ${workdir}/docker/
        fi
   rm -rf  ${workdir}/docker/out.log 
 /usr/bin/docker run -p $port:$port/tcp -p $port:$port/udp -p $httport:8500/tcp --cap-add=NET_ADMIN -v ${workdir}/docker:/config  -d  --name eswarm $imagenewid
 #download new image and start container end