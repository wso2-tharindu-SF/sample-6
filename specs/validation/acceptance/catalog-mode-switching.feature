Feature: Catalog mode switching

  @story-3
  Rule: Service2 starts in full mode

    Scenario: Freshly started, Service2 serves the full catalog
      Given Service2 has just started
      Then Service2's catalog mode is full

  @story-3
  Rule: Only the Operator switches Service2 between full and empty mode, through its internal operations endpoint

    Scenario: The Operator switches to empty mode
      Given Service2 is in full mode
      When the Operator switches Service2 to empty mode through its operations endpoint
      Then Service2's catalog mode is empty

    Scenario: The Operator switches back to full mode
      Given Service2 is in empty mode
      When the Operator switches Service2 to full mode through its operations endpoint
      Then Service2's catalog mode is full
