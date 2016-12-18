Social-Searcher
===============
**This is a simple client written in iOS for querying Twitter for tweets matching the specified keywords.**
# Branch Swift-2.3 has been re-written using Swift Version 2.3

Features
=========
* The app uses Twitter’s v1.1 REST API. 
* It allows queries against the indices of recent or popular Tweets and behaves similarily to, but not exactly like the Search feature available in Twitter mobile or web clients.
* Supports paging of results, if the user scrolls to the bottom of the search results, the app fetches and displays more results.
* The app demonstrates use of advanced networking conceps as:-
    - Asynchronous data tasks (URLSession)
    - Consuming data from RESTful server API
    - JSON parsing and object creation
* Use of UITableView with dynamically sizing cells as per the size of the content
* Applying rounded corners to an ImageView

## Platform Details 

* iOS > 8.0
* Xcode 8.0
* Swift 2.3

Contributors
=============
Tasvir Rohila <tasvir.rohila@gmail.com>

License
========
No licence required.
