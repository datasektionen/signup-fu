Feature: Managing events
As a event arranger
I want to be able to create, edit and view my events
So that I can have something that my guests can sign up to, so I get guests to my events

Background:
  #Given I am logged in as an admin
  
Scenario: Showing a getting started box
  When I create the event "My event"
  Then I should be on the event page for "My event"
  And I should see the tag "div#getting_started"
  
  When I follow "Dismiss"
  
  Then I should be on the event page for "My event"
  And I should not see the tag "div#getting_started"
  

Scenario: Creating a new event without max number of guests
  Given I am on the homepage
  And I go to the new event page
  And I fill in "Name" with "My event"
  And I fill in "Password" with "WordPass"
  And I fill in "Password confirmation" with "WordPass"
  And I choose "Default"
  And I fill in "Date" with "2009-09-09 09:09"
  And I fill in "Deadline" with "2009-08-08 08:08"
  And I fill in "Max guests" with "0"
  And I fill in "Signup message" with "Foobar!"
  
  And I fill in "Biljettnamn 1" with "With alcohol"
  And I fill in "Biljettpris 1" with "100"
  And I press "Create event"
  
  Then I should be on the event page for "My event"
  And I should see "My event"
  And I should see "2009-09-09 09:09"

Scenario: Creating a new event with prices
  Given I am on the homepage
  
  When I go to the new event page
  And I fill in "Name" with "My event"
  And I fill in "Password" with "WordPass"
  And I fill in "Password confirmation" with "WordPass"
  
  And I choose "Default"
  And I fill in "Date" with "2009-09-09 09:09"
  And I fill in "Deadline" with "2009-08-08 08:08"
  And I fill in "Max guests" with "0"
  
  And I fill in "Biljettpris 1" with "199"
  And I fill in "Biljettnamn 1" with "With alcohol"
  
  And I fill in "Biljettpris 2" with "179"
  And I fill in "Biljettnamn 2" with "Without alcohol"
  
  And I press "Create event"
  
  Then I should be on the event page for "My event"
    
  And I should see "With alcohol"
  And I should see "199 kr"
  And I should see "Without alcohol"
  And I should see "179 kr"
  And I should not see "0 kr"


Scenario: Creating a new event without mails
  Given I am on the homepage
  
  When I go to the new event page
  And I fill in "Name" with "My event"
  And I fill in "Password" with "WordPass"
  And I fill in "Password confirmation" with "WordPass"
  
  And I choose "Default"
    And I fill in "Date" with "2009-09-09 09:09"
  And I fill in "Deadline" with "2009-08-08 08:08"
  And I fill in "Max guests" with "0"
  And I fill in the following ticket types:
    | With alcohol    | 199 |
    | Without alcohol | 179 |
  
  And I press "Create event"
  
  Then I should be on the event page for "My event"
  
  And I should not see "Signup confirmation"
  And I should not see "Ticket expiry"
  And I should not see "Payment registered mail"


Scenario: Creating a new event with confirmation mail
  Given I am on the homepage
  
  When I go to the new event page
  And I fill in "Name" with "My event"
  And I fill in "Password" with "WordPass"
  And I fill in "Password confirmation" with "WordPass"
  
  And I choose "Default"
  And I fill in "Date" with "2009-09-09 09:09"
  And I fill in "Deadline" with "2009-08-08 08:08"
  And I fill in "Max guests" with "0"
  And I fill in "Biljettnamn 1" with "With alcohol"
  And I fill in "Biljettpris 1" with "100"
  
  And I check "Bekräftelse på bokning"
  And I fill in "Ämnesrad" with "Welcome" in "signup_confirmation_settings"
  And I fill in "Brödtext" with "Welcome to {{EVENT_NAME}}" in "signup_confirmation_settings"
  
  And I fill in "Bounce address" with "foo@example.org"
  
  And I fill in the following ticket types:
    | With alcohol    | 199 |
    | Without alcohol | 179 |
  
  And I press "Create event"
  
  Then I should be on the event page for "My event"
  
  And I should see "Signup confirmation"
  And I should see "Welcome"
  And I should see "Welcome to {{EVENT_NAME}}"
  
  And I should not see "Ticket expiry"
  And I should not see "Payment registered mail"

