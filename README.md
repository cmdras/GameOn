# GameOn
#### A gaming messenger app
#### Chris Ras. 10689958

In the GameOn app, gamers can reach out and chat to other players playing the same game. Users will be able to manage a list of games that they are playing, and find players that are playing the same game. Users will be able to chat with each other. 

#### Purpose
This app can be useful for Gamers who want to meet new people who share their interest in particular games, and for gamers who are looking for people to play online with. It is also useful for people who need help getting through a particular stage, or for gamers who are trying to form a team. In short, it's an app that helps Gamers communicate with each other about specific games. 

#### What will be needed:
* A live database API for user management (Such as Firebase)
* A chat API
* A list of games stored in a database.
  * This could be either in an existing database or a database that the users can add to.

#### External Sources
To implement my idea, several external libraries and API's had been used. The most important ones are the Firebase platform, the IGDB API, and the JSQMessageViewController library. 

##### Firebase
Firebase was used to be able to manage user data. User info, such as login info and profile images are all stored in Firebase. The list of games a user is playing is also stored, as well as which players the user is following. Chatrooms are also stored in Firebase, as well as images that might be sent in those chatrooms.

##### IGDB
IGDB.com is a video games database with information of thousands of games. If a user searches for a specific game, a request is sent to the API, returning information and images of the game. It is hosted on [Mashape.com](https://market.mashape.com/igdbcom/internet-game-database), where the free version is used. This means that in a day, 7000 requests can be made to the API, which might cause a lot of trouble if there are many users. 

##### JSQMessageViewController
The JSQMessageViewController library is used for the Chatroom functionality. It provides message bubbles and a custom keyboard with buttons. Used together with Firebase, user chat was made possible.

##### Other Sources
Besides the above 3, other resources were also used. AlamoFire and AlamoFireImage were used to make the JSON-requests to the IGDB API a bit more clear and orderly. I also used images for the tab bar, two of which I have to provide links for, which is found [here](https://icons8.com/web-app/7314/Controller) and [here](https://icons8.com/web-app/25461/YouTube). 

#### Screens
<img src="https://github.com/cmdras/GameOn/blob/master/doc/GameOn%20Screens%20FINAL/LoginScreen.png" alt="Login Screen" width="165" height="300"> <img src="https://github.com/cmdras/GameOn/blob/master/doc/GameOn%20Screens%20FINAL/MyGamesScren.png" alt="My Games Screen" width="165" height="300"> <img src="https://github.com/cmdras/GameOn/blob/master/doc/GameOn%20Screens%20FINAL/GameInfoScreen.png" alt="Game Info Screen" width="165" height="300"> <img src="https://github.com/cmdras/GameOn/blob/master/doc/GameOn%20Screens%20FINAL/YoutubeScreen.png" alt="Youtube Screen" width="165" height="300"> <img src="https://github.com/cmdras/GameOn/blob/master/doc/GameOn%20Screens%20FINAL/FollowedPlayersScreen.png" alt="Followed Players screen" width="165" height="300"> <img src="https://github.com/cmdras/GameOn/blob/master/doc/GameOn%20Screens%20FINAL/ChatScreen.png" alt="Chat Screen" width="165" height="300">


© 2017 Christopher Ras
