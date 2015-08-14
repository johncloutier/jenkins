FROM jenkins 
MAINTAINER John Cloutier "itsjohncloutier@gmail.com"

USER root

#COPY ashbmcwg.crt /usr/local/share/ca-certificates/
#RUN update-ca-certificates

RUN apt-get update && apt-get install parallel npm nodejs-legacy docker.io ruby-full netcat -y
RUN npm install -g bower grunt-cli npm-cache
RUN gem install sass
RUN gem install compass

WORKDIR /usr/local
RUN mkdir /usr/local/ec2
RUN curl -O http://s3.amazonaws.com/ec2-downloads/ec2-api-tools.zip
RUN unzip ec2-api-tools.zip -d /usr/local/ec2
RUN rm ec2-api-tools.zip
RUN ln -s ec2/ec2* ec2-api-tools
RUN curl -L https://github.com/docker/compose/releases/download/1.3.3/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose 
RUN chmod +x /usr/local/bin/docker-compose
ENV EC2_HOME /usr/local/ec2-api-tools
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

COPY plugins.sh /usr/local/bin/plugins.sh
RUN chmod +x /usr/local/bin/plugins.sh

USER jenkins

ADD plugins /usr/share/jenkins/ref/plugins/

ENTRYPOINT ["/usr/local/bin/jenkins.sh"]
