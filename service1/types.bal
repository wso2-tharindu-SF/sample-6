// Structured error body for a fallback 404 — mirrors service2's Error shape
// (code, message, optional description/moreInfo) for consistency, even though
// this is not a response service1's own openapi.yaml documents.
public type ErrorPayload record {|
    int code;
    string message;
    string description?;
    string moreInfo?;
|};
