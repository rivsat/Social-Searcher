//
//  Utility.m
//  Social Searcher
//
//  Created by Tasvir H Rohila on 30/08/15.
//  Copyright (c) 2015 Tasvir H Rohila. All rights reserved.
//

#import "Utility.h"

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

@end
