# GameOn
#### Chris Ras. 10689958

#### Description
GameOn is an app which allows users to find search for games, and communicate with other users playing those games.


<img src="https://github.com/cmdras/GameOn/blob/master/doc/GameOn%20Screens%20FINAL/GameInfoScreen.png" alt="Game Info Screen" width="165" height="300">

#### Design
##### Overview
When the user opens up the app, the **LoginViewController** is loaded. Here the user can fill in login credentials if an account already exists, or press on the "Register" button to make a new account. 

Pressing the "Register" button brings the user to the **RegistrationViewController**. Here, the user must fill in a username, e-mail, and password. The
user can optionally change the profile photo to something personal, or just leave it as a stock image. If the register button is pressed,
a new account is made, and the user can proceed. 

Whether the user logs in from the **LoginViewController** or **RegistrationViewController**, the next screen presented is the **UsersGamesViewController**.
This view is part of a TabBarController, along with **PlayersViewController** and **ChatViewController**.

###### UsersGamesViewController
On this screen, a table is presented of all the games that the user is playing. If one of those cells is touched, the **GameInfoViewController**, is shown, which displays information about the selected game. If the "Search Games" button is pressed, the **SearchGamesViewController** is presented, where the user is able to search for games to add. 

###### SearchGamesViewController
If the user enters a string representing the name of a game and presses the "Search" button, a table will be shown containing the search results. 
Tapping one of these cells will present the **GameInfoViewController**, with information about the selected game. 

###### GameInfoViewController
This view is shown if a specific game is selected. The title, the cover, and a description is shown (if available). Furthermore, if the user taps the "Add Game To My List" button, that particular game is saved in the users personal list of games. Tapping the "Players Playing This Game" button presents the **GamePlayersViewController**, which shows a list of users that are playing that game. On that screen, users can follow other players. Tapping the "Youtube" button, takes the user to the **GameVideosVC**, which shows players a Youtube search query of that specific game. 

###### PlayersViewController
This is the second view on the TabBarController. This screen shows a table of all the players the user is following. If a cell is tapped, a table is shown of all games that the selected player is playing, in the **FollowedPlayersGamesViewController**. 

###### ChatViewController
This is the third view on the TabBarController. This screen shows a table of player that the user is currently chatting with. Tapping on a cell will open the chatroom, in **ChatroomVC**. If the "New Chat" button is touched, the user can select a player that he/she is following and start chatting with them.

###### ChatroomVC
In this view, a chat is presented between the user and another player. The user can send/receive text messages or photos.

##### Technical Details
There are several modules and classes used in the GameOn app. The main one is Firebase. Firebase is used to store information online. Firstly, account info is kept in Firebase. When a user makes an account, a username, email, password, and profile image is stored in Firebase, which can later be retrieved.
If a user searches for a game, a HTTP request is made to the IGDB database, using Alamofire the module. This returns a JSON object which contains multiple games and information of that game. When a game is selected, a Game object is made. A Game object has a title, release date, a cover url, and a summary. It also has methods that can store the game info in a dictionary in Firebase under the correct user. When retrieving this dictionary, it is remade into a Game object.
The players that the user is following is stored into Firebase. On the **PlayersViewController**, this dict is retrieved and presented in the table. 
Chatrooms are also stored in Firebase, as a dictionary. It has the keys "Chat participants" and "Messages". When a message is sent, the string is stored in the "Messages" child of the database. To display the message in a nice way in the **ChatroomVC**, JSQMessageViewController is used. It is a module that displays messages in a CollectionView, and looks like iMessage. By implementing the several functions that came with JSQMessageViewController, chat functionality is provided. 

#### Challenges
//TODO
 
#### Future Features
//TODO
