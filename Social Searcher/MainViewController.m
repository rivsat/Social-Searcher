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
    //TODO: Async this operation
    ////cell.profileImage.image = [self getImageData:indexPath forUrl:tweet.profileImageUrl];
    
    return cell;
}

/*TODO
 NSString *imageUrl = @"http://www.foo.com/myImage.jpg";
 [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
 myImageView.image = [UIImage imageWithData:data];
 }];
 */

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

//Image caching mechanism
-(UIImage *) getImageData:(NSIndexPath *)indexPath forUrl:(NSString *) imageUrl
{
    //check if we have it in our cache
    if (_imageCacheArray.count > indexPath.row) {
        return [_imageCacheArray objectAtIndex:indexPath.row];
    }
    //else fetch it from the Url
    else {
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:imageData];
        [_imageCacheArray addObject:image];
        return (image);
    }
}

#pragma mark - TableView delegates

#pragma mark HttpNetworkModelDelegate
/**
 * HttpNetworkModel delegate method called when search results have been fetched and parsed
 *
 * @param HttpNetworkModel and resultsArray.
 * @return void
 */
-(void) httpNetworkModel:(HttpNetworkModel *)networkModel didFinishLoadingData:(NSArray *) resultsArray withMetaData:(NSDictionary *) searchMetaData
{
    @try {
        if (resultsArray && resultsArray.count)
        {
            _searchMetaData = [searchMetaData mutableCopy];
            [_tweetResultsArray addObjectsFromArray:resultsArray];
            [_resultsTableView reloadData];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in httpNetworkModel::didFinishLoadingData. Details: %@", exception.description);
    }
}

#pragma UIScrollView Method::
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (!self.loading) {
        float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (endScrolling >= scrollView.contentSize.height)
        {
            //get the next set of tweet results
            [_httpNetworkModel performTwitterSearch:_searchText withMetaData:_searchMetaData];
        }
    }
}


@end
