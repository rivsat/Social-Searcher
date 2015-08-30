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
 * Initialize the tweetDataModel object
 *
 * @param name User name
 * @param screenName display name
 * @param tweetText text of the tweet
 * @param profileImage Url of the profileImage
 * @param creationDate Date & time this tweet was posted
 * @return TweetDataModel instance of TweetDataModel
 */
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
