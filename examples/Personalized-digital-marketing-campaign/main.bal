// import ballerina/io;
// import ballerina/mime;

// configurable string apiKey = ?;

// // Initialize the OpenAI Images client with your API key
// final Client openaiClient = check new ({
//         auth: {
//             token: apiKey
//         }
// });

// public function main() returns error? {
//     // Step 1: Generate a base image using the `images/generation` API
//     string generationPrompt = "A futuristic smartphone with holographic display, sleek design, and glowing edges, displayed in a modern, high-tech environment.";

//     CreateImageRequest generationRequest = {
//         prompt: generationPrompt,
//         model: "dall-e-2",
//         n: 1,
//         response_format: "b64_json"
//     };

//     ImagesResponse generationResponse = check openaiClient->/images/generations.post(generationRequest);

//     // Save the generated image in base64 format
//     string? base64Image = generationResponse.data[0].b64_json;

//     if (base64Image is string) {
//         // Decode the base64 string to get image bytes
//         string|byte[]|io:ReadableByteChannel|mime:DecodeError imageBytes = mime:base64Decode(base64Image.toBytes());
//         if (imageBytes is byte[]) {
//             // Save the base image to a file
//             error? saveBaseImageResult = io:fileWriteBytes("base_smartphone_image.png", imageBytes);

//             if (saveBaseImageResult is error) {
//                 io:println("Error writing the base image to a file: ", saveBaseImageResult);
//             } else {
//                 io:println("Base image saved successfully!");
//             }

//             // Read the saved image back to get its byte content
//             byte[] baseImageBytes = check io:fileReadBytes("base_smartphone_image.png");

//             // Step 2: Create a variation of the base image using the `images/variations` API
//             CreateImageVariationRequest variationRequest = {
//                 image: {
//                     fileContent: baseImageBytes,
//                     fileName: "base_smartphone_image.png"
//                 },
//                 model: "dall-e-2",
//                 n: 1,
//                 size: "1024x1024",
//                 response_format: "b64_json"
//             };

//             ImagesResponse variationResponse = check openaiClient->/images/variations.post(variationRequest);

//             // Save the variation image in base64 format
//             string? variationBase64Image = variationResponse.data[0].b64_json;

//             if (variationBase64Image is string) {
//                 // Decode the base64 string to get variation image bytes
//                 string|byte[]|io:ReadableByteChannel|mime:DecodeError variationImageBytes = mime:base64Decode(variationBase64Image.toBytes());
//                 if (variationImageBytes is byte[]) {
//                     // Save the variation image to a file
//                     error? saveVariationImageResult = io:fileWriteBytes("variation_smartphone_image.png", variationImageBytes);

//                     if (saveVariationImageResult is error) {
//                         io:println("Error writing the variation image to a file: ", saveVariationImageResult);
//                     } else {
//                         io:println("Variation image saved successfully!");
//                     }
//                 }
//             }

//             // Step 3: Edit the generated image using the `images/edit` API
//             CreateImageEditRequest editRequest = {
//                 image: {
//                     fileContent: baseImageBytes,
//                     fileName: "base_image.png"
//                 },
//                 prompt: "Add the text 'Coming Soon' with a glowing effect at the bottom of the image.",
//                 n: 1,
//                 size: "1024x1024",
//                 response_format: "b64_json"
//             };

//             ImagesResponse editResponse = check openaiClient->/images/edits.post(editRequest);

//             // Save the edited image in base64 format
//             string? editedBase64Image = editResponse.data[0].b64_json;

//             if (editedBase64Image is string) {
//                 // Decode the base64 string to get edited image bytes
//                 string|byte[]|io:ReadableByteChannel|mime:DecodeError editedImageBytes = mime:base64Decode(editedBase64Image.toBytes());
//                 if (editedImageBytes is byte[]) {
//                     // Save the edited image to a file
//                     error? saveEditedImageResult = io:fileWriteBytes("edited_smartphone_image.png", editedImageBytes);

//                     if (saveEditedImageResult is error) {
//                         io:println("Error writing the edited image to a file: ", saveEditedImageResult);
//                     } else {
//                         io:println("Edited image saved successfully!");
//                     }
//                 }
//             }
//         }
//     }
// }
