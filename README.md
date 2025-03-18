# deployment

## envs/database.env

```
MYSQL_ROOT_PASSWORD=test123
MYSQL_DATABASE=escape
MYSQL_USER=testuser
MYSQL_PASSWORD=testpassword
```

## envs/kafka.env

```
# Configure listeners for both docker and host communication
KAFKA_LISTENERS: CONTROLLER://localhost:9091,HOST://0.0.0.0:9092,DOCKER://0.0.0.0:9093
KAFKA_ADVERTISED_LISTENERS: HOST://localhost:9092,DOCKER://kafka:9093
KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: CONTROLLER:PLAINTEXT,DOCKER:PLAINTEXT,HOST:PLAINTEXT

# Settings required for KRaft mode
KAFKA_NODE_ID: 1
KAFKA_PROCESS_ROLES: broker,controller
KAFKA_CONTROLLER_LISTENER_NAMES: CONTROLLER
KAFKA_CONTROLLER_QUORUM_VOTERS: 1@localhost:9091

# Listener to use for broker-to-broker communication
KAFKA_INTER_BROKER_LISTENER_NAME: DOCKER

# Required for a single node cluster
KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: 1
```