# Design Document

* Login/Registration - **Firebase** handles user login and registration
* Users list of games - **Firebase** to store data, **IGDB API** for video game titles and info
* Searching players by game and following them - **Firebase** to store user lists
* Friendlist management - **Firebase** to store the friendlist
* Chatrooms - A combination of **Firebase** and **JSQMessageViewController**

#### Minimum Viable Product

* Users are able to create an account, which is stored in a database
* Users are able to look up games and be presented information about that game. User should also be able to store the games in a personal list
* Users should be able to see what other users are playing a specific game
* Users should be able to send text messages to other users

#### Optional Features

* Users should be able to follow other players, and see what other games that user is playing
* Users should be able to receive notifications when a followed player adds a new game
* Users should be able to receive notifications when a message has been received
* Users should be able to send images and/or videos via chat
* Users should be able to view videos of a specific game via Youtube and/or Twitch



#### Storyboard
<img src="https://github.com/cmdras/GameOn/blob/master/doc/login_screen_alpha.png" alt="Login Screen" width="165" height="300">

This is the login screen, where users can register and login to their accounts. By logging in, users are presented a tab bar, with the following view controllers.

<img src="https://github.com/cmdras/GameOn/blob/master/doc/games_list_alpha.png" alt="Games List" width="165" height="300">
<img src="https://github.com/cmdras/GameOn/blob/master/doc/players_screen_alpha.png" alt="Players List" width="165" height="300">
<img src="https://github.com/cmdras/GameOn/blob/master/doc/chat_list_screen_alpha.png" alt="Chat List" width="165" height="300">

The buttons at the top of the screen will not be included in the final version. At the moment they serve as placeholders for pressing an item on the tableview. Pressing the button on the Game tab will perform a segue to the following screen.


<img src="https://github.com/cmdras/GameOn/blob/master/doc/game_info_screen_alpha.png" alt="Game Info" width="165" height="300">

On the game info screen, various information will be given about the game. Pressing the button will reveal what users are playing this game. An option will then be given to follow that player.

Pressing the button on the Players tab will present a tableview of all the games that that user is playing.

The Chat tab will have two different segues. If an open chat in the tableview is pressed, that chat will be opened on the chat screen. If the new chat button
is pressed, a tableview of all followed players will be presented. If a cell of the tableview is pressed (which is the username), a chat will be 
opened with that user. A mockup of the chatscreen:

<img src="https://github.com/cmdras/GameOn/blob/master/doc/chatroom_screen_alpha.png" alt="Chatroom" width="165" height="300">



