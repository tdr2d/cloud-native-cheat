#!/bin/bash

set -eui pipefail

# https://logz.io/blog/kafka-logging/

## Updates, Zookeeper, Kafka
sudo apt-get update
sudo apt-get install default-jre
sudo apt-get install zookeeperd
netstat -nlpt | grep ':2181'
wget https://apache.mivzakim.net/kafka/2.2.0/kafka_2.12-2.2.0.tgz
tar -xvzf kafka_2.12-2.2.0.tgz
sudo cp -r kafka_2.12-2.2.0 /opt/kafka
sudo /opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
/opt/kafka/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1  --partitions 1 --topic danielTest

## Testing Consoles
/opt/kafka/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic danielTest
/opt/kafka/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic danielTest --from-beginning


## Kafka logs into the Elastic Stack
sudo apt install filebeat
cat << EOF > /etc/filebeat/modules.d/kafka.yml.disabled
- module: kafka
   log:
    enabled: true
    #var.kafka_home:
    var.paths:
      - "/opt/kafka/logs/server.log"
EOF
sudo filebeat modules enable kafka
sudo filebeat setup -e
sudo service filebeat restart