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
    string generationPrompt = "A futuristic smartphone with holographic display, sleek design, and glowing edges, displayed in a modern, high-tech environment.";

    CreateImageRequest generationRequest = {
        prompt: generationPrompt,
        model: "dall-e-2",
        n: 1,
        response_format: "b64_json",
        size:"512x512"
    };

    ImagesResponse generationResponse = check openaiClient->/images/generations.post(generationRequest);

    // Save the generated image in base64 format
    string? base64Image = generationResponse.data[0].b64_json;

    if (base64Image is string) {
        // Decode the base64 string to get image bytes
        string|byte[]|io:ReadableByteChannel|mime:DecodeError imageBytes = mime:base64Decode(base64Image.toBytes());
        if (imageBytes is byte[]) {
            // Save the base image to a file
            error? saveBaseImageResult = io:fileWriteBytes("base_smartphone_image.png", imageBytes);

            if (saveBaseImageResult is error) {
                io:println("Error writing the base image to a file: ", saveBaseImageResult);
            } else {
                io:println("Base image saved successfully!");
            }

            // Read the saved image back to get its byte content
            byte[] baseImageBytes = check io:fileReadBytes("base_smartphone_image.png");

            byte[] baseImageBytesRGBA = convertRGBtoRGBA(baseImageBytes,512,512);

            io:print(baseImageBytesRGBA.length());

            // Step 3: Edit the generated image using the `images/edit` API
            CreateImageEditRequest editRequest = {
                image: {
                    fileContent: baseImageBytesRGBA,
                    fileName: "base_smartphone_image.png"
                },
                prompt: "Add the text 'Coming Soon' with a glowing effect at the bottom of the image.",
                n: 1,
                size: "512x512",
                response_format: "b64_json"
            };

            ImagesResponse editResponse = check openaiClient->/images/edits.post(editRequest);

            // Save the edited image in base64 format
            string? editedBase64Image = editResponse.data[0].b64_json;

            if (editedBase64Image is string) {
                // Decode the base64 string to get edited image bytes
                string|byte[]|io:ReadableByteChannel|mime:DecodeError editedImageBytes = mime:base64Decode(editedBase64Image.toBytes());
                if (editedImageBytes is byte[]) {
                    // Save the edited image to a file
                    error? saveEditedImageResult = io:fileWriteBytes("edited_smartphone_image.png", editedImageBytes);

                    if (saveEditedImageResult is error) {
                        io:println("Error writing the edited image to a file: ", saveEditedImageResult);
                    } else {
                        io:println("Edited image saved successfully!");
                    }
                }
            }
        }
    }
}

// public function main() returns error? {

//     byte[] baseImageBytes = check io:fileReadBytes("base_smartphone_image.png");

//     io:println(baseImageBytes.length());

//     byte[] baseImageBytesRGBA = convertRGBtoRGBA(baseImageBytes,512,512);

//     io:print(baseImageBytesRGBA.length());
// }

function convertRGBtoRGBA(byte[] rgbImage, int width, int height) returns byte[] {
    byte[] rgbaImage = [];
    int pixelCount = width * height;

    foreach int i in 0..<pixelCount {
        int index = i * 3;
        byte red = rgbImage[index];
        byte green = rgbImage[index + 1];
        byte blue = rgbImage[index + 2];
        byte alpha = 255; // Full opacity

        // Append the RGBA values to the new image array
        rgbaImage.push(red);
        rgbaImage.push(green);
        rgbaImage.push(blue);
        rgbaImage.push(alpha);
    }

    //push the rest of the original array to new array
    //pixelCount to the end of the array
    foreach int i in pixelCount..<rgbImage.length() {
        rgbaImage.push(rgbImage[i]);
    }

    return rgbaImage;
}

