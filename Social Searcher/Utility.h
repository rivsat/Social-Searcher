//
//  Utility.h
//  Social Searcher
//
//  Created by Tasvir H Rohila on 30/08/15.
//  Copyright (c) 2015 Tasvir H Rohila. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+(NSString *) getDisplayTime: (NSString *) tweetTime;
+(NSString *)encodeQuery:(NSString *)inputString;

@end