Scenario: Creating a new event with confirmation mail - default message
  Given I am on the homepage
  
  When I go to the new event page
  And I fill in "Name" with "My event"
  And I fill in "Password" with "WordPass"
  And I fill in "Password confirmation" with "WordPass"
  
  And I choose "Default"
  And I fill in "Date" with "2009-09-09 09:09"
  And I fill in "Deadline" with "2009-08-08 08:08"
  And I fill in "Max guests" with "0"
  
  And I fill in "Biljettnamn 1" with "With alcohol"
  And I fill in "Biljettpris 1" with "100"
  
  And I check "Bekräftelse på bokning"
  
  # The texts are in config/settings.yml
  Then "Ämnesrad" in "signup_confirmation_settings" should have text "Thank you for signing up to {{EVENT_NAME}}"
  And "Brödtext" in "signup_confirmation_settings" should have text "Welcome to {{EVENT_NAME}}!"
  
  And "Ämnesrad" in "payment_registered_settings" should have text "Payment registered for {{EVENT_NAME}}"
  And "Brödtext" in "payment_registered_settings" should have text "Your payment for {{EVENT_NAME}} is now registered!"
  
  
  And "Ämnesrad" in "ticket_expired_settings" should have text "Your ticket to {{EVENT_NAME}} has expired"
  And "Brödtext" in "ticket_expired_settings" should have text "No more ticket to {{EVENT_NAME}} for you!"
  

Scenario: Creating a new event with payment mail
  
  Given I am on the homepage
  
  When I go to the new event page
  And I fill in "Name" with "My event"
  And I choose "Default"
  And I fill in "Password" with "WordPass"
  And I fill in "Password confirmation" with "WordPass"
  
  And I fill in "Date" with "2009-09-09 09:09"
  And I fill in "Deadline" with "2009-08-08 08:08"
  And I fill in "Max guests" with "0"
  
  And I fill in "Biljettnamn 1" with "With alcohol"
  And I fill in "Biljettpris 1" with "100"
  
  And I check "Betalningsbekräftelse"
  And I fill in "Ämnesrad" with "Payment" in "payment_registered_settings"
  And I fill in "Brödtext" with "Your ticket to {{EVENT_NAME}} is now paid" in "payment_registered_settings"
  
  And I fill in "Bounce address" with "foo@example.org"
  
  And I fill in the following ticket types:
    | With alcohol    | 199 |
    | Without alcohol | 179 |
  
  And I press "Create event"
  
  Then I should be on the event page for "My event"
  
  And I should see "Payment registered"
  And I should see "Payment"
  And I should see "Your ticket to {{EVENT_NAME}} is now paid"

Scenario: Creating a new event with ticket expiry
  Given I am on the homepage
  
  When I go to the new event page
  And I fill in "Name" with "My event"
  And I fill in "Password" with "WordPass"
  And I fill in "Password confirmation" with "WordPass"
  
  And I choose "Default"
  And I fill in "Date" with "2009-09-09 09:09"
  And I fill in "Deadline" with "2009-08-08 08:08"
  And I fill in "Max guests" with "0"
  
  And I check "ticket_expired"
  And I fill in "Payment time" with "10"
  And I fill in "Ämnesrad" with "No payment received" in "ticket_expired_settings"
  And I fill in "Brödtext" with "Your ticket to {{EVENT_NAME}} is now expired" in "ticket_expired_settings"
  
  # För javascriptad checkbox
  And I fill in "event_mail_templates_ticket_expire_reminder_enabled" with "1"
  And I fill in "Reminder time" with "3"
  And I fill in "Ämnesrad" with "Reminder" in "ticket_expire_reminder_settings"
  And I fill in "Brödtext" with "Your are hereby reminded" in "ticket_expire_reminder_settings"
  
  And I fill in "Bounce address" with "foo@example.org"
  
  And I fill in the following ticket types:
    | With alcohol    | 199 |
    | Without alcohol | 179 |
  
  And I press "Create event"
  
  Then I should be on the event page for "My event"
  
  And I should see "Ticket expiry"
  And I should see "10 days"
  And I should see "3 days"
  And I should see "No payment received"
  And I should see "Your ticket to {{EVENT_NAME}} is now expired"
  And I should see "Reminder"
  And I should see "Your are hereby reminded"
  

# TODO fixa delete-länk
#Scenario: Event deletion
#  Given an event "My event"
#  
#  When I go to the event page for "My event"
#  And I follow "Delete"
#  
#  Then the event "My event" should not exist in the database

