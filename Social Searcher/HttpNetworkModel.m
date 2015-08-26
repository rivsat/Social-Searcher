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
-(void) performTwitterSearch:(NSString *) searchText
{
    @try {
        [self searchTweets:searchText];
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
 */- (void)searchTweets: (NSString *) searchText
{
    @try {
        ACAccountStore *account = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [account
                                      accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        [account requestAccessToAccountsWithType:accountType
                                         options:nil completion:^(BOOL granted, NSError *error)
         {
             if (granted == YES)
             {
                 NSArray *arrayOfAccounts = [account
                                             accountsWithAccountType:accountType];
                 
                 if ([arrayOfAccounts count] > 0)
                 {
                     ACAccount *twitterAccount = [arrayOfAccounts lastObject];
                     
                     NSURL *requestURL = [NSURL URLWithString:kUrlSearchTweets];
                     
                     NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
                     [parameters setObject:kCountMaxTweetResults forKey:@"count"];
                     [parameters setObject:kBoolIncludeEntities forKey:@"include_entities"];
                     [parameters setValue:kResultType forKey:@"result_type"];
                     [parameters setValue:searchText forKey:@"q"];
                     
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
             } else {
                 // Handle failure to get account access
             }
         }];
    }
    
    @catch (NSException *exception) {
        NSLog(@"Exception in HttpNetworkModel::performTwitterSearch . Details: %@",exception.description);
        //parse the search results and populate the tweet data model
        dispatch_async(dispatch_get_main_queue(), ^{
            [self populateTweetDataModel:@{}];
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
    @try     {
        if (tweetData.count) {
            
        }
    }

    @catch (NSException *exception) {
        NSLog(@"Exception in HttpNetworkModel::populateTweetDataModel . Details: %@",exception.description);
    }
    [self.delegate httpNetworkModel:self didFinishLoadingData:[resutsArray mutableCopy]];
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
