jenkins-custom
==============

Custom Dockerfile for Jenkins building Scala projects hosted on Github

It is based on `butlermh/jenkins`. This is not a custom version of Jenkins - it's the version 

To build

    docker build -t="butlermh/custom-jenkins" .

To deploy to DockerHub:

    docker push butlermh/custom-jenkins
    
To run - use a specific volume to persist the Jenkins data even if you upgrade Jenkins

    docker run -p 8080:8080 --name jenkins -v /home/mark_virtualpowersystems_com/jenkins:/var/jenkins_home --privileged -d butlermh/custom-jenkins 

To upgrade

    docker pull butlermh/custom-jenkins
    docker stop butlermh/custom-jenkins
    docker rm butlermh/custom-jenkins
