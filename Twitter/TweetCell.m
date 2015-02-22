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
#import "TwitterClient.h"

@interface TweetCell ()
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetLabel;
@property (weak, nonatomic) IBOutlet UILabel *retweetsCount;
@property (weak, nonatomic) IBOutlet UILabel *favoritesCount;

@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoritesButton;
@end

@implementation TweetCell

- (void)awakeFromNib {
    // Initialization code
    
    // round the corners of the thumbnail
    self.thumbImageView.layer.cornerRadius = 3;
    self.thumbImageView.clipsToBounds = YES;
    
    [self.favoritesButton setImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateSelected];
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateSelected];
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
    
    [self setRetweetsNumber];
    self.retweetButton.selected = tweet.retweeted;
    
    [self setFavoritesNumber];
    self.favoritesButton.selected = tweet.favorited;
    
    NSDate *timeAgoDate = [NSDate dateWithTimeIntervalSinceNow:tweet.createdAt.timeIntervalSinceNow];
    self.timestampLabel.text = timeAgoDate.shortTimeAgoSinceNow;
}

- (IBAction)onRetweet:(id)sender {
    if (self.tweet.retweeted) {
        NSLog(@"send unretweet request");
        self.tweet.retweeted = NO;
        self.retweetButton.selected = NO;
        self.tweet.retweetsCount -= 1;
        [[TwitterClient sharedInstance] unRetweetTweet:self.tweet.retweetId completion:^(NSError *error) {
            if (error != nil) {
                NSLog(@"%@", error);
                self.tweet.retweetId = -1;
                self.tweet.retweeted = NO;
            }
        }];
    } else {
        NSLog(@"send retweet reuest");
        self.tweet.retweeted = YES;
        self.retweetButton.selected = YES;
        self.tweet.retweetsCount += 1;
        [[TwitterClient sharedInstance] retweetTweet:self.tweet.tweetId completion:^(NSInteger retweetId, NSError *error) {
            self.tweet.retweetId = retweetId;
            self.tweet.retweeted = YES;
        }];
    }
    [self setRetweetsNumber];
}

- (IBAction)onFavorite:(id)sender {
    if (self.tweet.favorited) {
        NSLog(@"send unfavorite request");
        self.tweet.favorited = NO;
        self.favoritesButton.selected = NO;
        self.tweet.favoritesCount -= 1;
        [[TwitterClient sharedInstance] unfavoriteTweet:self.tweet.tweetId];
    } else {
        NSLog(@"send favorite reuest");
        self.tweet.favorited = YES;
        self.favoritesButton.selected = YES;
        self.tweet.favoritesCount += 1;
        [[TwitterClient sharedInstance] favoriteTweet:self.tweet.tweetId];
    }
    [self setFavoritesNumber];
    
}

- (void)setFavoritesNumber {
    NSInteger numFavorites = self.tweet.favoritesCount;
    if (numFavorites > 0) {
        self.favoritesCount.text = [@(numFavorites) stringValue];
    } else {
        self.favoritesCount.text = @"";
    }
}

- (void)setRetweetsNumber {
    NSInteger numRetweets = self.tweet.retweetsCount;
    if (numRetweets > 0) {
        self.retweetsCount.text = [@(numRetweets) stringValue];
    } else {
        self.retweetsCount.text = @"";
    }
}

@end
