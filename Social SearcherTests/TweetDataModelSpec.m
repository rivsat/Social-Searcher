//
//  TweetDataModelSpec.m
//  Social Searcher
//
//  Created by Tasvir H Rohila on 30/08/15.
//  Copyright (c) 2015 Tasvir H Rohila. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kiwi.h"
#import "TweetDataModel.h"
#import "Constants.h"

@interface TweetDataModel (Spec)

@end

SPEC_BEGIN(TweetDataModelSpec)

describe(@"TweetDataModel", ^{
    __block TweetDataModel *tweetDataModel, *tweetDataModel1;
    beforeEach(^{
        tweetDataModel = [[TweetDataModel alloc] initWithValues:kTestUserName screenName:kTestDisplayName tweetText:kTestTweetText profileImage:kTestProfileImageUrl creationDate:kTestTweetDate];
    });
    /*
     Test case for didFinishLoadingData
     */
    it(@"Should initialise data model", ^{
        [[tweetDataModel shouldNot] equal:nil];
    }); //END IT#1

    it(@"Should initialise Author Name", ^{
        [[tweetDataModel.author should] equal:kTestUserName];
    }); //END IT#2

    it(@"Should initialise Display Name", ^{
        [[tweetDataModel.displayName should] equal:kTestDisplayName];
    }); //END IT#3
    
    it(@"Should initialise Tweet Text", ^{
        [[tweetDataModel.text should] equal:kTestTweetText];
    }); //END IT#4

    it(@"Should initialise Profile image url", ^{
        [[tweetDataModel.profileImageUrl should] equal:kTestProfileImageUrl];
    }); //END IT#4

    it(@"Should initialise Tweet Date-time", ^{
        [[tweetDataModel.tweetDate should] equal:kTestTweetDate];
    }); //END IT#4

}); //END DESCRIBE
SPEC_END
