FROM docker:1.592

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

# Get the Jenkins plugins we need and install them


USER jenkins

# from a derived Dockerfile, can use `RUN plugin.sh active.txt` to setup /usr/share/jenkins/ref/plugins from a support bundle
COPY plugins.sh /usr/local/bin/plugins.sh

COPY plugins.txt /usr/share/jenkins/plugins.txt

COPY jenkins.sh /usr/local/bin/jenkins.sh

RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

ENTRYPOINT ["/usr/local/bin/jenkins.sh"]
