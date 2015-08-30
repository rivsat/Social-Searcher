//
//  Constants.h
//  Social Searcher
//
//  Created by Tasvir H Rohila on 26/08/15.
//  Copyright (c) 2015 Tasvir H Rohila. All rights reserved.
//

#import <Foundation/Foundation.h>

//
// URL constants
//

static NSString * const kUrlSearchTweets = @"https://api.twitter.com/1.1/search/tweets.json";
static NSString * const kCountMaxTweetResults = @"10";
static NSString * const kBoolIncludeEntities = @"1";
static NSString * const kResultType = @"mixed";

static float const kCellVerticalMargin = 10.0;
static float const kCellMinHeight = 70.0;
static float const kCellUITextMargin = 20.0;
static int const kCellTextLengthCheck = 80;

//String constants used for BDD Test cases
static NSString * const kTestUserName = @"Sachin Tendulkar";
static NSString * const kTestDisplayName = @"sachin_rt";
static NSString * const kTestDisplayNameTwitterFormat = @"@sachin_rt";
static NSString * const kTestTweetText = @"Priviledged to have played for India.";
static NSString * const kTestProfileImageUrl = @"http://pbs.twimg.com/profile_images/378800000274891563/95fad139059409f2455c371aa9992557_normal.png";
static NSString * const kTestTweetDate = @"Sat Aug 29 06:42:56 +0000 2015";