# TODO fixa edit-länk
#Scenario: Editing an event
#  Given an event "My event"
#  
#  When I go to the event page for "My event"
#  And I follow "Edit"
#  
#  Then I should not see "Ticket 1 name"
#  And I should not see "Signup Confirmation"
#  
#  And I select "2010-10-10 10:10" as the "Date" date and time
#  And I press "Save"
#  
#  Then I should be on the event page for "My event"
#  And I should not see "2009-09-09"
#  And I should see "2010-10-10"
#  
  

Scenario: Viewing an event
  Given an event "My event"
  
  When I go to the event page for "My event"
  And I fill in "Password" with "WordPass"
  And I press "Logga in"
  
  Then I should see "My event"
  And I should see "2010-09-09"
  And I should see "2010-08-08"

Scenario: Creating an event with a pay before date
  Given I am on the homepage
  And I go to the new event page
  And I fill in "Name" with "My event"
  And I fill in "Password" with "WordPass"
  And I fill in "Password confirmation" with "WordPass"
  
  And I choose "Default"
  And I fill in "Date" with "2009-09-09 09:09"
  And I fill in "Deadline" with "2009-08-08 08:08"
  And I fill in "Payment time" with "14"
  And I fill in "Max guests" with "0"
  And I fill in the following ticket types:
    | With alcohol    | 199 |
  
  And I press "Create event"
  
  Then I should be on the event page for "My event"
  And I should see "2009-09-09 09:09"
  And I should see "14 days"
  


Scenario: Reminder runs. Wtf NBS flashbacks
  Given an event "My event"
  And that "My event" has a payment time of 14 days
  And "My event" has mail template "ticket_expired" with fields:
    | Name    | Value                                                        |
    | body    | You, {{REPLY_NAME}}, are bad person. Your ticket is now void |
    | subject | You haven't paid for {{EVENT_NAME}}                          |
  And "My event" has mail template "ticket_expire_reminder" with fields:
    | Name    | Value                   |
    | body    | You are hereby reminded |
    | subject | Reminder                |
  
  And a guest to "My event" called "Kalle"
    | Name  | Value            |
    | email | kalle@example.org |
  
  And now is 3 weeks from now
  And the reminder process is run for "My event"
  
  Then "kalle@example.org" should receive 1 emails
  
  When "kalle@example.org" opens the email with subject "Reminder"
  Then I should see "You are hereby reminded" in the email

Scenario: An expiring unpaid reply
  Given an event "My event"
  And that "My event" has a payment time of 14 days
  And that "My event" has a expire time from reminder of 5 days
  And "My event" has mail template "ticket_expire_reminder" with fields:
    | Name    | Value |
    | body    | foo   |
    | subject | bar   |
  And "My event" has mail template "ticket_expired" with fields:
    | Name    | Value                                                        |
    | body    | You, {{REPLY_NAME}}, are bad person. Your ticket is now void |
    | subject | You haven't paid for {{EVENT_NAME}}                          |
  And a guest to "My event" called "Kalle"
    | Name  | Value             |
    | email | kalle@example.org |
  
  When now is 3 weeks from now
  And the reminder process is run for "My event"
  And no emails have been sent
  And now is 4 weeks from now
  And the ticket expire process is run for "My event"
  
  Then "kalle@example.org" should receive 1 emails
  
  When "kalle@example.org" opens the email with subject "You haven't paid for My event"
  
  Then I should see "You, Kalle, are bad person. Your ticket is now void" in the email

Scenario: Food weirdness summary
  Given an event "My event"
  And food preference "Vegan"
  And food preference "Vegetarian"
  And a guest to "My event" called "Kalle"
    | Name  | Value             |
    | Food Preferences | Vegan  |
  
  And a guest to "My event" called "Pelle"
    | Name             | Value      |
    | Food Preferences | Vegetarian |
  
  And a guest to "My event" called "Stina"
    | Name             | Value      |
    | Food Preferences | Vegetarian |
  
  When I go to the event page for "My event"
  And I fill in "Password" with "WordPass"
  And I press "Logga in"
  
  Then I should see "Antal..."
  And the food preferences summary should show 2 Vegetarian
  And the food preferences summary should show 1 Vegan


