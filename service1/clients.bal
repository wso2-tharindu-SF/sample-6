import service1.service2;

// Service2's injected address may already end in "/" — normalize once here so
// every call joins a clean "/catalog" path instead of risking a double slash.
function normalizedBaseUrl(string url) returns string {
    if url.endsWith("/") {
        return url.substring(0, url.length() - 1);
    }
    return url;
}

final service2:Client service2Client = check new (normalizedBaseUrl(serviceTwoUrl));
