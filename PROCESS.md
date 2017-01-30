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

##### Day 12 23-1-2017
* I made a few improvements to the segues to the chat screen. This was in preperation for chat implementation
* I configured Firebase in such a way that new chatrooms can be made. Open chats are shown as well in the open chats tab
* I implemented text chat functionality. Users can send messages and see messages that are received.
* I still have to implement media messages, and have to do some error handling for when a user tries to open a new chat while there already is one. I also still have to figure out a smart way to allow users to delete chatrooms.
* **no major issues**

##### Day 13 24-1-2017
* I added background images to all views. Made it so that it would show even through the cells
* Media messages are now stored on firebase. The problem with my current method is that it is pretty slow, and it wont stay in order of send time, so I should check if I can fix that.
* Added a webview, which can show the user youtube videos about a certain game. 
* Fixed the messy constraints, and made sure that all tableviews are somewhat on the same position.
* Fixed the bug that would crash the app if a list of players is requested for a game that no one is playing.
* **no major issues**

##### Day 14 25-1-2017
* I fixed a major bug that would overwrite existing chats. If a user would open a new chat with someone the user is already chatting with, that chat would be overwritten in both of them. 
* Added logout functionality for Chat list screen
* Did not do much else, as I wasnt feeling well
* Issue: The bug that would overwrite chats had to be fixed with a check. To implement the check however was challenging. Dax helped me with implementing a completion handler.

##### Day 15 26-1-2017
* I added a check that would check if the chatrooms child exists.
* Users can add a profile image, and the username is automatically added to the FIRAuth displayname
* The images are not loaded properly however, so I have to figure out a way that the image urls are retrieved easily
* Fixed the issue that images are not placed in the right order. Downloading the images also seems to go faster, but not significantly, by following the tutorial on Ray Wenderlich (https://www.raywenderlich.com/140836/firebase-tutorial-real-time-chat-2)
* **no other major issues**

##### Day 16 30-1-2017
* User images are now displayed in the followed players screen. Does take quite a bit of time for it to load however.
* Removed video message functionality, that might be a future feature.
* Organised the code quite a bit and added mark comments.
