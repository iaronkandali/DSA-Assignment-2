import ballerina/kafka;

public function main() {
    // Define Kafka consumer endpoint
    endpoint kafka:Consumer kafkaConsumer {
        groupId: "23",
        bootstrapServers: "your-bootstrap-servers",
        topics: ["appointment-requests"]
    };

    // Subscribe to Kafka topics and process messages
    var result = kafkaConsumer->subscribe("appointment-requests");

    if (result is error) {
        // Handle subscription error
        io:println("Failed to subscribe to Kafka topic: " + result.reason().message);
    } else {
        // Continuously consume and process messages
        while (true) {
            var msg = kafkaConsumer->receive();
            if (msg is kafka:ConsumerRecord) {
                // Process the received message
                io:println("Received message: " + msg.value.toString());
            }
        }
    }
}
