//
//  SearchTableViewCell.h
//  Social Searcher
//
//  Created by Tasvir H Rohila on 25/08/15.
//  Copyright (c) 2015 Tasvir H Rohila. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell

//UIImageView
@property (nonatomic, weak) IBOutlet UIImageView* profileImage;
//User name
@property (nonatomic, weak) IBOutlet UILabel* nameLabel;
//Display Name
@property (nonatomic, weak) IBOutlet UILabel* displayNameLabel;
//Tweet Text
@property (nonatomic, weak) IBOutlet UITextView* tweetTextView;



@end
