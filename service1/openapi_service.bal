// This file started from the Ballerina OpenAPI tool's generated stub for
// service1's own openapi.yaml; its resource bodies are hand-implemented.

import ballerina/http;
import ballerina/log;
import service1.service2;

listener http:Listener ep0 = new (9090);

service / on ep0 {
    # Average score across service2's current catalog, paged through in full.
    #
    # + return - The computed average, or an error fetching service2's catalog
    resource function get average\-score() returns inline_response_200|http:InternalServerError {
        service2:Client|error service2Client = getService2Client();
        if service2Client is error {
            log:printError("service2 dependency URL is not usable", 'error = service2Client);
            ErrorPayload errorBody = {code: 502, message: "service2 dependency unavailable"};
            return <http:InternalServerError>{body: errorBody};
        }

        int totalScore = 0;
        int recordCount = 0;
        int currentOffset = 0;
        int pageSize = 100;
        boolean hasMore = true;

        while hasMore {
            service2:inline_response_200|error catalogPage = service2Client->/catalog.get({}, {offset: currentOffset, 'limit: pageSize});
            if catalogPage is error {
                log:printError("failed to fetch service2 catalog", 'error = catalogPage);
                ErrorPayload errorBody = {code: 502, message: "failed to fetch service2 catalog"};
                return <http:InternalServerError>{body: errorBody};
            }

            service2:Record[] pageData = catalogPage.data;
            foreach service2:Record item in pageData {
                totalScore = totalScore + item.score;
            }
            recordCount = recordCount + pageData.length();

            string? next = catalogPage?.next;
            if next is () {
                hasMore = false;
            } else {
                currentOffset = currentOffset + pageSize;
            }
        }

        log:printInfo("computed average score", recordCount = recordCount);
        int average = recordCount == 0 ? 0 : totalScore / recordCount;
        return {average: average};
    }

    # Fallback for any path this component does not serve.
    #
    # + return - A structured 404 body
    resource function 'default [string... path]() returns http:NotFound {
        ErrorPayload errorBody = {code: 404, message: "resource not found"};
        return <http:NotFound>{body: errorBody};
    }
}

public type inline_response_200 record {
    # Sum of every record's score divided by the record count, truncated to a whole number
    int average;
};
