Feature: Managing events
As a event arranger
I want to be able to create, edit and view my events
So that I can have something that my guests can sign up to, so I get guests to my events

Scenario: Creating a new event without max number of guests
  Given I am on the events page
  And I follow "New event"
  And I fill in "Name" with "My event"
  And I select "2009-09-09 09:09" as the "Date" date and time
  And I select "2009-08-08 08:08" as the "Deadline" date and time
  And I fill in "Max guests" with "0"
  And I press "Create event"
  
  When I go to the events page
  
  Then I should see "My event"
  And I should see "2009-09-09 09:09"
  
Scenario: Event deletion
  Given an event "My event"

  When I go to the events page
  And I follow "Delete event"
  And I go to the events page
  
  Then I should not see "My event"

Scenario: Viewing an event
  Given an event "My event"
  
  When I go to the events page
  And I follow "My event"
  
  Then I should see "My event"
  And I should see "2009-09-09"
  And I should see "2009-08-08"
  
Scenario: Viewing guests for an event
  Given an event "My event"
  
  When I go to the 
  And a guest to "My event" called "Karl Persson" with food preferences "Tomatallergiker"
  
  Then I should see "Karl Persson"
  And I should see "Tomatallergiker"


