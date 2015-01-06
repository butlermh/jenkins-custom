# FROM jenkins:1.584

# The version of Jenkins we need isn't on Docker hub yet ...
# Replace this with an include when it is ...

######################################

FROM java:openjdk-7u65-jdk

RUN apt-get update && apt-get install -y wget git curl zip && rm -rf /var/lib/apt/lists/*

ENV JENKINS_HOME /var/jenkins_home

# Jenkins is ran with user `jenkins`, uid = 1000
# If you bind mount a volume from host/vloume from a data container, 
# ensure you use same uid
RUN useradd -d "$JENKINS_HOME" -u 1000 -m -s /bin/bash jenkins

# Jenkins home directoy is a volume, so configuration and build history 
# can be persisted and survive image upgrades
VOLUME /var/jenkins_home

# `/usr/share/jenkins/ref/` contains all reference configuration we want 
# to set on a fresh new installation. Use it to bundle additional plugins 
# or config file with your custom jenkins Docker image.
RUN mkdir -p /usr/share/jenkins/ref/init.groovy.d


COPY init.groovy /usr/share/jenkins/ref/init.groovy.d/tcp-slave-angent-port.groovy

ENV JENKINS_VERSION 1.595

# could use ADD but this one does not check Last-Modified header 
# see https://github.com/docker/docker/issues/8331
RUN curl -L http://mirrors.jenkins-ci.org/war/1.595/jenkins.war -o /usr/share/jenkins/jenkins.war

ENV JENKINS_UC https://updates.jenkins-ci.org
RUN chown -R jenkins "$JENKINS_HOME" /usr/share/jenkins/ref

# for main web interface:
EXPOSE 8080

# will be used by attached slave agents:
EXPOSE 50000

##################################

RUN \
  curl -L -o sbt-0.13.7.deb https://dl.bintray.com/sbt/debian/sbt-0.13.7.deb && \
  dpkg -i sbt-0.13.7.deb && \
  rm sbt-0.13.7.deb && \
  apt-get update && \
  apt-get install sbt

# Install vagrant

# RUN cat /etc/*-release

RUN apt-get install -yq vagrant

RUN apt-get install -yq libgsoap5 libpython2.7 libsdl1.2debian libvncserver0 libvpx1 libxmu6 

RUN curl -L -o virtualbox_4.3.18-dfsg-1_amd64.deb http://ftp.us.debian.org/debian/pool/contrib/v/virtualbox/virtualbox_4.3.18-dfsg-1_amd64.deb
RUN dpkg -i virtualbox_4.3.18-dfsg-1_amd64.deb
RUN rm virtualbox_4.3.18-dfsg-1_amd64.deb
RUN apt-get update
RUN apt-get install virtualbox

# Install protobuf

RUN apt-get install -yq protobuf-compiler libprotobuf-java

#Sonar Runner
RUN wget http://repo1.maven.org/maven2/org/codehaus/sonar/runner/sonar-runner-dist/2.4/sonar-runner-dist-2.4.zip && \
    unzip sonar-runner*zip && \
    rm sonar-runner*zip && \
    mv sonar-runner* sonar-runner

USER jenkins

# Get the Jenkins plugins we need and install them

COPY plugins.txt /usr/share/jenkins/plugins.txt

COPY jenkins.sh /usr/local/bin/jenkins.sh
ENTRYPOINT ["/usr/local/bin/jenkins.sh"]

# from a derived Dockerfile, can use `RUN plugin.sh active.txt` to setup /usr/share/jenkins/ref/plugins from a support bundle
COPY plugins.sh /usr/local/bin/plugins.sh

RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
