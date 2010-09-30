Feature: Custom fields

Scenario: Creating an event with custom fields
  Given I am logged in as an admin
  And I am on the homepage
  And I go to the new event page
  And I fill in "Name" with "My event"
  And I choose "Default"
  And I fill in "Date" with "2011-09-09 09:09"
  And I fill in "Deadline" with "2011-08-08 08:08"
  And I fill in "Max guests" with "0"
  And I fill in "Signup message" with "Foobar!"
  
  And I fill in "Biljettnamn 1" with "With alcohol"
  And I fill in "Biljettpris 1" with "100"
  
  And I fill in "Anpassat fält 1" with "Årskurs"
  
  And I press "Create event"
  
  When I go to the new reply page for "My event"
  
  Then I should see "Årskurs"
  
Scenario: Signing up to event with custom fields and viewing it
  Given an event "My event"
  And the event "My event" has custom field "Årskurs"
  
  When I go to the new reply page for "My event"
  
  And I fill in "Namn" with "Kalle"
  And I fill in "E-postadress" with "kalle@example.org"
  And I fill in "Kommentar" with "My gosh, party!"
  And I fill in "Andra matpreferenser" with "I like cucumbers"
  And I fill in "Årskurs" with "2004"
  And I press "Boka"
  
  When I go to the event page for "My event"
  Then I should not see "Årskurs"
  Then I should not see "2004"
  
  When I go to the guest list page for "My event"
  
  Then I should see "Årskurs"
  Then I should see "2004"
  
  When I sign out
  When I go to the guest list page for "My event"
  Then I should see "Årskurs"
  And I should see "2004"
  
  
  





