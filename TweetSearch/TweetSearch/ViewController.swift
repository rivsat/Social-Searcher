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
        
        if let data = TweetDataManager.shared.getTweet(at: indexPath.row, onComplete: refreshItem) {
            cell.name.text = data.user.name
            cell.userName.text = data.user.screenName
            cell.period.text = data.createdAt
            cell.tweetText.text = data.text
            debugPrint(data.text)
            
            cell.layoutIfNeeded()
            cell.imageSmall.layer.cornerRadius = 12.0
            //cell.carImage.downloadFromURL(data.mainPhotoURL)
            if let mainPhotoData = TweetDataManager.shared.getTweet(at: indexPath.row, onComplete: refreshItem)?.user.profileImageData {
                cell.imageSmall.image = UIImage(data: mainPhotoData)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func refreshItem(at index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

class TweetCell: UITableViewCell {
    @IBOutlet weak var imageSmall: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var period: UILabel!
    @IBOutlet weak var tweetText: UILabel!
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchBarText = searchBar.text {
            searchTweet(searchString: searchBarText)
        } else {
            //            CarDataManager.sharedInstance().reloadData()
        }
    }
    /*func updateSearchResults(for searchController: UISearchController) {
        if let searchBarText = searchController.searchBar.text {
            //            CarDataManager.sharedInstance().filterSearch(searchBarText)
        } else {
            //            CarDataManager.sharedInstance().reloadData()
        }
        self.tableView.reloadData()
    }*/
    
    func searchTweet(searchString: String) {
        TweetDataManager.shared.getTweets(forQuery: searchString,
                                          onSuccess: { self.tableView.reloadData() },
                                          onFailure: { (errorString) in
                                            showAlert(callingVC: self, title: "Tweet Search", message: "Could not find any matching tweets")
        })
    }
}

