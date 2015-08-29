//
//  AccountManager.m
//  Social Searcher
//
//  Created by Tasvir H Rohila on 26/08/15.
//  Copyright (c) 2015 Tasvir H Rohila. All rights reserved.
//

#import "AccountManager.h"

@implementation AccountManager

+(void) getTwitterAccount:(void (^)(ACAccount *accTwitter))completionHandler
{
    __block ACAccount *twitterAccount = [[ACAccount alloc] init];
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
                     twitterAccount = [arrayOfAccounts lastObject];
                     twitterAccount.accountType = accountType; //Twitter
                     completionHandler(twitterAccount);
                 }
                 else {
                     //No Twitter a/c found. So need to setup one here
                     // Handle failure to get account access
                     completionHandler(nil);
                 }
             }
             else {
                 //No Twitter a/c found. So need to setup one here
                 // Handle failure to get account access
                 completionHandler(nil);
             }
         }];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in AccountManager::getTwitterAccount . Details: %@",exception.description);
    }
}

+(ACAccount *) getTwitterAccountVer1
{
    __block ACAccount *twitterAccount = [[ACAccount alloc] init];
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
                     twitterAccount = [arrayOfAccounts lastObject];
                     twitterAccount.accountType = accountType; //Twitter
                 }
             } else {
                 // Handle failure to get account access
             }
         }];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in AccountManager::getTwitterAccount . Details: %@",exception.description);
        return nil;
    }
    return twitterAccount;
}


@end
