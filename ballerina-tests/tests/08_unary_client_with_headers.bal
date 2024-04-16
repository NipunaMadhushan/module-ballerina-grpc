// Copyright (c) 2021 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/grpc;
import ballerina/test;
import ballerina/protobuf.types.wrappers;

// Client endpoint configuration
final HelloWorld101Client helloWorld8BlockingEp = check new ("http://localhost:9098");

@test:Config {enable: true}
function testHeadersInUnaryClient() returns grpc:Error? {
    //Working with custom headers
    wrappers:ContextString requestMessage = {content: "WSO2", headers: {"x-id": "0987654321"}};
    // Executing unary blocking call
    wrappers:ContextString response = check helloWorld8BlockingEp->helloContext(requestMessage);
    map<string|string[]> resHeaders = response.headers;
    if resHeaders.hasKey("x-id") {
        _ = resHeaders.remove("x-id");
    }
    test:assertEquals(response.content, "Hello WSO2");
}

@test:Config {enable: true}
function testHeadersInBlockingClient() returns grpc:Error? {
    wrappers:ContextString requestMessage = {content: "WSO2", headers: {"x-id": "0987654321"}};
    // Executing unary blocking call
    wrappers:ContextString response = check helloWorld8BlockingEp->helloContext(requestMessage);
    map<string|string[]> resHeaders = response.headers;
    test:assertEquals(check grpc:getHeaders(resHeaders, "x-id"), ["1234567890", "2233445677"]);
}

@test:Config {enable: true}
function testLargeHeaderSize() returns grpc:Error? {
    wrappers:ContextString requestMessage = {content: "WSO2", headers: {"large-header": "09876543210987654321098765432109876543210987654321098765432109876543210987654321098765432109876543210987654321098765432109876543210987654321098765432109876543210987654321"}};
    wrappers:ContextString|grpc:Error response = helloWorld8BlockingEp->helloContext(requestMessage);
    if response is grpc:Error {
        test:assertEquals(response.message(), "Header size exceeded max allowed size (600)");
    } else {
        test:assertFail("Expected an error");
    }
}

@test:Config {enable: true}
function testLargeHeaderSizeWithLargeHeaderService() returns grpc:Error? {
    HelloWorld101Client largeHeaderClient = check new ("http://localhost:9198");
    string largeHeader = "";
    foreach int i in 0...1000 {
        largeHeader = largeHeader + "1234567890";
    }
    wrappers:ContextString requestMessage = {content: "WSO2", headers: {"large-header": largeHeader}};
    wrappers:ContextString response = check largeHeaderClient->helloContext(requestMessage);
    test:assertEquals(response.content, "Hello client");
    test:assertFalse(response.headers.hasKey("large-header"));
}
