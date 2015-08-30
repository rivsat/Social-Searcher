//
//  SearchTableViewCell.m
//  Social Searcher
//
//  Created by Tasvir H Rohila on 25/08/15.
//  Copyright (c) 2015 Tasvir H Rohila. All rights reserved.
//

#import "SearchTableViewCell.h"

@implementation SearchTableViewCell

@synthesize nameLabel=_nameLabel;
@synthesize tweetTextView=_tweetTextView;
@synthesize profileImage=_profileImage;
@synthesize timeLabel=_timeLabel;

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


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.numberOfLines = 0;
        self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    
    return self;
}


@end
