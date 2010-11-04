Feature: Managing an event as event owner

As a event owner 
I should be able to manage my events by overriding stuff

Background: 
  Given I am logged in as dkm

Scenario: Adding a guest manually with mail sending
  Given an event "Plums"
  And "Plums" has mail template "signup_confirmation" with fields:
    | Name    | Value         |
    | body    | Yay! Party!   |
    | subject | Confirmation! |
  
  When I go to the event page for "Plums"
  
  And I follow "Ny gäst"
  And I check "Skicka bekräftelse på bokning"
  And I fill in "Namn" with "Kalle Persson"
  And I fill in "E-postadress" with "kalle@example.org"
  And I press "Boka"
  
  Then I should see "Du har nu bokat en biljett till Plums"
  
  When I go to the event page for "Plums"
  
  Then I should see "Kalle Persson"
  
  And "kalle@example.org" should receive 1 email
  And "kalle@example.org" should have 1 mail with subject "Confirmation!"

Scenario: Adding a guest as admin without mail sending
  Given an event "Plums"
  And "Plums" has mail template "signup_confirmation" with fields:
    | Name    | Value         |
    | body    | Yay! Party!   |
    | subject | Confirmation! |
  
  When I go to the event page for "Plums"
  
  And I follow "Ny gäst"
  And I uncheck "Skicka bekräftelse på bokning"
  And I fill in "Namn" with "Kalle Persson"
  And I fill in "E-postadress" with "kalle@example.org"
  And I press "Boka"
  Then I should see "Du har nu bokat en biljett till Plums"
  
  When I go to the event page for "Plums"
  
  Then I should see "Kalle Persson"
  And "kalle@example.org" should receive 0 email
  

Scenario: Adding a guest to a full event
  Given an event "Plums" with maximum 1 guest
  And a guest to "Plums" called "Karl Persson"
    ||
  And I am on the event page for "Plums"

  When I follow "Ny gäst"

  Then I should see "Obs: Detta arrangemang är fullt! Eftersom du är inloggad kan du trots detta lägga till en gäst, men går då förbi maxgränsen."

  And I fill in "Namn" with "Nisse Karlsson"
  And I fill in "E-postadress" with "kalle@example.org"
  And I press "Boka"

  Then I should see "Du har nu bokat en biljett till Plums"

  When I go to the event page for "Plums"
  Then I should see "Nisse Karlsson"

Scenario: Adding a guest to an event passed deadline
  Given an event "Plums" with deadline 10 days ago
  And a guest to "Plums" called "Karl Persson"
    ||

  When I go to the event page for "Plums"

  When I follow "Ny gäst"

  Then I should see "Obs: Deadline för Plums har passerat. Eftersom du är inloggad kan du trots detta lägga till gäster"

  And I fill in "Namn" with "Nisse Karlsson"
  And I fill in "E-postadress" with "kalle@example.org"
  And I press "Boka"

  Then I should see "Du har nu bokat en biljett till Plums"

  When I go to the event page for "Plums"
  Then I should see "Nisse Karlsson"

