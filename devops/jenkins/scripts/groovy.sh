#!/bin/bash

install(){
  # install java
  sudo apt-get install default-jdk zip -y

  # install sdkman and groovy
  curl -s get.sdkman.io | bash
  source "$HOME/.sdkman/bin/sdkman-init.sh"
  sdk install groovy
  groovy -version
}

$*