Scenario: Adding a guest when logged in as an admin
  Given an event "My event"
  When I go to the event page for "My event"
  And I fill in "Password" with "WordPass"
  And I press "Logga in"
  
  When I follow "Ny gäst"
    
  Then I should see "Administrativa funktioner"
  And I should not see "Skicka bekräftelse på bokning"
  
  And "My event" has mail template "signup_confirmation" with fields:
    | Name    | Value         |
    | body    | Yay! Party!   |
    | subject | Confirmation! |
  When I go to the event page for "My event"
  And I follow "Ny gäst"
  
  Then I should see a checkbox "Skicka bekräftelse på bokning"


Scenario: Adding a guest manually with mail sending
  Given an event "My event"
  And "My event" has mail template "signup_confirmation" with fields:
    | Name    | Value         |
    | body    | Yay! Party!   |
    | subject | Confirmation! |
  
  When I go to the event page for "My event"
  And I fill in "Password" with "WordPass"
  And I press "Logga in"
  
  And I follow "Ny gäst"
  And I check "Skicka bekräftelse på bokning"
  And I fill in "Namn" with "Kalle Persson"
  And I fill in "E-postadress" with "kalle@example.org"
  And I press "Boka"
  
  Then I should see "Du har nu bokat en biljett till My event"
  
  When I go to the event page for "My event"
  
  Then I should see "Kalle Persson"
  And "kalle@example.org" should receive 1 email
  And "kalle@example.org" should have 1 mail with subject "Confirmation!"

Scenario: Adding a guest as admin without mail sending
  Given an event "My event"
  And "My event" has mail template "signup_confirmation" with fields:
    | Name    | Value         |
    | body    | Yay! Party!   |
    | subject | Confirmation! |
  
  When I go to the event page for "My event"
  And I fill in "Password" with "WordPass"
  And I press "Logga in"
  
  And I follow "Ny gäst"
  And I uncheck "Skicka bekräftelse på bokning"
  And I fill in "Namn" with "Kalle Persson"
  And I fill in "E-postadress" with "kalle@example.org"
  And I press "Boka"
  Then I should see "Du har nu bokat en biljett till My event"
  
  When I go to the event page for "My event"
  
  Then I should see "Kalle Persson"
  And "kalle@example.org" should receive 0 email


Scenario: Adding a guest to a full event
  Given an event "My event" with fields:
    | Name       | Value |
    | max_guests | 1     |
  And a guest to "My event" called "Karl Persson"
    ||
  And I am on the event page for "My event"
  And I fill in "Password" with "WordPass"
  And I press "Logga in"
  
  When I follow "Ny gäst"
  
  Then I should see "Obs: Detta arrangemang är fullt! Eftersom du är inloggad kan du trots detta lägga till en gäst, men går då förbi maxgränsen."
  
  And I fill in "Namn" with "Nisse Karlsson"
  And I fill in "E-postadress" with "kalle@example.org"
  And I press "Boka"
  
  Then I should see "Du har nu bokat en biljett till My event"
  
  When I go to the event page for "My event"
  Then I should see "Nisse Karlsson"

Scenario: Adding a guest to an event passed deadline
  Given an event "My event" with fields:
    | Name       | Value |
    | max_guests | 1     |
    |deadline| 10 days ago|
  And a guest to "My event" called "Karl Persson"
    ||
    
  When I go to the event page for "My event"
  And I fill in "Password" with "WordPass"
  And I press "Logga in"
  
  When I follow "Ny gäst"
  
  Then I should see "Obs: Deadline för My event har passerat. Eftersom du är inloggad kan du trots detta lägga till gäster"
  
  And I fill in "Namn" with "Nisse Karlsson"
  And I fill in "E-postadress" with "kalle@example.org"
  And I press "Boka"
  
  Then I should see "Du har nu bokat en biljett till My event"
  
  When I go to the event page for "My event"
  Then I should see "Nisse Karlsson"


# Börja med att markera som attending -> betald
Scenario: Marking a guest as attending
  Given an event "My event"
  And a guest to "My event" called "Karl Persson"
    ||
  
  When I go to the guest list page for "My event"
  And I fill in "Password" with "WordPass"
  And I press "Logga in"
  
  And I fill in "Name" with "Karl Persson"
  And I press "Pricka av"
  
  # TODO how check this now that I've removed it from the guest
  # list page? (d146f1df6243db70144dac12b4c6d2d6ce9acc10)
  #Then I should be on the guest list page for "My event"
  #And I should see "Attending"

