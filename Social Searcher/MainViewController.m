//
//  MainViewController.m
//  Social Searcher
//
//  Created by Tasvir H Rohila on 25/08/15.
//  Copyright (c) 2015 Tasvir H Rohila. All rights reserved.
//

#import "MainViewController.h"
#import "TweetDataModel.h"
#import "SearchTableViewCell.h"
#import "AccountManager.h"
#import "Reachability.h"
#import "Constants.h"

@interface MainViewController ()

@property (nonatomic, strong) HttpNetworkModel *httpNetworkModel;
@property (nonatomic, strong) NSMutableArray *tweetResultsArray;
@property (nonatomic, strong) NSMutableArray *imageCacheArray;
@property (nonatomic) BOOL noMoreResultsAvail;
@property (nonatomic) BOOL loading;
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, strong) NSMutableDictionary *searchMetaData;

@property (nonatomic, retain) Reachability *internetReachable;
@property (nonatomic, retain) Reachability *hostReachable;

@property BOOL internetActive;
@property BOOL hostActive;
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
        _imageCacheArray =  [[NSMutableArray alloc] init];
        _searchText = [[NSString alloc] init];
        _searchMetaData = [[NSMutableDictionary alloc] init];
        
        //Initialise the internet reachablility observer
        // check for internet connection
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
        
        _internetReachable = [Reachability reachabilityForInternetConnection];
        [_internetReachable startNotifier];
        
        // check if a pathway to a random host exists
        _hostReachable = [Reachability reachabilityWithHostName:@"www.apple.com"];
        [_hostReachable startNotifier];

    }
    return self;
}

//>
-(BOOL) checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    NetworkStatus internetStatus = [_internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable:
        {
            NSLog(@"The internet is down.");
            self.internetActive = NO;
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            self.internetActive = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            self.internetActive = YES;
            
            break;
        }
    }
    
    NetworkStatus hostStatus = [_hostReachable currentReachabilityStatus];
    switch (hostStatus)
    {
        case NotReachable:
        {
            NSLog(@"A gateway to the host server is down.");
            self.hostActive = NO;
            
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"A gateway to the host server is working via WIFI.");
            self.hostActive = YES;
            
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"A gateway to the host server is working via WWAN.");
            self.hostActive = YES;
            break;
        }
    }
    
    return (self.hostActive || self.internetActive);
}
//<

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
    self.noMoreResultsAvail = NO;
    ///[_resultsTableView setHidden:YES];
    _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _activityIndicator.frame = CGRectMake(_resultsTableView.frame.origin.x,
                                              _resultsTableView.frame.origin.y,
                                              _resultsTableView.frame.size.width,
                                              _resultsTableView.frame.size.height);
    [self.view addSubview:_activityIndicator];
}

//Boiler-plate code didReceiveMemoryWarning. Release memory of your objects here.
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _tweetResultsArray = nil;
    _imageCacheArray = nil;
}

