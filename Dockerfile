FROM java:8-jdk

# In case someone loses the Dockerfile
RUN rm -rf /etc/Dockerfile
ADD Dockerfile /etc/Dockerfile

# Install packages
RUN apt-get update && \
    apt-get update --fix-missing && \
    apt-get install -y wget && \
    apt-get clean

# Download and install jetty
#ENV JETTY_VERSION 9.4.9
#ENV RELEASE_DATE v20180320

RUN wget http://central.maven.org/maven2/org/eclipse/jetty/jetty-distribution/9.4.9.v20180320/jetty-distribution-9.4.9.v20180320.tar.gz && \
    tar -xzvf jetty-distribution-9.4.9.v20180320.tar.gz && \
    rm -rf jetty-distribution-9.4.9.v20180320.tar.gz && \
    mv jetty-distribution-9.4.9.v20180320/ /opt/jetty

# Configure Jetty user and clean up install
RUN useradd jetty && \
    chown -R jetty:jetty /opt/jetty && \
    rm -rf /opt/jetty/webapps.demo


# Set defaults for docker run
WORKDIR /opt/jetty

ADD oeca-svc-acl.war          /opt/jetty/webapps/oeca-svc-acl.war
ADD oeca-svc-auth.war         /opt/jetty/webapps/oeca-svc-auth.war
ADD oeca-svc-ref.war          /opt/jetty/webapps/oeca-svc-ref.war
ADD oeca-svc-registration.war /opt/jetty/webapps/oeca-svc-registration.war
ADD oeca-gmg-web.war          /opt/jetty/webapps/oeca-gmg-web.war

ADD conf.zip                   /opt/jetty/webapps/

# ADD https://bitbucket.org/sanych046/oeca-docker/raw/994808a5b692d28a556e3e2a4a94136a451064a0/test.oeca/conf.zip /opt/jetty/webapps/


RUN cd /opt/jetty/webapps && unzip conf.zip && rm conf.zip

# oeca-gmg-web
RUN cd /opt/jetty/webapps && \
mkdir WEB-INF && \
cp conf/oeca-gmg-web/*.xml WEB-INF/ && \
# cp  conf/oeca-commons-web/*.xml WEB-INF/ && \
ls && \
jar uvf oeca-gmg-web.war  WEB-INF/*.xml && \
rm -rf WEB-INF/





# CMD java -jar /opt/jetty/start.jar -Dspring.config.dir=".."

CMD java -jar /opt/jetty/start.jar -Dspring.config.dir="/opt/jetty/webapps/conf"

EXPOSE 8080

