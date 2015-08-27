//
//  TweetDataModel.m
//  Social Searcher
//
//  Created by Tasvir H Rohila on 25/08/15.
//  Copyright (c) 2015 Tasvir H Rohila. All rights reserved.
//

#import "TweetDataModel.h"

@implementation TweetDataModel

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

-(TweetDataModel *) initWithValues: (NSString *) name screenName:(NSString *) displayName tweetText:(NSString *) text profileImage:(NSString *) imageUrl creationDate:(NSString *) tweetDate
{
    self = [super init];
    if (self)
    {
        self.author = name;
        self.displayName = displayName;
        self.text = text;
        self.profileImageUrl = imageUrl;
        self.tweetDate = tweetDate;
    }
    return self;
}
@end
