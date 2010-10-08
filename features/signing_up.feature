Feature: Signing up
  As a person interested in an event
  I want to be able to get information about and sign up to an event
  So that the event arranger can know who will come to the event and therefore plan properly and not kill anyone or buy too much or too little food.
  
  Scenario: Signing up to event with more than one ticket type
    Given an event "My event"
    And a ticket type "Without alcohol" for 80 on "My event"
    
    When I go to the new reply page for "My event"
    
    Then I should see "With alcohol (100 kr)"
    And I should see "Without alcohol (80 kr)"
    
  
#  Scenario Outline: Signing up on free event
#    Given an event "My event" owned by "dkm@d.kth.se" with fields:
#      | Name           | Value                    |
#      | signup_message | Thank you for signing up |
#    
#    When I go to the new reply page for "My event"
#    
#    Then I should see "Boka biljett till My event"
#    
#    And I fill in "Namn" with "<name>"
#    And I fill in "E-postadress" with "<email>"
#    And I press "Boka"
#    
#    Then the <kind> flash should contain "<flash message>" 
#    And I should see "<message>"
#    
#    Examples:
#      | name         | email | kind   | flash message        | message                  |
#      | Karl Persson | kalle | notice |                      | Thank you for signing up |
#      |              | kalle | error  |                      | Namn måste anges         |
#      | Karl Persson |       | error  |                      | Email måste anges        |
  
#  Scenario: Mail notification when signing up
#    Given an event "My event" owned by "random_user@example.org"
#    
#    And "My event" has mail template "signup_confirmation" with fields:
#      | Name    | Value                                      |
#      | body    | Thank you for signing up to {{EVENT_NAME}}. Your payment reference is {{PAYMENT_REFERENCE}} |
#      | subject | Thank you                                  |
#    
#    When I go to the new reply page for "My event"
#    And I fill in "Namn" with "Kalle"
#    And I fill in "E-postadress" with "kalle@example.org"
#    And I press "Boka"
#    
#    Then I should receive an email
#    
#    When I open the email
#    Then I should see "Thank you" in the subject
#    And I should see "Thank you for signing up to My event." in the email
#    And I should see the payment reference for the reply from "Kalle" to "My event" in the email body
  

  Scenario: Trying to sign up to an event with passed deadline
    Given an event "Plums" with fields:
      | Name     | Value       |
      | deadline | 10 days ago |
    
    When I go to the new reply page for "Plums"
    
    Then I should see "Deadline för anmälan till Plums har passerat"
  
  Scenario: Trying to sign up to an event with max number already signed up
    And an event "My very small event" with fields:
      | Name       | Value |
      | max_guests | 2     |
    And 2 guests signed up to "My very small event"
    
    When I go to the new reply page for "My very small event"
    
    Then I should see "Tyvärr är max antal anmälda redan anmälda"
  
  
  #Scenario: Signing up to an event with last payment date
  #  Given now is "2009-01-01"
  #  And an event "My event" with fields:
  #    | Name           | Value           |
  #    | bounce_address | foo@example.org |
  #  And "My event" has mail template "signup_confirmation" with fields:
  #    | Name    | Value                                            |
  #    | body    | Last payment date is {{REPLY_LAST_PAYMENT_DATE}} |
  #    | subject | Thank you                                        |
  #  And that "My event" has a payment time of 14 days
  #  
  #  
  #  When I go to the new reply page for "My event"
  #  And I fill in "Namn" with "Kalle"
  #  And I fill in "E-postadress" with "kalle@example.org"
  #  And I press "Boka"
  #  
  #  Then I should receive an email
  #  
  #  When I open the email
  #  
  #  Then I should see "Last payment date is 2009-01-15" in the email
  
  
  Scenario: Food preferences
    Given an event "Plums"
    
    Given food preference "Vegan" 
    And food preference "Vegetarian"
    
    When I go to the new reply page for "Plums"
    
    Then I should see "Vegan"
    And I should see "Vegetarian"
    
    When I fill in "Namn" with "Kalle"
    And I fill in "E-postadress" with "kalle@example.org"
    And I check "Vegan"
    And I press "Boka"
    
    When I log in as dkm
    And I go to the event page for "Plums"
    
    Then I should see "Vegan"
    #And I should see 1 "Vegan" in food preferences table
  

  Scenario: Signing up when logged in
    #Given an event "My event" owned by "random_user@example.org"
    #And I am logged in as an admin
    #
    #When I go to the new reply page for "My event"
    #
    #Then I should not see "Administrative functions"
  
    
  Scenario: Signing up to an event with terms
    Given I am logged in as dkm
    And an event "My legal event" with fields:
      | Name  | Value               |
      | terms | Anmälan är bindande |
      | owner | dkm@d.kth.se        |
    
    When I go to the new reply page for "My legal event"
    
    Then I should see "Anmälan är bindande"
    And I should see "Jag godkänner villkoren"
    
    And I fill in "Namn" with "Kalle"
    And I fill in "E-postadress" with "kalle@example.org"
    And I press "Boka"
    
    #TODO-RAILS3 Se till att den gäller rätt sak
    Then I should see "måste accepteras"
    
    When I check "Jag godkänner villkoren"
    And I press "Boka"
    
    Then I should see "Du har nu bokat en biljett till My legal event"
    
  Scenario: Signing up to event with personal identity number requirement
    Given I am logged in as dkm
    And an event "My pid event" with fields:
      | Name        | Value        |
      | require_pid | true         |
      | owner       | dkm@d.kth.se |
  
    When I go to the new reply page for "My pid event"
  
    Then I should see "Personnummer"
  
    When I fill in "Namn" with "Kalle"
    And I fill in "E-postadress" with "kalle@example.org"
    And I press "Boka"
  
    Then I should see "måste anges på korrekt form (YYMMDD-XXXX)"
  
    When I fill in "Personnummer" with "841027-0196"
    And I press "Boka"
  
    Then I should see "Du har nu bokat en biljett till My pid event"
  
Scenario: Signing up to a foodless event
  Given I am logged in as dkm
  And an event "My event" with fields:
    | Name                 | Value        |
    | use_food_preferences | false        |
    | owner                | dkm@d.kth.se |
    
  When I go to the new reply page for "My event"

  Then I should not see "Matpreferenser"
  And I should not see "Andra matpreferenser"

Scenario: Viewing guest list as a non-admin
  Given an event "My event"
  
  When I go to the new reply page for "My event"
  And I fill in "Namn" with "Kalle"
  And I fill in "E-postadress" with "kalle@example.org"
  And I fill in "Kommentar" with "My gosh, party!"
  And I fill in "Andra matpreferenser" with "I like cucumbers"
  And I press "Boka"
  
  And I go to the guest list page for "My event"
  
  Then I should see "Kalle"
  # TODO-AUTH
  #And I should not see "My gosh, party!"
  #And I should not see "I like cucumbers"
  #And I should not see "kalle@example.org"
  #And I should not see "Ta bort"
  #And I should not see "Redigera"

#    Feature: Cucumber stock keeping
#      In order to avoid interruption of cucumber consumption
#      As a citizen of Cucumbia
#      I want to know how many cucumbers I have left
#
#      Scenario Outline: eating
#        Given there are <start> cucumbers
#        When I eat <eat> cucumbers
#        Then I should have <left> cucumbers
#
#        Examples:
#          | start | eat | left |
#          |  12   |  5  |  7   |
#          |  20   |  5  |  15  |
#
#