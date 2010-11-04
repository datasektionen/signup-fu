Feature: Ye.

Scenario: Viewing all events
  Given an event "Plums"
  
  When I log in as an admin
  And I go to the events page
  
  Then I should see "Plums"
  And I should see "Ägare"
  And I should see "dkm"