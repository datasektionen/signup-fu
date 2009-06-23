Feature: Signing up
  As a person interested in an event
  I want to be able to get information about and sign up to an event
  So that the event arranger can know who will come to the event and therefore plan properly and not kill anyone or buy too much or too little food.
  
  Scenario Outline: Signing up on free event
    Given an event "My event"
    And a ticket type "Normal ticket" for 1 on "My event"
    
    When I go to the new reply page for "My event"
    And I select "Normal ticket" from "Ticket type"
    And I fill in "Name" with "<name>"
    And I fill in "E-mail" with "<email>"
    And I press "Sign up"
    
    Then the flash should contain "<flash message>" 
    And I should see "<message>"
    
    Examples:
      | name         | email | flash message               | message           |
      | Karl Persson | kalle | Your signup was successful! |                   |
      |              | kalle |                             | Name is required  |
      | Karl Persson |       |                             | Email is required |
  
  Scenario Outline: Choosing a ticket type
    Given an event "My event"
    And a ticket type "With alcohol" for 100 on "My event"
    
    When I go to the new reply page for "My event"
    And I fill in "Name" with "Kalle"
    And I fill in "E-mail" with "kalle@example.org"
    And I select "<ticket type>" from "Ticket type"
    And I press "Sign up"
    
    Then the flash should contain "<flash message>" 
    And I should see "<message>"
    
    When I go to the event page for "My event"
    Then I should see "With alcohol" in "guest_list_table"
    
    Examples:
      | ticket type  | flash message               | message |
      | With alcohol | Your signup was successful! |         |
  
  Scenario: Mail notification when signing up
    Given an event "My event"
    And a ticket type "With alcohol" for 100 on "My event"
    
    And "My event" has mail template "signup_confirmation" with fields:
      | Name    | Value                                      |
      | body    | Thank you for signing up to {{EVENT_NAME}} |
      | subject | Thank you                                  |
    
    When I go to the new reply page for "My event"
    And I fill in "Name" with "Kalle"
    And I fill in "E-mail" with "kalle@example.org"
    And I select "With alcohol" from "Ticket type"
    And I press "Sign up"
    
    Then I should receive an email
    
    When I open the email
    Then I should see "Thank you" in the subject
    And I should see "Thank you for signing up to My event" in the email
  

  Scenario: Trying to sign up to an event with passed deadline
    Given an event "My event" with fields:
      | Name     | Value       |
      | deadline | 10 days ago |
    
    When I go to the new reply page for "My event"
    
    Then I should see "The deadline for My event has passed"
  
  Scenario: Trying to sign up to an event with max number already signed up
    Given an event "My very small event" with fields:
      | Name       | Value |
      | max_guests | 2     |
    And a ticket type "With alcohol" for 100 on "My very small event"
    And 2 guests signed up to "My very small event"
    
    When I go to the new reply page for "My very small event"
    
    Then I should see "There are already the max number of guests signed up for this event"
  
  
  Scenario: Signing up to an event with last payment date
    Given that now is "2009-01-01"
    And an event "My event"
    And a ticket type "Normal ticket" for 1 on "My event"
    And "My event" has mail template "signup_confirmation" with fields:
      | Name    | Value                                                                                        |
      | body    | Last payment date is {{REPLY_LAST_PAYMENT_DATE}} |
      | subject | Thank you                                                                                    |
    And that "My event" has a payment time of 14 days
    
    
    When I go to the new reply page for "My event"
    And I select "Normal ticket" from "Ticket type"
    And I fill in "Name" with "Kalle"
    And I fill in "E-mail" with "kalle@example.org"
    And I press "Sign up"
    
    Then I should receive an email
    
    When I open the email
    
    Then I should see "Last payment date is 2009-01-15" in the email
    
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