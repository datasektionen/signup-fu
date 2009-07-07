Feature: Economy reporting
As a event arranger
I want to be able to have an economy reporting system
So that I can keep track of which guests has paid, so that I can send baltic inkasso after the ones that don't, so I can make as much money as possible

Scenario: Marking a reply as paid
  Given now is "2009-01-01"
  And an event "My event"
  And a ticket type "Normal ticket" for 100 on "My event"
  And a guest to "My event" called "Kalle"
    ||
  
  When I am on the event page for "My event"
  And I follow "Economy"
  And I check the paid checkbox for "Kalle"
  And I press "Save"
  
  Then I should see "2009-01-01"

Scenario: Sending a payment reported mail
  Given an event "My event"
  And a ticket type "Normal ticket" for 100 on "My event"
  And a guest to "My event" called "Kalle"
    | Name  | Value             |
    | email | kalle@example.org |
  And "My event" has mail template "payment_registered" with fields:
    | Name    | Value                               |
    | body    | Thank you for paying, {{REPLY_NAME}} |
    | subject | Payment received for {{EVENT_NAME}} |
  
  When I go to the economy page for "My event"
  And I check the paid checkbox for "Kalle"
  And I press "Save"
  
  
  Then "kalle@example.org" should receive 1 emails
  
  When "kalle@example.org" opens the email with subject "Payment received for My event"
  
  Then I should see "Thank you for paying, Kalle" in the email
  
