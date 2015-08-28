//
//  MainViewController.h
//  Social Searcher
//
//  Created by Tasvir H Rohila on 25/08/15.
//  Copyright (c) 2015 Tasvir H Rohila. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpNetworkModel.h"

@interface MainViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate,
UIScrollViewDelegate, HttpNetworkModelDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *mainNavigationBar;
@property (weak, nonatomic) IBOutlet UISearchBar *querySearchBar;
@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;

@property (retain, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

