//
//  ViewController.swift
//  TweetSearch
//
//  Created by Tasvir H Rohila on 08/12/16.
//  Copyright © 2016 Tasvir H Rohila. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var resultSearchController:UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        initialize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func getAccessToken() {
        TweetDataManager.shared.getAccessToken(onSuccess: { (accessToken) in
        }, onFailure: { (errorString) in
            print(errorString)
        })
    }
    
    func initialize() {
        getAccessToken()
        initializeTableView()
        initializeSearchBar()
    }

    func initializeTableView() {
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
    }
    
    func initializeSearchBar() {
        func configureSearchBar() {
            let searchBar = resultSearchController!.searchBar
            searchBar.sizeToFit()
            searchBar.placeholder = "Search for tweeets"
            searchBar.keyboardType = .webSearch
            navigationItem.titleView = resultSearchController?.searchBar
            
            //
            resultSearchController?.hidesNavigationBarDuringPresentation = false
            resultSearchController?.dimsBackgroundDuringPresentation = false
            definesPresentationContext = true
        }
        
        resultSearchController = UISearchController(searchResultsController: nil)
        resultSearchController?.searchBar.delegate = self
        
        func config2() {
            if let searchBar = resultSearchController?.searchBar {
                searchBar.sizeToFit()
                searchBar.placeholder = "Search tweets"
                navigationItem.titleView = resultSearchController?.searchBar
                
                //
                resultSearchController?.hidesNavigationBarDuringPresentation = false
                resultSearchController?.dimsBackgroundDuringPresentation = false
                definesPresentationContext = true
            }
        }
        configureSearchBar()
    }
}

//MARK: - UITableView DataSource, Delegate and supporting methods
//MARK:
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TweetDataManager.shared.tweetCount
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "Cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        if let data = TweetDataManager.shared.getTweet(at: indexPath.row, onComplete: nil) {
            populateData(forcell: cell, data: data, at: indexPath.row)
            fetchMoreTweets(currentRow: indexPath.row)
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    /**
     Refresh item is called from the TweetDataManager, when image data is downloaded and needs UI refresh
    */
    func refreshItem(at index: Int) {
        //Optimisation: Check if index of the item to refresh is among the visibleCells, then update the `imageSmall`
        if let data = TweetDataManager.shared.getTweet(at: index, onComplete: nil) {
            if let visibleCell = tableView.visibleCells.filter( { ($0 as! TweetCell).userName.text == data.user.screenName } ).first as? TweetCell {
                if let imageData = data.user.profileImageData {
                    visibleCell.imageSmall.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    /**
     Populates the data for the tweetCell at row with the provided data
    */
    func populateData(forcell cell: TweetCell, data: Tweet, at row: Int) {
        cell.name.text = data.user.name
        cell.userName.text = data.user.screenName
        cell.period.text = data.createdAt
        cell.tweetText.text = data.text
//        debugPrint(data.text)
        
        cell.layoutIfNeeded()
        cell.imageSmall.roundCornersForAspectFit(radius: 12.0)
        cell.clipsToBounds = true
        //cell.carImage.downloadFromURL(data.mainPhotoURL)
        if let mainPhotoData = TweetDataManager.shared.getTweet(at: row, onComplete: refreshItem)?.user.profileImageData {
            cell.imageSmall.image = UIImage(data: mainPhotoData)
        }
    }
    
    /**
     Fetches more tweets if the currentRow is the last of the tweetCount
    */
    func fetchMoreTweets(currentRow: Int) {
        let tweetCount = TweetDataManager.shared.tweetCount
        let visibleTweetCount = tableView.visibleCells.count
        guard visibleTweetCount != 0 else {
            return
        }

        //Fetch more tweets only if there are more tweets than those visible on the screen
        if currentRow == tweetCount - 1 && tweetCount > visibleTweetCount {
            /*
            //Option1: fetch next results as per the maxId of the last row in tweets
            if let maxId = TweetDataManager.shared.getTweet(at: tweetCount-1, onComplete: nil)?.idStr {
                self.searchTweet(searchString: resultSearchController?.searchBar.text ?? "", maxId: maxId)
                tableView.reloadData()
            }*/
            
            //Option2: Query as per the next_results metaData returned by the search API 
            TweetDataManager.shared.getNextTweets(onSuccess: { 
                self.tableView.reloadData()
            }, onFailure: { (errorString) in
                //No more tweets, so nothing to update
            })
        }
    }
}

class TweetCell: UITableViewCell {
    @IBOutlet weak var imageSmall: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var period: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    
    override func awakeFromNib() {
         super.awakeFromNib()
        
    }
}

//MARK: -
//MARK: UISearchBarDelegate methods
extension ViewController: UISearchBarDelegate {
    
    // called when keyboard search button pressed
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchBarText = searchBar.text {
            searchTweet(searchString: searchBarText)
        } else {
            TweetDataManager.shared.clearTweets()
            tableView.reloadData()
        }
    }
    
    // called when cancel button pressed
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        TweetDataManager.shared.clearTweets()
        tableView.reloadData()
    }
    
    func searchTweet(searchString: String, maxId: String = "") {
        TweetDataManager.shared.getTweets(matchine: searchString,
                                          onSuccess: { self.tableView.reloadData() },
                                          onFailure: { (errorString) in
                                            showAlert(callingVC: self, title: "Tweet Search", message: "Could not find any matching tweets")
        })
    }
}

