import ballerina/http;
import ballerina/kafka;

service /<service-name> on new http:Listener(8080) {
    // Define Kafka consumer and producer endpoints
    endpoint kafka:Consumer kafkaConsumer {
        groupId: "specialist-service-group",
        bootstrapServers: "your-bootstrap-servers"
    };

    endpoint kafka:Producer kafkaProducer {
        bootstrapServers: "your-bootstrap-servers",
        topic: "appointment-details"
    };

    resource function post processAppointmentRequest(http:Request req) {
        // Consume appointment requests from Kafka
        var result = kafkaConsumer->subscribe("appointment-requests");
        if (result is error) {
            // Handle subscription error
        }
        
        while (true) {
            var msg = kafkaConsumer->receive();
            if (msg is kafka:ConsumerRecord) {
                // Process the appointment request (simulated logic)
                json appointmentRequest = json.fromString(msg.value.toString());
                json appointmentDetails = processAppointmentRequest(appointmentRequest);

                // Publish appointment details to Kafka for the Health Admin service
                _ = kafkaProducer->send(appointmentDetails.toString());
            }
        }
    }
}

function processAppointmentRequest(json appointmentRequest) returns json {
    // Implement the logic to process the appointment request
    // Simulated logic: Return a sample appointment details
    json appointmentDetails = {
        "patientName": appointmentRequest["firstName"] + " " + appointmentRequest["lastName"],
        "specialist": appointmentRequest["specialist"],
        "appointmentDate": "2023-10-20 10:00 AM"
    };
    return appointmentDetails;
}
