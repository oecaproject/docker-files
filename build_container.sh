#!/usr/bin/env bash

# https://www.dedoimedo.com/computers/docker-networking.html#mozTocId605223
#
# in the 3 places of sources it is necessary to change data sources
# <!--<property name="url" value="jdbc:<mysql://localhost:3306/oeca"/>--&gt>;
# <property name="url" value="jdbc:<mysql://mysql55:3306/oeca"/&gt>;
#

#build MySQL 5.5 docker container
docker run -d -ti -p 3306 --name=mysql55  -p 3306:3306 -e MYSQL_ROOT_PASSWORD=password -e MYSQL_DATABASE=test1 -e MYSQL_USER=test1 -e MYSQL_PASSWORD=test1 -d mysql/mysql-server:5.5

docker exec -it mysql55 mysql -uroot -p

ALTER USER 'root'@'localhost' IDENTIFIED BY 'password';


CREATE USER 'test'@'localhost'  IDENTIFIED BY 'test';
GRANT ALL PRIVILEGES ON *.* TO 'test'@'localhost'WITH GRANT OPTION;
CREATE USER 'test'@'%'  IDENTIFIED BY 'test';
GRANT ALL PRIVILEGES ON *.* TO 'test'@'%'WITH GRANT OPTION;

CREATE DATABASE oeca  CHARACTER SET utf8  COLLATE utf8_general_ci;
CREATE DATABASE oeca_gmg  CHARACTER SET utf8  COLLATE utf8_general_ci;

exit
#---------------
docker inspect oeca | grep -i ipaddr

# test
# nc -w1 -v 172.17.0.6 8082

wget https://github.com/oecaproject/docker-files/raw/master/oeca-gmg-web.war
wget https://github.com/oecaproject/docker-files/raw/master/oeca-svc-acl.war
wget https://github.com/oecaproject/docker-files/raw/master/oeca-svc-auth.war
wget https://github.com/oecaproject/docker-files/raw/master/oeca-svc-ref.war
wget https://github.com/oecaproject/docker-files/raw/master/oeca-svc-registration.war

wget https://github.com/oecaproject/docker-files/raw/master/src.zip


#build image
docker build -t jettyoeca .
do
#run the container
docker run -d -ti --name oeca --link mysql55:mysql55 -p 8082:8080 jettyoeca



#build test image
docker build -t jettyoecatest .
do
#run the container
docker run -d -ti --name oecatest --link mysql55:mysql55 -p 8083:8080 jettyoecatest

test.oeca
#build image
docker build -t jettyoecademo .

#run the container
docker run -d -ti --name oecademo --link mysql55:mysql55 -p 8083:8080 jettyoecademo