Feature: Managing events
As a event arranger
I want to be able to create, edit and view my events
So that I can have something that my guests can sign up to, so I get guests to my events

Background: 
  Given I am logged in as dkm

# Börja med att markera som attending -> betald
Scenario: Marking a guest as attending
  Given an event "Plums"
  And a guest to "Plums" called "Karl Persson"
    ||
  
  And I go to the guest list page for "Plums"
  
  And I fill in "Name" with "Karl Persson"
  And I press "Pricka av"
  
  # TODO how check this now that I've removed it from the guest
  # list page? (d146f1df6243db70144dac12b4c6d2d6ce9acc10)
  #Then I should be on the guest list page for "My event"
  #And I should see "Attending"


