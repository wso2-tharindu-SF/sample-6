import service1.service2;

// Service2's injected address may already end in "/" — normalize once here so
// every call joins a clean "/catalog" path instead of risking a double slash.
isolated function normalizedBaseUrl(string url) returns string {
    if url.endsWith("/") {
        return url.substring(0, url.length() - 1);
    }
    return url;
}

// Built lazily, on first use, rather than at module init: a dependency URL
// that is transiently empty or malformed at pod startup must fail the single
// request that needs it, not crash the whole listener into a restart loop.
isolated service2:Client? lazyService2Client = ();

isolated function getService2Client() returns service2:Client|error {
    lock {
        service2:Client? existing = lazyService2Client;
        if existing is service2:Client {
            return existing;
        }
        if serviceTwoUrl.trim().length() == 0 {
            return error("SERVICE2_URL is not configured");
        }
        service2:Client newClient = check new (normalizedBaseUrl(serviceTwoUrl));
        lazyService2Client = newClient;
        return newClient;
    }
}
