import ballerina/test;
import ballerina/io;


configurable boolean isLiveServer = ?;
configurable string apiKey = ?;
configurable string RuntimeApiKey = isLiveServer ? apiKey : "test";
configurable string serviceUrl = isLiveServer ? "https://api.openai.com/v1" : "http://localhost:9090";

ConnectionConfig config = {auth: {
    token:RuntimeApiKey}
    };
final Client openaiClient = check new(config,serviceUrl);

@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testSendImageVariationRequest() returns error? {
    // Assuming you have the base64 encoded content of the sample image
    byte[] sampleImageContent = check io:fileReadBytes("tests/icon.png");

    CreateImageVariationRequest request = {
        image: {
            fileContent: sampleImageContent,
            fileName: "icon.png"
        },
        model: "dall-e-2",
        n: 1,
        size: "1024x1024",
        response_format: "url"
    };

    // Call the `post images/variations` resource to create a variation of an image
    var response = openaiClient->/images/variations.post(request);
    if (response is ImagesResponse) {
        io:println("Created images: ", response.data);
    }
    else{
        io:println("Error: ", response);
    }
    test:assertTrue(response is ImagesResponse, msg = "Response is not of type ImagesResponse");
    

    return;
}



@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testSendImageEditRequest() returns error? {
    // Assuming you have the base64 encoded content of the sample image
    byte[] sampleImageContent = check io:fileReadBytes("tests/icon.png");    

    CreateImageEditRequest request = {
        image: {
            fileContent: sampleImageContent,
            fileName: "icon.png"
        },
        prompt: "Provide a description of the desired edits here.",
        model: "dall-e-2",
        n: 1,
        size: "1024x1024",
        response_format: "url"
    };

    // Call the `post images/edits` resource to create an edited image
    var response = openaiClient->/images/edits.post(request);
    if (response is ImagesResponse) {
        io:println("Created images: ", response.data);
    }
    else{
        io:println("Error: ", response);
    }

    test:assertTrue(response is ImagesResponse, msg = "Response is not of type ImagesResponse");
    
    return;

    
}


@test:Config {
    groups: ["live_tests", "mock_tests"]
}
isolated function testSendImageGenerateRequest() returns error? {
    CreateImageRequest request = {
        prompt: "a cute baby sea otter",
        model: "dall-e-3",
        n: 1,
        response_format: "url"
    };

    // Call the `post images/generations` resource to create an image
    var response = openaiClient->/images/generations.post(request);

    if (response is ImagesResponse) {
        io:println("Created images: ", response.data);
    }

    else {
        io:println("Error: ", response);
    }
    test:assertTrue(response is ImagesResponse, msg = "Response is not of type ImagesResponse");
    

    return;
}