/**
 * UISearchBar delegate method called when search button is tapped
 *
 * @param aSearchBar An instance of UISearchBar.
 * @return void
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *) aSearchBar
{
    //Check for internet connectivity
    if ([self checkNetworkStatus:nil])
    {
        //BLOCK#1
        [AccountManager getTwitterAccount:^(ACAccount *accTwitter){
            
            //BLOCK#2
            dispatch_async(dispatch_get_main_queue(), ^{
                if (accTwitter) {
                    _searchText = _querySearchBar.text;
                    //dismiss the keyboard
                    [_querySearchBar resignFirstResponder];
                    
                    [_activityIndicator startAnimating];
                    
                    // reset data structures and reload table.
                    [_tweetResultsArray removeAllObjects];
                    [_imageCacheArray removeAllObjects];
                    [_searchMetaData removeAllObjects];
                    [_resultsTableView reloadData];
                    
                    //Since this is a fresh search there's no meta data
                    [_httpNetworkModel performTwitterSearch:_searchText withMetaData:nil];
                }
                else {
                    //dismiss the keyboard
                    [_querySearchBar resignFirstResponder];

                    //Show Alert
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Twitter Search"
                                                                        message:@"No Twitter account found on your device. To configure Twitter, select Settings and choose Twitter."
                                                                       delegate:self
                                                              cancelButtonTitle:@"Cancel"
                                                              otherButtonTitles:@"Settings", nil];
                    [alertView show];
                    
                }
            }); //END BLOCK#2
            
        }];//END BLOCK#1
    }
    else {
        //Show Alert
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Twitter Search"
                                                            message:@"No internet connection. This app requires internet to search keywords in Twitter."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];

    }
}

//delegate to handle Yes / No of Alert Message
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"Cancel"]) {
        NSLog(@"Cancel was selected.");
    }
    else if([title isEqualToString:@"Settings"]) {
        NSLog(@"Settings was selected.");
        if(UIApplicationOpenSettingsURLString != nil)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
        
    }
}

#pragma mark - TableView data source
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"In cellForRowAtIndexPath. Populating data for row: %ld",indexPath.row);
    static NSString *cellIdentifier = @"SearchResultCell";
    SearchTableViewCell *cell = (SearchTableViewCell *)[tableView
                                      dequeueReusableCellWithIdentifier:cellIdentifier];
    TweetDataModel *tweet = [self.tweetResultsArray objectAtIndex:indexPath.row];

    if(cell == nil){
        
        cell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.timeLabel.text = [self getDisplayTime:tweet.tweetDate];
    cell.nameLabel.text = tweet.author;
    //prepend @ to the display name
    cell.displayNameLabel.text = [NSString stringWithFormat:@"@%@", tweet.displayName];
    
    CGFloat height = [self heightOfTextViewWithString:tweet.text withFont:[UIFont fontWithName:@"Helvetica" size:13.0]andFixedWidth:250];
    CGRect rect = CGRectMake(cell.tweetTextView.frame.origin.x, cell.tweetTextView.frame.origin.y, cell.tweetTextView.frame.size.width, height);
    cell.tweetTextView.frame = rect;
    NSLog(@"BEFORE cell.tweetTextView.contentSize=%f %f",cell.tweetTextView.contentSize.width, cell.tweetTextView.contentSize.height);
    cell.tweetTextView.contentSize = CGSizeMake(cell.tweetTextView.frame.size.width, cell.tweetTextView.frame.size.height);
    NSLog(@"AFTER cell.tweetTextView.contentSize=%f %f",cell.tweetTextView.contentSize.width, cell.tweetTextView.contentSize.height);
    
    cell.tweetTextView.text = tweet.text;
    
    UIImage *img = [self loadImageFromCache:indexPath];
    if (img) {
        cell.profileImage.image = img;
    }
    else {
        // download only if the tableView is stationary
        if (self.resultsTableView.dragging == NO && self.resultsTableView.decelerating == NO)
        {
            [self getImageData:indexPath forUrl:tweet.profileImageUrl];
        }
        // if a download is in progress, show a default image
        cell.profileImage.image = [UIImage imageNamed:@"Default.png"];        
    }
    
    return cell;
}

- (CGFloat)heightOfTextViewWithString:(NSString *)string
                             withFont:(UIFont *)font
                        andFixedWidth:(CGFloat)fixedWidth
{
    UITextView *tempTV = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, fixedWidth, 1)];
    tempTV.text = [string uppercaseString];
    tempTV.font = font;
    
    CGSize newSize = [tempTV sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = tempTV.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    tempTV.frame = newFrame;
    
    return tempTV.frame.size.height + kCellUITextMargin;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetDataModel *tweet = [self.tweetResultsArray objectAtIndex:indexPath.row];
    CGFloat cellHeight = [self heightOfTextViewWithString:tweet.text withFont:[UIFont fontWithName:@"Helvetica" size:13.0]andFixedWidth:250];
    cellHeight += kCellVerticalMargin;
    return (cellHeight < kCellMinHeight ? kCellMinHeight : cellHeight);;
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

#pragma mark - Image retrieval methods

//Retrieve Image from local imageCache if available
-(UIImage *) loadImageFromCache:(NSIndexPath *)indexPath
{
    //check if we have it in our cache
    if (_imageCacheArray.count > indexPath.row) {
        return [_imageCacheArray objectAtIndex:indexPath.row];
    }
    //else return nil
    else {
        return (nil);
    }
}

//Download image from Url and store to imageCache
-(void) getImageData:(NSIndexPath *)indexPath forUrl:(NSString *)imageUrl
{
    //Fetch image data async on the global thread
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        //NSLog(@"Calling searchTweets with request: %@\nParams:%@",requestURL, parameters);
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:imageData];
        
        //Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [_imageCacheArray addObject:image];
            SearchTableViewCell *cell = (SearchTableViewCell *)[_resultsTableView cellForRowAtIndexPath:indexPath];
            NSLog(@"In getImageData, displaying profileImage for row: %ld",indexPath.row);
            cell.profileImage.image = image;
        });
    });
}

// -------------------------------------------------------------------------------
//	loadImagesForOnscreenRows
//  This method is used in case the user scrolled into a set of cells that don't
//  have their profile images yet.
// -------------------------------------------------------------------------------
- (void)loadImagesForOnscreenRows
{
    if (_imageCacheArray.count > 0) {
        //iterate through visible rows first
        NSArray *visiblePaths = [self.resultsTableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths) {
    
            // Download if it's not in our imageCache
            if (_imageCacheArray.count <= indexPath.row) {
                NSLog(@"In loadImagesForOnscreenRows, getting profileImage for row: %ld",indexPath.row);
                TweetDataModel *tweet = [self.tweetResultsArray objectAtIndex:indexPath.row];
                [self getImageData:indexPath forUrl:tweet.profileImageUrl];
            }
            else {
                SearchTableViewCell *cell = (SearchTableViewCell *)[_resultsTableView cellForRowAtIndexPath:indexPath];
                NSLog(@"In getImageData, displaying profileImage for row: %ld",indexPath.row);
                cell.profileImage.image = [self loadImageFromCache:indexPath];
            }
        }
    }
}

#pragma mark - HttpNetworkModelDelegate
/**
 * HttpNetworkModel delegate method called when search results have been fetched and parsed
 *
 * @param HttpNetworkModel and resultsArray.
 * @return void
 */
