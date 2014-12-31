FROM jenkins:1.554.3

USER root

RUN \
  curl -L -o sbt-0.13.7.deb https://dl.bintray.com/sbt/debian/sbt-0.13.7.deb && \
  dpkg -i sbt-0.13.7.deb && \
  rm sbt-0.13.7.deb && \
  apt-get update && \
  apt-get install sbt 

# Install vagrant

# RUN cat /etc/*-release

RUN apt-get install -yq vagrant

# we need virtualbox
# RUN apt-get install -yq vbox

# Install protobuf

RUN apt-get install -yq protobuf-compiler libprotobuf-java

# Get the Jenkins plugins we need and install them

COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

USER jenkins 

ENTRYPOINT ["/usr/local/bin/jenkins.sh"]
