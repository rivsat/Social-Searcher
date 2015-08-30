//
//  HttpNetworkClient.h
//  Social Searcher
//
//  Created by Tasvir H Rohila on 25/08/15.
//  Copyright (c) 2015 Tasvir H Rohila. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TweetDataModel.h"

@class HttpNetworkModel;

@protocol HttpNetworkModelDelegate <NSObject>

-(void) httpNetworkModel:(HttpNetworkModel *)networkModel didFinishLoadingData: (NSArray *) resultsArray withMetaData:(NSDictionary *) searchMetaData;
-(void) didReceiveImageData:(NSData *)imageData forRow:(NSIndexPath *)indexPath;

@end

@interface HttpNetworkModel : NSObject

@property (nonatomic, retain) id <HttpNetworkModelDelegate> delegate;

-(void) performTwitterSearch:(NSString *) searchText withMetaData:(NSDictionary *) searchMetaData;
-(void) getImageData:(NSIndexPath *)indexPath forUrl:(NSString *)imageUrl;

@end
