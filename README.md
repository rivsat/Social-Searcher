# Social-Searcher
-------------------------------------------------------------------
Synopsis
-------------------------------------------------------------------
This is a simple client written in iOS for querying Twitter for tweets matching the specified keywords. This client uses Twitter’s v1.1 REST API. It allows queries against the indices of recent or popular Tweets and behaves similarily to, but not exactly like the Search feature available in Twitter mobile or web clients.

-------------------------------------------------------------------
Packages / Dependencies
-------------------------------------------------------------------
The project uses below two iOS frameworks:
1) Accounts.framework 
2) Social.framework

NOTE: Please configure at least one Twitter account on your iOS device.

-------------------------------------------------------------------
Unit Testing Framework:
-------------------------------------------------------------------
The project uses Kiwi framework for performing tests. Kiwi is a BDD framework for Objective-C.
More info about Kiwi: https://github.com/kiwi-bdd

Please use CocoaPods for downloading the Kiwi framework. 
CocoaPods is the dependency manager for Swift and Objective-C Cocoa projects. 
More info about CocoaPods: https://cocoapods.org

-------------------------------------------------------------------
Project Configuration
-------------------------------------------------------------------
** This project has been compiled and created in XCode Version 6.3.2 (6D2105) **
General Settings:
    Deployment Target = iOS SDK 8.3
    Devices = iPhone
    Linked Frameworks
           UIKit
           Accounts
           Social
Build Settings
     Base SDK = iOS 8.3

All other settings are standard and built into the .xcodeproject file

-------------------------------------------------------------------
API Reference
-------------------------------------------------------------------
The project uses Apple's SystemConfiguration Reachablity APIs.

-------------------------------------------------------------------
Tests
-------------------------------------------------------------------
I've tried to cover maximum test coverage'.
Tests for following modules has been covered:-
* MainViewControllerSpec
* TweetDataModelSpec


-------------------------------------------------------------------
Contributors
-------------------------------------------------------------------
Tasvir Rohila <tasvir.rohila@gmail.com>

-------------------------------------------------------------------
License
-------------------------------------------------------------------
No licence required.
