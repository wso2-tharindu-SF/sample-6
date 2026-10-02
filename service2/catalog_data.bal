// Fixed seed catalog and the in-memory mode flag it is served under.
// Service2 computes no aggregate itself -- it only serves these records.

"full"|"empty" catalogMode = "full";

final Record[] seedCatalog = [
    {id: 1, name: "Record-01", score: 42},
    {id: 2, name: "Record-02", score: 38},
    {id: 3, name: "Record-03", score: 35},
    {id: 4, name: "Record-04", score: 30},
    {id: 5, name: "Record-05", score: 25},
    {id: 6, name: "Record-06", score: 40},
    {id: 7, name: "Record-07", score: 33},
    {id: 8, name: "Record-08", score: 28},
    {id: 9, name: "Record-09", score: 45},
    {id: 10, name: "Record-10", score: 42}
];

function currentCatalog() returns Record[] {
    if catalogMode == "full" {
        return seedCatalog;
    }
    return [];
}
