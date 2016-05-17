FROM jenkins 
MAINTAINER John Cloutier "itsjohncloutier@gmail.com"

USER root

#COPY ashbmcwg.crt /usr/local/share/ca-certificates/
#RUN update-ca-certificates

RUN apt-get update && apt-get install parallel npm nodejs-legacy docker.io ruby-full netcat default-jdk -y
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

RUN mkdir /usr/local/jenkins
WORKDIR /usr/local/jenkins
ADD jobs/ ./jobs
ADD plugins.* ./
RUN chmod +x plugins.sh
RUN ./plugins.sh plugins.txt
ENV JENKINS_SLAVE_AGENT_PORT 50001

USER jenkins

COPY groovy/*.groovy /usr/share/jenkins/ref/init.groovy.d/

ENTRYPOINT ["/usr/local/bin/jenkins.sh"]
