##### Day 1 9-1-2017
* Thought of GameOn idea
* Wrote proposal
* Created repo and project file
* **no major issues**

##### Day 2 10-1-2017
* Thought of view structure
* Started with a few view controllers in Xcode
* **no major issues**

##### Day 3 11-1-2017
* Imported most necessary modules
* Implemented Firebase login functionality
* Made Design document
* **no major issues**

#### Day 4 12-1-2017
* Started fumbling around with the IGDB database
* Added more views to the project
* Finished alpha-prototype
* Added logout functionality
* Issue: I tried previously to search while typing in the textbox. I decided to remove that feature since it didn't work, however that caused the
program to crash. Fix: on the left hand bar in the search icon, searched for the previous search bar, where it showed me where i had to fix it

#### Day 5 13-1-2017
* Started implementing API in the app
* Searching for games is functional
* Issue: Nested request; I tried to make a request to retrieve the image from a url. However, the table cells would load with  stock images instead
of the url images, because it was an async task. Fix: since I use AlamofireImage, a UIImage can find an image via a url, which will then load nicely.
Usage: UIImage.af_setImage(withURL: url!)

##### Day 6 14-1-2017
* Removed a few bugs from the search screen
* Added error handling for release_date and image url
* when pressing a search result, the game info will now load
* **no major issues**

##### Day 7 15-1-2017
* Added game storage functionality in Firebase
* Users games are now shown in personal list
* Delete functionality added
* **no major issues**

##### Day 8 16-1-2017
* Did not work much on the project
* Viewed Tutorials for implementing chat

##### Day 9 17-1-2017
* Finished chat tutorial, did not implement yet
* Added a register screen that asks the user for a username
* Games should keep track of which users are playing them. This however is not fully functional

##### Day 10 18-1-2017
* Games are now stored correctly in Firebase, because I wrote a function that can add a key value pair to a Firebase, instead of overwriting it
* Games are now properly deleted from all lists if the user deletes a game from the personal list
* Made sure that new usernames are unique. (Odd characters such as spaces are still allowed, so I have to change that)
* Made a few minor improvements to segues and selections.
* Users can now see which players are playing a particular game by touching the button
* **no major issues**

##### Day 11 19-1-2017 
* Users will be able to follow eachother now. Since the information is stored in a dict, there wont be any duplicate follows, but if there is time I should atleast implement some kind of check.
* I also linked the segues, so that users can see which games a followed player is playing.
* Made a start to chat functionality. Users can send messages, but there is no recipient yet, and messages are not stored in Firebase.
* Implemented media messages.
* **no major issues**
