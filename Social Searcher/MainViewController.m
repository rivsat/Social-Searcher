//
//  MainViewController.m
//  Social Searcher
//
//  Created by Tasvir H Rohila on 25/08/15.
//  Copyright (c) 2015 Tasvir H Rohila. All rights reserved.
//

#import "MainViewController.h"
#import "TweetDataModel.h"

@interface MainViewController ()

@property (nonatomic, strong) HttpNetworkModel *httpNetworkModel;
@property (nonatomic, strong) NSMutableArray *tweetResultsArray;

@end

@implementation MainViewController
/**
 * Add a data point to the data source.
 * (Removes the oldest data point if the data source contains kMaxDataPoints objects.)
 *
 * @param aDataPoint An instance of ABCDataPoint.
 * @return The oldest data point, if any.
 */
-(void) test
{
    @try {
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in :: . Details: %@",exception.description);
    }
}

//Boiler-plate code initWithCoder. Initialise your objects here.
-(id) initWithCoder:(NSCoder *)aDecoder
{
    //We should give it a default value. The initWithCoder method is a good place for that.
    if ((self = [super initWithCoder:aDecoder]))
    {
        NSLog(@"initWithCoder MainViewController");
        _httpNetworkModel = [[HttpNetworkModel alloc] init];
        _httpNetworkModel.delegate = self;
        
        _tweetResultsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

//Boiler-plate code dealloc. Dealloc your objects here.
- (void)dealloc
{
    NSLog(@"dealloc MainViewController");
}

//Boiler-plate code viewDidLoad. Initialise your objects here.
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

//Boiler-plate code didReceiveMemoryWarning. Release memory of your objects here.
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _tweetResultsArray = nil;
}

/**
 * UISearchBar delegate method called when search button is tapped
 *
 * @param aSearchBar An instance of UISearchBar.
 * @return void
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *) aSearchBar {
    NSString *searchText = _querySearchBar.text;
    //dismiss the keyboard
    [_querySearchBar resignFirstResponder];
    [_httpNetworkModel performTwitterSearch:searchText];
}

#pragma mark - TableView data source
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_tweetResultsArray != nil) {
        return _tweetResultsArray.count;
    }
    else {
        return 0;
    }
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - TableView delegates

#pragma mark HttpNetworkModelDelegate
/**
 * HttpNetworkModel delegate method called when search results have been fetched and parsed
 *
 * @param HttpNetworkModel and resultsArray.
 * @return void
 */
-(void) httpNetworkModel:(HttpNetworkModel *)networkModel didFinishLoadingData:(NSArray *) resultsArray
{
    @try {
        if (resultsArray && resultsArray.count)
        {
            [_tweetResultsArray addObjectsFromArray:resultsArray];
            [_resultsTableView reloadData];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in httpNetworkModel::didFinishLoadingData. Details: %@", exception.description);
    }
}

@end
