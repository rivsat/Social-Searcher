//
//  HttpNetworkModelSpec.m
//  Social Searcher
//
//  Created by Tasvir H Rohila on 30/08/15.
//  Copyright (c) 2015 Tasvir H Rohila. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kiwi.h"
#import "HttpNetworkModel.h"
#import "Constants.h"
#import "Mainviewcontroller.h"

@interface HttpNetworkModel (Spec)

@end

SPEC_BEGIN(HttpNetworkModelSpec)

//-(void) performTwitterSearch:(NSString *) searchText withMetaData:(NSDictionary *) searchMetaData;

describe(@"Specs for HttpNetworkModel", ^{
    
    __block HttpNetworkModel *httpNetworkModelClient= [[HttpNetworkModel alloc] init];
    __block TweetDataModel *tweetDataModel, *tweetDataModel1;
    __block NSMutableArray *tweetResultArray = [[NSMutableArray alloc] init];
    __block NSDictionary * searchMetaData;
    beforeEach(^{
        //Prepare the expected data structures
        tweetDataModel = [[TweetDataModel alloc] initWithValues:kTestUserName screenName:kTestDisplayName tweetText:kTestTweetText profileImage:kTestProfileImageUrl creationDate:kTestTweetDate];
        tweetDataModel1 = [[TweetDataModel alloc] initWithValues:@"Tasvir Rohila" screenName:@"rivsat" tweetText:@"Test Driving Development using Kiwi as the mockup framework." profileImage:kTestProfileImageUrl creationDate:@"Wed Aug 26 08:42:56 +0000 2015"];
        
        [tweetResultArray removeAllObjects];
        [tweetResultArray addObject:tweetDataModel];
        [tweetResultArray addObject:tweetDataModel1];

    });
    /*
     Test case for didFinishLoadingData

    it(@"Should receive search results for provided keywords", ^{
        
        // Create a mock object to act as the httpNetworkModel delegate, and make it 'conform' to
        // the httpNetworkModelDelegate protocol
        id delegateMock = [KWMock mockForProtocol:@protocol(HttpNetworkModelDelegate)];
        [httpNetworkModelClient setDelegate:delegateMock];

        // Set the assertion that eventually there should an 'didFinishLoadingData' message,
        // and it will have the tweetResultArray & metaData(nil) as parameters
        [[[HttpNetworkModelSpec shouldEventually] receive] httpNetworkModel:httpNetworkModelClient didFinishLoadingData:[tweetResultArray mutableCopy] withMetaData:nil];

        [httpNetworkModelClient performTwitterSearch:@"Sachin" withMetaData:nil];
        
    }); //END IT#1
         */
    it(@"Should receive search results for provided keywords", ^{
        
        NSDictionary * tweetData = [[NSDictionary alloc] init];
        // Create a mock object to act as the httpNetworkModel delegate, and make it 'conform' to
        // the httpNetworkModelDelegate protocol
        id mockClass = [KWMock mockForClass:[HttpNetworkModel class]];
        
        id httpMock = [HttpNetworkModel class];
        [httpMock stub:@selector(populateTweetDataModel:) withArguments:tweetData];
        
        [[[HttpNetworkModel class] shouldEventually] receive:@selector(populateTweetDataModel:) withArguments:tweetData];
        // Set the assertion that eventually there should an 'didFinishLoadingData' message,
        // and it will have the tweetResultArray & metaData(nil) as parameters
        
        [httpNetworkModelClient performTwitterSearch:@"Sachin" withMetaData:nil];
        
    }); //END IT#1
}); //END DESCRIBE

SPEC_END
