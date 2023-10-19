import ballerina/kafka;

public function main() {
    // Define Kafka producer endpoint
    endpoint kafka:Producer kafkaProducer {
        bootstrapServers: "your-bootstrap-servers",
        topic: "Health"
    };

    // Send messages using the Kafka producer
    var result = kafkaProducer->send("Your message content");

    if (result is error) {
        // Handle error
        io:println("Failed to send message: " + result.reason().message);
    } else {
        io:println("Message sent successfully");
    }
}

