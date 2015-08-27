//
//  TweetDataModel.h
//  Social Searcher
//
//  Created by Tasvir H Rohila on 25/08/15.
//  Copyright (c) 2015 Tasvir H Rohila. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TweetDataModel : NSObject

@property (nonatomic, copy) NSString *author;
@property (nonatomic, copy) NSString *displayName;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *profileImageUrl;
@property (nonatomic, copy) NSString *tweetDate;

-(TweetDataModel *) initWithValues: (NSString *) name screenName:(NSString *) displayName tweetText:(NSString *) text profileImage:(NSString *) imageUrl creationDate:(NSString *) tweetDate;
@end
