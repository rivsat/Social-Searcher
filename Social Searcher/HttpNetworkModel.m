//
//  HttpNetworkClient.m
//  Social Searcher
//
//  Created by Tasvir H Rohila on 25/08/15.
//  Copyright (c) 2015 Tasvir H Rohila. All rights reserved.
//

#import "HttpNetworkModel.h"
#import "Social/Social.h"
#import <Accounts/Accounts.h>
#import "AccountManager.h"

#import "Constants.h"

@implementation HttpNetworkModel
@synthesize delegate;

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

/**
 * Calls [self searchTweets:searchText]; to performs a keywords / hashtag search on Twitter
 *
 * @param searchText The keywords to be searched
 * @return internally does a callback to delegate didFinishLoadingData.
 */
-(void) performTwitterSearch:(NSString *) searchText withMetaData:(NSDictionary *) searchMetaData
{
    @try {
        //#1 Get Twitter account
        //__block ACAccount *twitterAccount = [[ACAccount alloc] init];
        //BLOCK#1
        [AccountManager getTwitterAccount:^(ACAccount *accTwitter){

            NSString *nextResultsUrl = [[NSString alloc] init];
            
            if (accTwitter)
            {
                NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                
                //check if its a repeat search for next page
                if (searchMetaData)
                {
                    nextResultsUrl =  searchMetaData[@"next_results"];
                    /*
                     nextResultsUrl = [nextResultsUrl stringByReplacingOccurrencesOfString:@"?" withString:@""];
                     NSArray *components = [nextResultsUrl componentsSeparatedByString:@"&"];
                     for (NSString *parts in components) {
                     
                     }*/
                }
                else
                {
                    [parameters setObject:kCountMaxTweetResults forKey:@"count"];
                    [parameters setObject:kBoolIncludeEntities forKey:@"include_entities"];
                    [parameters setValue:kResultType forKey:@"result_type"];
                    [parameters setValue:searchText forKey:@"q"];
                }
                
                //append next search URL if it exists
                NSString *finalUrl = [NSString stringWithFormat:@"%@%@", kUrlSearchTweets, nextResultsUrl];
                NSURL *requestURL = [NSURL URLWithString: finalUrl];
                
                //Use GCD to perform async searchTweets task
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                    NSLog(@"Calling searchTweets with request: %@\nParams:%@",requestURL, parameters);
                    [self searchTweets:requestURL requestParameters:parameters forAccount:accTwitter];
                });
                
            }
            else {
                //Twitter a/c not setup on iPhone
                
            }

        }];//END BLOCK#1
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in HttpNetworkModel::performTwitterSearch . Details: %@",exception.description);
    }
}

/**
 * Performs a keywords / hashtag search on Twitter
 * (fetches max kMaxResultCount so as to enable pagination)
 * (Calls [self populateTweetDataModel:tweetData]; to populate data structure.
 * @param searchText The keywords to be searched
 * @return does a callback to delegate didFinishLoadingData.
 */
- (void)searchTweets: (NSURL*) requestURL requestParameters: (NSDictionary *) parameters forAccount: (ACAccount *) twitterAccount
{
    @try {
        SLRequest *postRequest = [SLRequest
                                  requestForServiceType:SLServiceTypeTwitter
                                  requestMethod:SLRequestMethodGET
                                  URL:requestURL parameters:parameters];
        
        postRequest.account = twitterAccount;
        
        [postRequest performRequestWithHandler:
         ^(NSData *responseData, NSHTTPURLResponse
           *urlResponse, NSError *error)
         {
             NSDictionary *tweetData = [NSJSONSerialization
                                        JSONObjectWithData:responseData
                                        options:NSJSONReadingMutableLeaves
                                        error:&error];
             
             //parse the search results and populate the tweet data model
             dispatch_async(dispatch_get_main_queue(), ^{
                 NSLog(@"Tweet Search Results: %@",tweetData);
                 [self populateTweetDataModel:tweetData];
             });
         }];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in HttpNetworkModel::searchTweets . Details: %@",exception.description);
        //parse the search results and populate the tweet data model
        dispatch_async(dispatch_get_main_queue(), ^{
            [self populateTweetDataModel:nil];
        });
    }
}

/**
 * Parses the search results tweetData and populates TweetDataModel objects in an array
 *
 * @param tweetData NSDictionary of search results
 * @return does a callback to delegate didFinishLoadingData.
 */
-(void) populateTweetDataModel: (NSDictionary *) tweetData
{
    NSMutableArray *resutsArray = [[NSMutableArray alloc] init];
    NSDictionary *metaData = [NSDictionary alloc];
    NSArray *tweetArray = [[NSArray alloc] init];
    //NSMutableDictionary *tweet = [NSMutableDictionary alloc];
    @try     {
        if (tweetData && tweetData.count) {
            for ( NSString *key in tweetData) {
                if ([key isEqualToString:@"search_metadata"])
                {
                    metaData = tweetData[key];
                }
                else {
                    tweetArray = tweetData[key];
                    for (NSDictionary *tweet in tweetArray) {
                        NSLog(@"*******************************************************************");
                        NSLog(@"Tweet Data. Date:%@\nName: %@\nScreen Name: @%@\nText:%@\nProfile Img:%@", tweet[@"created_at"], tweet[@"user"][@"name"], tweet[@"user"][@"screen_name"], tweet[@"text"], tweet[@"user"][@"profile_image_url"]);
                        
                        TweetDataModel *dataModel = [[TweetDataModel alloc] initWithValues:tweet[@"user"][@"name"] screenName:tweet[@"user"][@"screen_name"] tweetText:tweet[@"text"] profileImage:tweet[@"user"][@"profile_image_url"] creationDate:tweet[@"created_at"]];
                        
                        //keep stuffing in resultsArray
                        [resutsArray addObject:dataModel];
                    }
                }
            }
        }
    }

    @catch (NSException *exception) {
        NSLog(@"Exception in HttpNetworkModel::populateTweetDataModel . Details: %@",exception.description);
    }
    [self.delegate httpNetworkModel:self didFinishLoadingData:[resutsArray mutableCopy] withMetaData:metaData];
}

/**
 * Performs a URL encoding of the query
 *
 * @param inputString The query string to be encoded
 * @return URL encoded string
 */
- (NSString *)encodeQuery:(NSString *)inputString {
    @try {
        return [inputString
                stringByAddingPercentEscapesUsingEncoding:
                NSUTF8StringEncoding];
        
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in HttpNetworkModel::encodeQuery . Details: %@",exception.description);
        return inputString;
    }
}


@end
