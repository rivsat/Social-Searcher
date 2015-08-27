//
//  SearchTableViewCell.m
//  Social Searcher
//
//  Created by Tasvir H Rohila on 25/08/15.
//  Copyright (c) 2015 Tasvir H Rohila. All rights reserved.
//

#import "SearchTableViewCell.h"
#define kBorderWidth 1.0
#define kCornerRadius 8.0

@implementation SearchTableViewCell


- (void)awakeFromNib {
    // Initialization code
    CALayer *borderLayer = [CALayer layer];
    CGRect borderFrame = CGRectMake(0, 0, (_profileImage.frame.size.width), (_profileImage.frame.size.height));
    [borderLayer setBackgroundColor:[[UIColor clearColor] CGColor]];
    [borderLayer setFrame:borderFrame];
    [borderLayer setCornerRadius:kCornerRadius];
    [borderLayer setBorderWidth:kBorderWidth];
    [borderLayer setBorderColor:[[UIColor grayColor] CGColor]];
    [_profileImage.layer addSublayer:borderLayer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
