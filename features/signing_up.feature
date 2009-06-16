Feature: Signing up
  As a person interested in an event
  I want to be able to get information about and sign up to an event
  So that the event arranger can know who will come to the event and therefore plan properly and not kill anyone or buy too much or too little food.
  
  Scenario Outline: Signing up
    Given an event "My event"
    
    When I go to the new reply page for "My event"
    And I fill in "Name" with "<name>"
    And I fill in "E-mail" with "<email>"
    And I press "Sign up"
    
    Then the flash should contain "<flash message>" 
    And I should see "<message>"
    
    Examples:
      | name         | email | flash message                | message           |
      | Karl Persson | kalle | Your signup was successful! |                   |
      |              | kalle |                              | Name is required  |
      | Karl Persson |       |                              | Email is required |
    
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