Feature: Average score

  @story-1
  Rule: Service1 reports the average score of Service2's current catalog

    Scenario: The full catalog's average
      Given Service2 is serving its full catalog of ten records
      When a client requests the average score from Service1
      Then Service1 reports an average score of 35

  @story-2
  Rule: A request to a path Service1 does not serve returns a structured 404 body

    @negative
    Scenario: An unknown path is refused
      Given Service1 is running
      When a client requests a path Service1 does not serve
      Then Service1 responds with a 404 status and a structured error body containing a code and a message
