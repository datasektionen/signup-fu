Feature: Signing up
  As a person interested in an event
  I want to be able to get information about and sign up to an event
  So that the event arranger can know who will come to the event and therefore plan properly and not kill anyone or buy too much or too little food.
  
  Scenario Outline: Signing up on free event
    Given an event "My event" with fields:
      | Name           | Value                    |
      | signup_message | Thank you for signing up |
    
    When I go to the new reply page for "My event"
    
    Then I should see "Boka biljett till My event"
    
    When I choose "With alcohol (100 kr)"
    And I fill in "Namn" with "<name>"
    And I fill in "E-postadress" with "<email>"
    And I press "Boka"
    
    Then the <kind> flash should contain "<flash message>" 
    And I should see "<message>"
    
    Examples:
      | name         | email | kind   | flash message        | message                  |
      | Karl Persson | kalle | notice | Din bokning lyckades | Thank you for signing up |
      |              | kalle | error  |                      | Namn måste anges         |
      | Karl Persson |       | error  |                      | Email måste anges        |
  
  Scenario Outline: Choosing a Biljettyp
    Given an event "My event"
    
    When I go to the new reply page for "My event"
    And I fill in "Namn" with "Kalle"
    And I fill in "E-postadress" with "kalle@example.org"
    And I choose "<ticket type>"
    And I press "Boka"
    
    Then the notice flash should contain "<flash message>" 
    And I should see "<message>"
    
    And I go to the event page for "My event"
    And I fill in "Password" with "WordPass"
    And I press "Login"
    Then I should see "With alcohol" in "guest_list_table"
    
    Examples:
      | ticket type           | flash message        | message |
      | With alcohol (100 kr) | Din bokning lyckades |         |
  
  Scenario: Mail notification when signing up
    Given an event "My event"
    
    And "My event" has mail template "signup_confirmation" with fields:
      | Name    | Value                                      |
      | body    | Thank you for signing up to {{EVENT_NAME}}. Your payment reference is {{PAYMENT_REFERENCE}} |
      | subject | Thank you                                  |
    
    When I go to the new reply page for "My event"
    And I fill in "Namn" with "Kalle"
    And I fill in "E-postadress" with "kalle@example.org"
    And I choose "With alcohol (100 kr)"
    And I press "Boka"
    
    Then I should receive an email
    
    When I open the email
    Then I should see "Thank you" in the subject
    And I should see "Thank you for signing up to My event." in the email
    And I should see the payment reference for the reply from "Kalle" to "My event" in the email body
  

  Scenario: Trying to sign up to an event with passed deadline
    Given an event "My event" with fields:
      | Name     | Value       |
      | deadline | 10 days ago |
    
    When I go to the new reply page for "My event"
    
    Then I should see "Deadline för anmälan till My event har passerat"
  
  Scenario: Trying to sign up to an event with max number already signed up
    Given an event "My very small event" with fields:
      | Name       | Value |
      | max_guests | 2     |
    And 2 guests signed up to "My very small event"
    
    When I go to the new reply page for "My very small event"
    
    Then I should see "Tyvärr är max antal anmälda redan anmälda"
  
  
  Scenario: Signing up to an event with last payment date
    Given now is "2009-01-01"
    And an event "My event" with fields:
      | Name           | Value           |
      | bounce_address | foo@example.org |
    And "My event" has mail template "signup_confirmation" with fields:
      | Name    | Value                                            |
      | body    | Last payment date is {{REPLY_LAST_PAYMENT_DATE}} |
      | subject | Thank you                                        |
    And that "My event" has a payment time of 14 days
    
    
    When I go to the new reply page for "My event"
    And I choose "With alcohol (100 kr)"
    And I fill in "Namn" with "Kalle"
    And I fill in "E-postadress" with "kalle@example.org"
    And I press "Boka"
    
    Then I should receive an email
    
    When I open the email
    
    Then I should see "Last payment date is 2009-01-15" in the email
  
  
  Scenario: Food preferences
    Given an event "My event"
    
    Given food preference "Vegan" 
    And food preference "Vegetarian"
    
    When I go to the new reply page for "My event"
    
    Then I should see "Vegan"
    And I should see "Vegetarian"
    And I choose "With alcohol (100 kr)"
    And I fill in "Namn" with "Kalle"
    And I fill in "E-postadress" with "kalle@example.org"
    And I check "Vegan"
    And I press "Boka"
    
    When I go to the event page for "My event"
    And I fill in "Password" with "WordPass"
    And I press "Login"
    
    Then I should see "Vegan"
    #And I should see "1 Vegan"
  

  Scenario: Signing up when logged in
    #Given an event "My event"
    #And I am logged in as an admin
    #
    #When I go to the new reply page for "My event"
    #
    #Then I should not see "Administrative functions"
  
    
  Scenario: Signing up to an event with terms
    Given an event "My legal event" with fields:
      | Name  | Value               |
      | terms | Anmälan är bindande |
    
    When I go to the new reply page for "My legal event"
    
    Then I should see "Anmälan är bindande"
    And I should see "Jag godkänner villkoren"
    
    And I fill in "Namn" with "Kalle"
    And I fill in "E-postadress" with "kalle@example.org"
    And I choose "With alcohol (100 kr)"
    And I press "Boka"
    
    Then I should see "villkoren måste accepteras"
    
    When I check "Jag godkänner villkoren"
    And I press "Boka"
    
    Then I should see "Din bokning lyckades"
    
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