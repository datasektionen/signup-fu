Feature: Creating simple events (ones without payment and expiry)


Background:
  Given I am logged in as dkm

Scenario: Creating a new event without max number of guests
  And I am on the homepage
  And I go to the new event page
  And I fill in "Arrangemangets namn" with "My event"
  And I select "Default" from "Mall"
  And I fill in "Slug" with "my-event"
  And I fill in "Datum" with "2009-09-09 09:09"
  And I fill in "Sista anmälningsdatum" with "2009-08-08 08:08"
  And I fill in "Max antal gäster" with "0"
  And I fill in "Meddelande" with "Foobar!"
  
  And I fill in "Biljettnamn 1" with "With alcohol"
  And I fill in "Biljettpris 1" with "100"
  And I press "Create Event"
  
  Then I should be on the event page for "My event"
  And I should see "My event"
  And I should see a "no guests" message

Scenario: Creating a new event with prices
  And I am on the homepage
  
  When I go to the new event page
  And I fill in "Arrangemangets namn" with "My event"
  
  And I select "Default" from "Mall"
  And I fill in "Slug" with "my-event"
  And I fill in "Datum" with "2009-09-09 09:09"
  And I fill in "Sista anmälningsdatum" with "2009-08-08 08:08"
  And I fill in "Max antal gäster" with "0"
  
  And I fill in "Biljettpris 1" with "199"
  And I fill in "Biljettnamn 1" with "With alcohol"
  
  And I fill in "Biljettpris 2" with "179"
  And I fill in "Biljettnamn 2" with "Without alcohol"
  
  And I press "Create Event"
  
  Then I should be on the event page for "My event"
    
  And I should see "With alcohol"
  And I should see "199 kr"
  And I should see "Without alcohol"
  And I should see "179 kr"
  And I should not see "0 kr"


Scenario: Creating a new event without mails
  Given I am on the homepage
  
  When I go to the new event page
  And I fill in "Arrangemangets namn" with "My event"
  
  And I select "Default" from "Mall"
  And I fill in "Slug" with "my-event"
  And I fill in "Datum" with "2009-09-09 09:09"
  And I fill in "Sista anmälningsdatum" with "2009-08-08 08:08"
  And I fill in "Max antal gäster" with "0"
  And I fill in the following ticket types:
    | With alcohol    | 199 |
    | Without alcohol | 179 |
  
  And I press "Create Event"
  
  Then I should be on the event page for "My event"
  
  And I should not see "Signup confirmation"
  And I should not see "Ticket expiry"
  And I should not see "Payment registered mail"


Scenario: Creating a new event with confirmation mail
  Given I am on the homepage
  
  When I go to the new event page
  And I fill in "Arrangemangets namn" with "My event"
  And I fill in "Slug" with "my-event"
  And I select "Default" from "Mall"
  And I fill in "Datum" with "2009-09-09 09:09"
  And I fill in "Sista anmälningsdatum" with "2009-08-08 08:08"
  And I fill in "Max antal gäster" with "0"
  And I fill in "Biljettnamn 1" with "With alcohol"
  And I fill in "Biljettpris 1" with "100"
  
  And I check "Bekräftelse på bokning"
  And I fill in "Ämnesrad" with "Welcome" in "signup_confirmation_settings"
  And I fill in "Brödtext" with "Welcome to My event" in "signup_confirmation_settings"
  
  And I fill in "Studsadress" with "foo@example.org"
  
  And I fill in the following ticket types:
    | With alcohol    | 199 |
    | Without alcohol | 179 |
  
  And I press "Create Event"
  
  Then I should be on the event page for "My event"
  
  And I should see "Signup confirmation" mail as active
  
  And I should not see "Ticket expiry"
  And I should not see "Payment registered mail"



Scenario: Editing an event
  Given an event "Plums"

  When I go to the event page for "Plums"
  And I follow "Redigera"

  And I fill in "Datum" with "2012-10-10 10:10"
  And I fill in "Sista anmälningsdatum" with "2012-09-10 10:10"
  And I press "Update Event"

  Then I should be on the event page for "Plums"
  And I should not see "2009-09-09"
  And I should see "2012-10-10"



Scenario: Editing an event
  Given an event "Plums"

  When I go to the event page for "Plums"
  And I follow "Redigera"

  And I fill in "Datum" with "2012-10-10 10:10"
  And I fill in "Sista anmälningsdatum" with "2012-09-10 10:10"
  And I press "Update Event"

  Then I should be on the event page for "Plums"
  And I should not see "2009-09-09"
  And I should see "2012-10-10"


Scenario: Food weirdness summary
  Given an event "Plums"
  And food preference "Vegan"
  And food preference "Vegetarian"
  And a guest to "Plums" called "Kalle"
    | Name  | Value             |
    | Food Preferences | Vegan  |

  And a guest to "Plums" called "Pelle"
    | Name             | Value      |
    | Food Preferences | Vegetarian |

  And a guest to "Plums" called "Stina"
    | Name             | Value      |
    | Food Preferences | Vegetarian |

  When I go to the event page for "Plums"

  # FIXME decl_auth
  #Then I should see "Antal..."
  #And the food preferences summary should show 2 Vegetarian
  #And the food preferences summary should show 1 Vegan

Scenario: Viewing guest list to a non-food event
  Given an event "Seminarie" with fields:
    | Name                 | Value       |
    | use_food_preferences | false       |
    | owner                | dkm@d.kth.se|
  And a guest to "Seminarie" called "Karl Persson"
    ||

  When I go to the event page for "Seminarie"

  Then I should not see "Matpreferenser"
  And I should not see "Andra matpreferenser"

  When I go to the guest list page for "Seminarie"

  Then I should not see "Matpreferenser"
  And I should not see "Andra matpreferenser"

Scenario: Editing a reply
  Given an event "Plums"
  And a guest to "Plums" called "Kalle Person"
    ||

  When I go to the event page for "Plums"
  And I follow "Redigera" within "table#guest_list_table"
  And I fill in "Namn" with "Karl Person"
  And I press "Boka"

  Then I should be on the event page for "Plums"
  And I should see "Karl Person"