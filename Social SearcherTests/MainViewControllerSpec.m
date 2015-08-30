//
//  MainViewControllerSpec.m
//  Social Searcher
//
//  Created by Tasvir H Rohila on 29/08/15.
//  Copyright (c) 2015 Tasvir H Rohila. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kiwi.h"
#import "MainViewController.h"
#import "TweetDataModel.h"
#import "SearchTableViewCell.h"
#import "Constants.h"

@interface MainViewController (Spec)

@property (weak, nonatomic) IBOutlet UINavigationBar *mainNavigationBar;
@property (weak, nonatomic) IBOutlet UISearchBar *querySearchBar;
@property (weak, nonatomic) IBOutlet UITableView *resultsTableView;

@property (nonatomic, strong) HttpNetworkModel *httpNetworkModel;
@property (nonatomic, strong) NSMutableArray *tweetResultsArray;
@property (nonatomic, strong) NSMutableArray *imageCacheArray;

//TweetDataModel
@end

SPEC_BEGIN(MainViewControllerSpec)

describe(@"MainViewController", ^{
    __block MainViewController *viewController;
    __block TweetDataModel *tweetDataModel, *tweetDataModel1;
    __block NSMutableArray *tweetResultArray = [[NSMutableArray alloc] init];
    beforeEach(^{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        
        [viewController view];
        
        viewController.querySearchBar.text = @"sachin";
        tweetDataModel = [[TweetDataModel alloc] initWithValues:kTestUserName screenName:kTestDisplayName tweetText:kTestTweetText profileImage:kTestProfileImageUrl creationDate:kTestTweetDate];
        tweetDataModel1 = [[TweetDataModel alloc] initWithValues:@"Tasvir Rohila" screenName:@"rivsat" tweetText:@"Test Driving Development using Kiwi as the mockup framework." profileImage:kTestProfileImageUrl creationDate:@"Sat Aug 26 08:42:56 +0000 2015"];
        [tweetResultArray removeAllObjects];
        [tweetResultArray addObject:tweetDataModel];
        [tweetResultArray addObject:tweetDataModel1];
        
    });
    it(@"is pretty cool", ^{
        NSLog(@"=================In its pretty cool==================");
        NSUInteger a = 16;
        NSUInteger b = 26;
        [[theValue(a + b) should] equal:theValue(42)];
    });
    /*
    //IT#1
    it(@"should display tweet time after performing search", ^{
        NSLog(@"IT#1 ENTER####################################################");
        [viewController stub:@selector(searchBarSearchButtonClicked:) withBlock:^id(NSArray *params) {
            void (^completion)(NSArray *responseData, NSError *error) = params[1];
            
            completion(@[tweetDataModel],nil);
            
            [viewController httpNetworkModel:nil didFinishLoadingData:@[tweetDataModel] withMetaData:nil];
            
            SearchTableViewCell *cell =(SearchTableViewCell *) [viewController.resultsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            //Time @"eee MMM dd yyyy HH:mm"
            NSString *tweetTime = cell.timeLabel.text;
            NSLog(@"In IT#1. cell.timeLabel.text=%@",tweetTime);
            NSLog(@"####################################################");
            [[tweetTime should] equal:@"Sat Aug 29 2015 16:42"];
            return nil;
        }];
    }); //END IT#1
     */
    /*
     Test case for didFinishLoadingData
     */
    //IT#1
    it(@"should display tweet time after performing search ver2", ^{
        NSLog(@"IT#1 ENTER>>>>>>>>>>>>>>>>>>>>>>>>");
        [viewController httpNetworkModel:nil didFinishLoadingData:@[tweetDataModel] withMetaData:nil];
        
        SearchTableViewCell *cell =(SearchTableViewCell *) [viewController.resultsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        //Time @"eee MMM dd yyyy HH:mm"
        NSString *tweetTime = cell.timeLabel.text;
        NSLog(@"In IT#1. cell.timeLabel.text=%@",tweetTime);
        [[tweetTime should] equal:@"Sat Aug 29 2015 16:42"];
        NSLog(@"<<<<<<<<<<<<<<<<<<<<<<<<<<<<<IT#1 EXIT");

    }); //END IT#1
    
    //IT#2
    it(@"should display User Name after performing search", ^{
        [viewController httpNetworkModel:nil didFinishLoadingData:@[tweetDataModel] withMetaData:nil];
        
        SearchTableViewCell *cell =(SearchTableViewCell *) [viewController.resultsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        //Name
        [[cell.nameLabel.text should] equal:kTestUserName];
    }); //END IT#2
    
    //IT#3
    it(@"should display twitter Screen name after performing search", ^{
        [viewController httpNetworkModel:nil didFinishLoadingData:@[tweetDataModel,tweetDataModel1] withMetaData:nil];
        
        SearchTableViewCell *cell =(SearchTableViewCell *) [viewController.resultsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        //Screen name
        [[cell.displayNameLabel.text should] equal:kTestDisplayNameTwitterFormat];
    }); //END IT#3
    
    //IT#4
    it(@"should display tweet text after performing search", ^{
        [viewController httpNetworkModel:nil didFinishLoadingData:@[tweetDataModel,tweetDataModel1] withMetaData:nil];
        
        SearchTableViewCell *cell =(SearchTableViewCell *) [viewController.resultsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        //Text
        [[cell.tweetTextView.text should] equal:kTestTweetText];
    }); //END IT#4
    //IT#5
    it(@"should display profile image after performing search", ^{
        [viewController httpNetworkModel:nil didFinishLoadingData:@[tweetDataModel] withMetaData:nil];
        
        SearchTableViewCell *cell =(SearchTableViewCell *) [viewController.resultsTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        //Image URL
        [[cell.profileImage shouldNot] equal:nil];
    }); //END IT#5
    
    //IT#6
    it(@"should have two objects in Results array", ^{
        [viewController httpNetworkModel:nil didFinishLoadingData:@[tweetDataModel, tweetDataModel1] withMetaData:nil];
        //Since we've added 2 tweetDataModel objects, tweetResultsArray should have 2 objects
        [[theValue([viewController.tweetResultsArray count]) should] equal:theValue(2)];
    }); //END IT#6
    

}); //END DESCRIBE
SPEC_END
