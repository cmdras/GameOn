##### Day 1
* Thought of GameOn idea
* Wrote proposal
* Created repo and project file
* **no major issues**

##### Day 2
* Thought of view structure
* Started with a few view controllers in Xcode
* **no major issues**

##### Day 3
* Imported most necessary modules
* Implemented Firebase login functionality
* Made Design document
* **no major issues**

#### Day 4
* Started fumbling around with the IGDB database
* Added more views to the project
* Finished alpha-prototype
* Added logout functionality
* Issue: I tried previously to search while typing in the textbox. I decided to remove that feature since it didn't work, however that caused the
program to crash. Fix: on the left hand bar in the search icon, searched for the previous search bar, where it showed me where i had to fix it

#### Day 5
* Started implementing API in the app
* Searching for games is functional
* Issue: Nested request; I tried to make a request to retrieve the image from a url. However, the table cells would load with  stock images instead
of the url images, because it was an async task. Fix: since I use AlamofireImage, a UIImage can find an image via a url, which will then load nicely.
Usage: UIImage.af_setImage(withURL: url!)

##### Day 6
* Removed a few bugs from the search screen
* Added error handling for release_date and image url
* when pressing a search result, the game info will now load
* **no major issues**

##### Day 7
* Added game storage functionality in Firebase
* Users games are now shown in personal list
* Delete functionality added
* **no major issues**

##### Day 8
* Did not work much on the project
* Viewed Tutorials for implementing chat

##### Day 9
* Finished chat tutorial, did not implement yet
* Added a register screen that asks the user for a username
* Games should keep track of which users are playing them. This however is not fully functional
