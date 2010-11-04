Feature: Creating more complex events with payment handling

Background:
  Given I am logged in as dkm

Scenario: Creating a new event with payment mail
  
  Given I am on the homepage
  
  When I go to the new event page
  And I fill in "Arrangemangets namn" with "My event"
  And I select "Default" from "Mall"
  And I fill in "Slug" with "my-event"
  
  And I fill in "Datum" with "2009-09-09 09:09"
  And I fill in "Sista anmälningsdatum" with "2009-08-08 08:08"
  And I fill in "Max antal gäster" with "0"
  
  And I fill in "Biljettnamn 1" with "With alcohol"
  And I fill in "Biljettpris 1" with "100"
  
  And I check "Betalningsbekräftelse"
  And I fill in "Ämnesrad" with "Payment" in "payment_registered_settings"
  And I fill in "Brödtext" with "Your ticket to {{EVENT_NAME}} is now paid" in "payment_registered_settings"
  
  And I fill in "Studsadress" with "foo@example.org"
  
  And I fill in the following ticket types:
    | With alcohol    | 199 |
    | Without alcohol | 179 |
  
  And I press "Create Event"
  
  Then I should be on the event page for "My event"
  
  Then I should see "Payment registered" mail as active


Scenario: Reminder runs. Wtf NBS flashbacks
  And an event "Plums"
  And that "Plums" has a payment time of 14 days
  And "Plums" has mail template "ticket_expired" with fields:
    | Name    | Value                                                        |
    | body    | You, {{REPLY_NAME}}, are bad person. Your ticket is now void |
    | subject | You haven't paid for {{EVENT_NAME}}                          |
  And "Plums" has mail template "ticket_expire_reminder" with fields:
    | Name    | Value                   |
    | body    | You are hereby reminded |
    | subject | Reminder                |

  And a guest to "Plums" called "Kalle"
    | Name  | Value            |
    | email | kalle@example.org |

  And now is 3 weeks from now
  And the reminder process is run for "Plums"

  Then "kalle@example.org" should receive 1 emails

  When "kalle@example.org" opens the email with subject "Reminder"
  Then I should see "You are hereby reminded" in the email body

Scenario: An expiring unpaid reply
  And an event "Plums"
  And that "Plums" has a payment time of 14 days
  And that "Plums" has a expire time from reminder of 5 days
  And "Plums" has mail template "ticket_expire_reminder" with fields:
    | Name    | Value |
    | body    | foo   |
    | subject | bar   |
  And "Plums" has mail template "ticket_expired" with fields:
    | Name    | Value                                                        |
    | body    | You, {{REPLY_NAME}}, are bad person. Your ticket is now void |
    | subject | You haven't paid for {{EVENT_NAME}}                          |
  And a guest to "Plums" called "Kalle"
    | Name  | Value             |
    | email | kalle@example.org |

  When now is 3 weeks from now
  And the reminder process is run for "Plums"
  And no emails have been sent
  And now is 4 weeks from now
  And the ticket expire process is run for "Plums"

  Then "kalle@example.org" should receive 1 emails

  When "kalle@example.org" opens the email with subject "You haven't paid for Plums"

  Then I should see "You, Kalle, are bad person. Your ticket is now void" in the email body
