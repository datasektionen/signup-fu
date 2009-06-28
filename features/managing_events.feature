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
  
  And I fill in "Ticket type 1 price" with "199"
  And I fill in "Ticket type 1 name" with "With alcohol"
  
  And I fill in "Ticket type 2 price" with "179"
  And I fill in "Ticket type 2 name" with "Without alcohol"
  
  And I press "Create event"
  
  Then I should be on the event page for "My event"
    
  And I should see "With alcohol"
  And I should see "199 kr"
  And I should see "Without alcohol"
  And I should see "179 kr"
  And I should not see "0 kr"

Scenario: Creating a new event with confirmation mail
  
  Given I am on the events page
  
  When I follow "New event"
  And I fill in "Name" with "My event"
  And I select "2009-09-09 09:09" as the "Date" date and time
  And I select "2009-08-08 08:08" as the "Deadline" date and time
  And I fill in "Max guests" with "0"
  
  And I check "Payment confirmation"
  And I fill in "Subject" with "Welcome" in "payment_confirmation_settings"
  And I fill in "Body" with "Welcome to {{EVENT_NAME}}" in "payment_confirmation_settings"
  
  And I fill in "Ticket type 1 price" with "199"
  And I fill in "Ticket type 1 name" with "With alcohol"
  
  And I fill in "Ticket type 2 price" with "179"
  And I fill in "Ticket type 2 name" with "Without alcohol"
  
  And I press "Create event"
  
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
  And a ticket type "With alcohol" for 100 on "My event"
  
  And a guest to "My event" called "Karl Persson"
    | Name | Value           |
    | food | Tomatallergiker |
  
  When I go to the event page for "My event"
  
  Then I should see "Karl Persson"
  And I should see "Tomatallergiker"
  And I should see "Unpaid"
  
  When now is "2009-10-10"
  When I mark "Karl Persson" as paid
  And I go to the event page for "My event"
  
  Then I should see "Paid (2009-10-10)"

Scenario: Creating an event with a pay before date
  Given I am on the events page
  And I follow "New event"
  And I fill in "Name" with "My event"
  And I select "2009-09-09 09:09" as the "Date" date and time
  And I select "2009-08-08 08:08" as the "Deadline" date and time
  And I fill in "Payment time" with "14"
  And I fill in "Max guests" with "0"
  And I press "Create event"
  
  When I go to the events page
  And I follow "My event"
  
  And I should see "2009-09-09 09:09"
  And I should see "14 days"
  

Scenario: An expiring unpaid reply
  Given an event "My event"
  And that "My event" has a payment time of 14 days
  And a ticket type "With alcohol" for 100 on "My event"
  And "My event" has mail template "ticket_expired" with fields:
    | Name    | Value                                                        |
    | body    | You, {{REPLY_NAME}}, are bad person. Your ticket is now void |
    | subject | You haven't paid for {{EVENT_NAME}}                          |
  And a guest to "My event" called "Kalle"
    | Name  | Value            |
    | email | kalle@example.org |
    
  And now is 3 weeks from now
  
  
  When the ticket expire process is run
  
  Then "kalle@example.org" should receive 1 emails
  
  When "kalle@example.org" opens the email with subject "You haven't paid for My event"
  
  Then I should see "You, Kalle, are bad person. Your ticket is now void" in the email
  
  When I go to the event page for "My event"
  
  Then I should see "Expired (No payment)"


