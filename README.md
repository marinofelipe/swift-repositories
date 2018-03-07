# swift-repositories

[![CI Status](http://img.shields.io/travis/marinofelipe/swift-repositories.svg?style=flat)](https://travis-ci.org/marinofelipe/swift-repositories)
[![Coverage Status](https://coveralls.io/repos/github/marinofelipe/swift-repositories/badge.svg?branch=master)](https://coveralls.io/github/marinofelipe/swift-repositories?branch=master)

# Swift Repositories
Shows swift repositories ordered by stars. <br>
User is able to favorite by selecting the repository star button or dragging to the favorites screen. <br>
The transition to and from pull requests were made to make the app more elegant. <br>
Offline persistence is working and the app can be used in landscape as well.

# Setup 
Install [CocoaPods](https://cocoapods.org)

```$ sudo gem install cocoapods```

Add your TOKEN to info.plist "ApiToken" key
- In your github profile go to "Settings -> Developer Settings -> Personal access token"
- Generate a new token with "repo" scope enabled
- Copy your token, then after opening the project in Xcode, select Info.plist and paste in ApiToken key

# How to Compile

```$ git clone https://github.com/marinofelipe/swift-repositories.git```

Install dependencies

```$ pod install```

# Screenshoots

Search             |  Favorites                 
:-------------------------:|:-------------------------:|
<img src="screenshots/search.PNG" width="300">  |  <img src="screenshots/favorites.PNG" width="300"> 

Landscape
:-------------------------:
<img src="screenshots/landscape.PNG" width="600">

Pull Requests             |  Web View                
:-------------------------:|:-------------------------:|
<img src="screenshots/pullRequests.PNG" width="300"> | <img src="screenshots/webView.PNG" width="300">
