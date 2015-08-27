//
//  AccountManager.h
//  Social Searcher
//
//  Created by Tasvir H Rohila on 26/08/15.
//  Copyright (c) 2015 Tasvir H Rohila. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>

@interface AccountManager : NSObject

+(void) getTwitterAccount:(void (^)(ACAccount *accTwitter))completionHandler;

@end