-(void) httpNetworkModel:(HttpNetworkModel *)networkModel didFinishLoadingData:(NSArray *) resultsArray withMetaData:(NSDictionary *) searchMetaData
{
    @try {
        if (resultsArray && resultsArray.count) {
            [_activityIndicator stopAnimating];
            [_resultsTableView setHidden:NO];
            _searchMetaData = [searchMetaData mutableCopy];
            [_tweetResultsArray addObjectsFromArray:resultsArray];
            [_resultsTableView reloadData];
        }
        else {
            [_activityIndicator stopAnimating];
            //Show Alert
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Twitter Search"
                                                                message:@"No tweets found. Please try some other keywords."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];

        }
    }
    @catch (NSException *exception) {
        [_activityIndicator stopAnimating];
        NSLog(@"Exception in httpNetworkModel::didFinishLoadingData. Details: %@", exception.description);
    }
}

#pragma mark - UIScrollViewDelegate

// -------------------------------------------------------------------------------
//	scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!self.loading) {
        float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (endScrolling >= scrollView.contentSize.height) {
            //get the next set of tweet results
            [_httpNetworkModel performTwitterSearch:_searchText withMetaData:_searchMetaData];
        }
    }
}

#pragma mark Time parsing method
-(NSString *) getDisplayTime: (NSString *) tweetTime
{
    return tweetTime;
}

@end
