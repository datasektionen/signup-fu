Feature: Guest list viewing

Scenario: Viewing guest list as not logged in user
  Given an event "Plums"
  And a guest to "Plums" called "Kalle"
    | Name     | Value               |
    | email    | kalle@example.org   |
    | comments | Hej världen        |
    | food     | Gillar inte tomater |
  When I go to the guest list page for "Plums"
  
  Then I should not see "Pricka av"
  And I should not see "Matpreferenser"
  And I should not see "Gillar inte tomater"
  And I should not see "Hej världen"
  And I should not see "kalle@example.org"
  And I should see "Kalle"