#!/bin/bash

# Get link from https://www.java.com/en/download/manual.jsp

mkdir -p /usr/lib/java && cd /usr/lib/java

curl -L -o java.tar.gz https://javadl.oracle.com/webapps/download/AutoDL?BundleId=244058_89d678f2be164786b292527658ca1605 && \
  tar zxvf java.tar.gz && rm java.tar.gz && \
  ln -s "/usr/lib/java/$(ls /usr/lib/java | grep jre)/bin/java" /usr/bin/java 

# Test
java -version