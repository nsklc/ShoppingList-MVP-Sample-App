## ShoppingList - MVP Sample App

In the MVP viewController is considered as a view. Which means it will include only the view related code, nothing more. and all logic will be implemented in the presenter.
It's important to note that MVP uses passive View pattern. it means all the actions will be forwarded to the presenter. Which will trigger the ui updates using delegates. so the view will only passes actions and listen to the presenter updates.

Used 3rd party libraries with SPM
Realm
