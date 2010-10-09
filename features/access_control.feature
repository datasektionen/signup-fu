Feature: Access control

Scenario Outline: Access granted for admin
  Given I am logged in as an admin
  And an event "My event"  
  When I go to <page>
  
  Then I should not see "Access denied"
  
  Examples:
    | page                              |
    | the homepage                      |
    | the events page                   |
    | the event page for "My event"    |
    | the new reply page for "My event" |
    | the economy page for "My event"   |
    | the permit report page for "My event" |
    

Scenario Outline: Access denied for not logged in
  Given an event "My event"  
  When I go to <page>
  
  Then I should be on the login page

  Examples:
    | page                              |
    | the events page                   |
    | the event page for "My event"   |
    | the economy page for "My event" |
    | the permit report page for "My event" |

Scenario Outline: Access granted for not logged in
  Given an event "My event"
  When I go to <page>
  
  Then I should not see "Access denied"
  And I should not be on the login page

  Examples: 
    |page|
    | the new reply page for "My event" |

Scenario: Restricting access
  Given I am logged in as dkm
  And an event "Plums"
  And an event "D-dagsgasque"
  
  When I go to the events page
  
  Then I should see "Plums"
  And I should not see "D-dagsgasque"
  
  When I go to the event page for "D-dagsgasque"
  Then I should see "Du har inte rätt att se denna sida"


Scenario: Viewing all events as an admin user
  Given I am logged in as an admin
  And an event "Plums"
  And an event "D-dagsgasque"

  When I go to the events page

  Then I should see "Plums"
  And I should see "D-dagsgasque"
