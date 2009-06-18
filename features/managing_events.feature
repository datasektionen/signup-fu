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

Scenario: Creating a new event with prices
  Given I am on the events page
  
  When I follow "New event"
  And I fill in "Name" with "My event"
  And I select "2009-09-09 09:09" as the "Date" date and time
  And I select "2009-08-08 08:08" as the "Deadline" date and time
  And I fill in "Max guests" with "0"
  
  And I fill in "Price 1" with "199"
  And I fill in "Price 1 Name" with "With alcohol"
  
  And I fill in "Price 2" with "179"
  And I fill in "Price 2 Name" with "Without alcohol"
  
  And I press "Create event"
  
  Then I should be on the event page for "My event"
    
  And I should see "Price (With alcohol)"
  And I should see "199 kr"
  And I should see "Price (Without alcohol)"
  And I should see "179 kr"
  And I should not see "0 kr"
  
Scenario: Adding confirmation mail
  Given an event "My event"
  And I am on the event page for "My event"
  And I follow "Add mail"
  
  And I select "Signup Confirmation" from "Template for"
  And I fill in "Subject" with "Welcome"
  And I fill in "Body" with "Welcome to {{EVENT_NAME}}"
  
  And I press "Create mail"
  
  Then I should be on the event page for "My event"
  
  And I should see "Signup confirmation"
  And I should see "Welcome"
  And I should see "Welcome to {{EVENT_NAME}}"
 
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
  And a guest to "My event" called "Karl Persson"
    | Name | Value           |
    | food | Tomatallergiker |
  
  When I go to the event page for "My event"
  
  Then I should see "Karl Persson"
  And I should see "Tomatallergiker"


