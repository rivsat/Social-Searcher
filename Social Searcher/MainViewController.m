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
@property (weak, nonatomic) IBOutlet UINavigationBar *mainNavigationBar;
@property (weak, nonatomic) IBOutlet UISearchBar *querySearchBar;
@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;

@property (nonatomic, strong) NSMutableArray *tweetResultsArray;

@end

@implementation MainViewController

-(id) initWithCoder:(NSCoder *)aDecoder
{
    //We should give it a default value. The initWithCoder method is a good place for that.
    if ((self = [super initWithCoder:aDecoder]))
    {
        NSLog(@"initWithCoder MainViewController");
        _tweetResultsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"dealloc MainViewController");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
-(void) httpNetworkModel:(HttpNetworkModel *)networkModel didFinishLoadingData:(NSArray *) resultsArray
{
    @try {
        if (resultsArray)
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
