import ballerina/http;
import ballerina/kafka;

service /health-admin on new http:Listener(8080) {
    // Define Kafka producer endpoint
    endpoint kafka:Producer kafkaProducer {
        bootstrapServers: "your-bootstrap-servers",
        topic:"appointment-requests"
    };

    resource function post sendAppointmentRequest(http:Request req) {
        // Extract patient appointment request
        json appointmentRequest = req.getJsonPayload();

        // Publish the request to Kafka
        _ = kafkaProducer->send(appointmentRequest.toString());

        // Process the request and find appointments (simulated logic)
        json appointmentResponse = processAppointmentRequest(appointmentRequest);

        // Respond to the patient
        http:Response res = new;
        res.setJsonPayload(appointmentResponse);
        _ = req->respond(res);
    }
}

function processAppointmentRequest(json appointmentRequest) returns json {
    // Implement the logic to find appointments based on the request
    // Simulated logic: Return a sample response
    json appointmentResponse = {
        "patientName": appointmentRequest["firstName"] + " " + appointmentRequest["lastName"],
        "specialist": appointmentRequest["specialist"],
        "appointmentDate": "2023-10-20 10:00 AM"
    };
    return appointmentResponse;
}
