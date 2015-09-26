//
//  Utility.m
//  Social Searcher
//
//  Created by Tasvir H Rohila on 30/08/15.
//  Copyright (c) 2015 Tasvir H Rohila. All rights reserved.
//

#import "Utility.h"
#import "Constants.h"

@implementation Utility

#pragma mark Time parsing method

//Convert Twitter provided time of format "Sat Aug 29 06:42:56 +0000 2015" to local time
+(NSString *) getDisplayTime: (NSString *) tweetTime
{
    //Sat Aug 29 06:42:56 +0000 2015
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //Wed Dec 01 17:08:03 +0000 2010
    [df setDateFormat:@"eee MMM dd HH:mm:ss ZZZZ yyyy"];
    NSDate *date = [df dateFromString:tweetTime];
    [df setDateFormat:@"eee MMM dd yyyy HH:mm"];
    NSString *dateString = [df stringFromDate:date];
    return dateString;
}

/**
 * Performs a URL encoding of the query
 *
 * @param inputString The query string to be encoded
 * @return URL encoded string
 */
+(NSString *)encodeQuery:(NSString *)inputString
{
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

/**
 * Constructs Twitter search query as per set filters
 *
 * @param strKeyWords The search keywords
 * @param filterSetting Boolean to suggest if filter is ON or OFF
 * @param startDate The sent since date
 * @param endDate The sent before date
 * @return well formed query
 */
+(NSString *) constructSearchQuery: (NSString *) strKeyWords filterSetting :(BOOL) isFilterON startDate: (NSString *) strStartDate endDate: (NSString *) strEndDate
{
    
    NSMutableString *strSearchQuery = [[NSMutableString alloc] initWithString:kQueryStringFormat];
    [strSearchQuery replaceOccurrencesOfString:kQueryKeyWord withString:strKeyWords options:NSLiteralSearch range:NSMakeRange(0, strSearchQuery.length)];
    
    if (isFilterON) {
        //Since date
        NSString *start = (strStartDate.length ? [[NSString alloc] initWithFormat:@"%@%@", kQuerySinceValue, strStartDate] : @"");
        [strSearchQuery replaceOccurrencesOfString:kQuerySince withString:start options:NSLiteralSearch range:NSMakeRange(0, strSearchQuery.length)];
        
        
        //Until date
        NSString *end = (strEndDate.length ? [[NSString alloc] initWithFormat:@"%@%@", kQueryUntilValue, strEndDate] : @"");
        [strSearchQuery replaceOccurrencesOfString:kQueryUntil withString:end options:NSLiteralSearch range:NSMakeRange(0, strSearchQuery.length)];

    }
    //if there is no filter then just use the search keywords
    else {
        strSearchQuery = [strKeyWords mutableCopy];
    }
    
    return strSearchQuery;
}

@end
