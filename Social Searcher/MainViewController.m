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

@interface MainViewController ()

@property (nonatomic, strong) HttpNetworkModel *httpNetworkModel;
@property (nonatomic, strong) NSMutableArray *tweetResultsArray;
@property (nonatomic, strong) NSMutableArray *imageCacheArray;
@property (nonatomic) BOOL noMoreResultsAvail;
@property (nonatomic) BOOL loading;
@property (nonatomic, strong) NSString *searchText;
@property (nonatomic, strong) NSMutableDictionary *searchMetaData;


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
    self.noMoreResultsAvail = NO;
    [_resultsTableView setHidden:YES];
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
- (void)searchBarSearchButtonClicked:(UISearchBar *) aSearchBar {
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
    
    cell.nameLabel.text = tweet.author;
    //prepend @ to the display name
    cell.displayNameLabel.text = [NSString stringWithFormat:@"@%@", tweet.displayName];
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
   TweetDataModel *tweet = [self.tweetResultsArray objectAtIndex:indexPath.row];
    return [SearchTableViewCell heightForTweet:tweet];
     */
     static SearchTableViewCell *sizingCell;
     static NSString *cellIdentifier = @"SearchResultCell";
     static dispatch_once_t onceToken;
     // 1
     dispatch_once(&onceToken, ^{
     sizingCell = [[SearchTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
     });
     
     // 2
    TweetDataModel *tweet = [self.tweetResultsArray objectAtIndex:indexPath.row];
    
     // 3
     CGFloat (^calcCellHeight)(SearchTableViewCell *, NSString *) = ^ CGFloat(SearchTableViewCell *sizingCell, NSString *labelText){
     
     sizingCell.tweetTextView.text = labelText;
     
     return [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
     };    
     
     // 4
     CGFloat cellHeight = calcCellHeight(sizingCell, tweet.text);
    cellHeight += 30; //top & bottom margins
    
    CGFloat kMinCellHeight = (float)100;
     // 5
     return (cellHeight < kMinCellHeight ? kMinCellHeight : cellHeight);
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
        [_imageCacheArray addObject:image];
        
        //Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
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



@end
