//
//  TweetCell.m
//  Twitter
//
//  Created by Ken Szubzda on 2/21/15.
//  Copyright (c) 2015 Ken Szubzda. All rights reserved.
//

#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"

@interface TweetCell ()
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetsCount;
@property (weak, nonatomic) IBOutlet UILabel *favoritesCount;

@end

@implementation TweetCell

- (void)awakeFromNib {
    // Initialization code
    
    // round the corners of the thumbnail
    self.thumbImageView.layer.cornerRadius = 3;
    self.thumbImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
    User *user = tweet.user;
    [self.thumbImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    self.nameLabel.text = user.name;
    self.handleLabel.text = [NSString stringWithFormat:@"@%@", user.screenName];
    self.tweetLabel.text = tweet.text;
    
    if (tweet.retweetsCount > 0) {
        self.retweetsCount.text = [@(tweet.retweetsCount) stringValue];
    } else {
        self.retweetsCount.text = @"";
    }
    if (tweet.favoritesCount > 0) {
        self.favoritesCount.text = [@(tweet.favoritesCount) stringValue];
    } else {
        self.favoritesCount.text = @"";
    }
    
    NSDate *timeAgoDate = [NSDate dateWithTimeIntervalSinceNow:tweet.createdAt.timeIntervalSinceNow];
    self.timestampLabel.text = timeAgoDate.shortTimeAgoSinceNow;
}

- (IBAction)onRetweet:(id)sender {
    
}

- (IBAction)onFavorite:(id)sender {
    
}

@end
