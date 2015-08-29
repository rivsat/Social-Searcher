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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.textLabel.numberOfLines = 0;
        self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.tweetTextView sizeToFit]; //added
        [self.tweetTextView layoutIfNeeded]; //added

    }
    
    return self;
}

+ (CGFloat)heightForTweet:(TweetDataModel *)tweet {
    //create a dummy cell
    SearchTableViewCell *sampleCell = [[SearchTableViewCell alloc] init];
    sampleCell.nameLabel.text = tweet.author;
    sampleCell.tweetTextView.text = tweet.text;
    sampleCell.profileImage.image = [UIImage
                               imageNamed:@"Default.png"];

    
    //force a layout so we can get some calculated label frames
    [sampleCell setNeedsLayout];
    [sampleCell layoutSubviews];

    //calculate the sizes of the text labels
    CGSize fromUserSize = [tweet.author sizeWithFont:
                           [SearchTableViewCell getFontType]
                                   constrainedToSize:sampleCell.nameLabel.frame.size
                                       lineBreakMode:NSLineBreakByTruncatingTail];
    
    CGSize textSize = [tweet.text sizeWithFont: [SearchTableViewCell
                                                 getFontType]
                             constrainedToSize:sampleCell.tweetTextView.frame.size
                                 lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat minHeight = 100; //image height + margin
    return (CGFloat)MAX(fromUserSize.height + textSize.height + 20,
               minHeight);
}

+(UIFont *) getFontType
{
    return [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
}

- (void)updateForTweet:(TweetDataModel *)tweet {
    self.nameLabel.text = tweet.author;
    self.tweetTextView.text = tweet.text;
    self.profileImage.image = [UIImage
                            imageNamed:@"Default.png"];
}

@end
