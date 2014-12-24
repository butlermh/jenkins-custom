FROM jenkins:latest

USER root

RUN \
  curl -L -o sbt-0.13.7.deb https://dl.bintray.com/sbt/debian/sbt-0.13.7.deb && \
  dpkg -i sbt-0.13.7.deb && \
  rm sbt-0.13.7.deb && \
  apt-get update && \
  apt-get install sbt 

# Get the Jenkins plugins we need and install them
RUN mkdir -p /tmp/WEB-INF/plugins

# Github-API plugin

RUN curl -L http://updates.jenkins-ci.org/latest/github-api.hpi -o /tmp/WEB-INF/plugins/github-api.hpi

# Github OAuth plugin
RUN curl -L http://updates.jenkins-ci.org/latest/github-oauth.hpi -o /tmp/WEB-INF/plugins/github-oauth.hpi 

# Github pull-request plugin
RUN curl -L http://updates.jenkins-ci.org/latest/ghprb.hpi -o /tmp/WEB-INF/plugins/ghprb.hpi 

# SBT plugin
RUN curl -L http://updates.jenkins-ci.org/latest/sbt.hpi -o /tmp/WEB-INF/plugins/sbt.hpi 

# Grow the Jenkins WAR with the plugins
RUN cd /tmp; zip --grow /usr/share/jenkins/jenkins.war WEB-INF/* 

RUN apt-get install -yq protobuf-compiler libprotobuf-java

USER jenkins # drop back to the regular jenkins user - good practice

ENTRYPOINT ["/usr/local/bin/jenkins.sh"]
