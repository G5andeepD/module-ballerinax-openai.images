// AUTO-GENERATED FILE.
// This file is auto-generated by the Ballerina OpenAPI tool.

import ballerina/http;
import ballerina/log;


listener http:Listener httpListener = new (9090);

http:Service mockService = service object {
    # Creates an edited or extended image given an original image and a prompt.
    #
    # + return - OK 
    resource function post images/edits(http:Request request) returns ImagesResponse {
        
        ImagesResponse response = {
            created: 1625460000,
            data: [
                {
                    url: "https://example.com/edited_image.png",
                    revised_prompt: "A sunny beach with palm trees"
                }
            ]
        };

        return response;
    }

    # Creates an image given a prompt.
    #
    # + return - OK 
    resource function post images/generations(@http:Payload CreateImageRequest payload) returns ImagesResponse {
        ImagesResponse response = {
            created: 1625460000,
            data: [
                {
                    url: "https://example.com/generated_image.png"
                }
            ]
        };
        return response;
    }

    # Creates a variation of a given image.
    #
    # + return - OK 
    resource function post images/variations(http:Request request) returns ImagesResponse {
        
        
        ImagesResponse response2 = {
            created: 123123,
            data: [
                {
                    url: "342ffer4"
                }
            ]
        };
        
        return response2;
    }
};

function init() returns error? {
     if isLiveServer {
        log:printInfo("Skiping mock server initialization as the tests are running on live server");
        return;
    }
    log:printInfo("Initiating mock server");
    check httpListener.attach(mockService, "/");
    check httpListener.'start();
}