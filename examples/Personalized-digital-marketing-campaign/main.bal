import ballerina/io;
import ballerina/mime;

configurable string apiKey = ?;

// Initialize the OpenAI Images client with your API key
final Client openaiClient = check new ({
        auth: {
            token: apiKey
        }
});

public function main() returns error? {

    // Step 1: Generate a base image using the `images/generation` API
    string generationPrompt = "a model wearing a summer dress in a vibrant city background";

    CreateImageRequest request = {
        prompt: generationPrompt,
        model: "dall-e-3",
        n: 1,
        response_format: "b64_json"
    };

    ImagesResponse generationResponse = check openaiClient->/images/generations.post(request);

    //io:println(generationResponse.data);

    //save the base64_json to a file
    string? base64Json = generationResponse.data[0].b64_json;

    if (base64Json is string) {
        string|byte[]|io:ReadableByteChannel|mime:DecodeError imageBytes = mime:base64Decode(base64Json.toBytes());
        if (imageBytes is byte[]) {
            // Save the base image to a file
            error? result = io:fileWriteBytes("base_image.png", imageBytes);

            if (result is error) {
                io:println("Error writing the base image to a file: ", result);
            } else {
                io:println("Base image saved successfully!");
            }

            // Do a few edits on the base image

            byte[] reReadImageBytes = check io:fileReadBytes("base_image.png");

            CreateImageEditRequest editRequest = {
                image: {
                    fileContent: reReadImageBytes,
                    fileName: "base_image.png"
                },
                prompt: "add text overlay: 'Special offer just for you'",
                model: "dall-e-2",
                n: 1,
                size: "1024x1024",
                response_format: "b64_json"
            };

            ImagesResponse editResponse = check openaiClient->/images/edits.post(editRequest);

            //io:println(editResponse.data);

            //save the edited image to a file
            string? editedBase64Json = editResponse.data[0].b64_json;

            if (editedBase64Json is string) {
                string|byte[]|io:ReadableByteChannel|mime:DecodeError editedImageBytes = mime:base64Decode(editedBase64Json.toBytes());
                if (editedImageBytes is byte[]) {
                    // Save the edited image to a file
                    error? editSaveResult = io:fileWriteBytes("edited_image.png", editedImageBytes);

                    if (editSaveResult is error) {
                        io:println("Error writing the edited image to a file: ", result);
                    } else {
                        io:println("Edited image saved successfully!");
                    }
                }
            }

        }

    }

}
