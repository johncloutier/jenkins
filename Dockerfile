FROM jenkins 
MAINTAINER John Cloutier "itsjohncloutier@gmail.com"

USER root

#COPY ashbmcwg.crt /usr/local/share/ca-certificates/
#RUN update-ca-certificates

RUN apt-get update && apt-get install parallel npm nodejs-legacy docker.io ruby-full netcat -y
RUN npm install -g bower grunt-cli npm-cache
RUN gem install sass
RUN gem install compass

RUN wget --no-verbose -O /tmp/apache-maven-3.2.2.tar.gz http://archive.apache.org/dist/maven/maven-3/3.2.2/binaries/apache-maven-3.2.2-bin.tar.gz
RUN tar xzf /tmp/apache-maven-3.2.2.tar.gz -C /opt/
RUN ln -s /opt/apache-maven-3.2.2 /opt/maven
RUN ln -s /opt/maven/bin/mvn /usr/local/bin
RUN rm -f /tmp/apache-maven-3.2.2.tar.gz
ENV MAVEN_HOME /opt/maven

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
#RUN cp -r plugins/ /usr/share/jenkins/ref/
#ADD plugins /usr/share/jenkins/ref/plugins/

USER jenkins

RUN mkdir /var/jenkins_home/workspace

COPY groovy/*.groovy /usr/share/jenkins/ref/init.groovy.d/

ENTRYPOINT ["/usr/local/bin/jenkins.sh"]
