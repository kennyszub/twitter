//
//  TweetDetailsController.m
//  Twitter
//
//  Created by Ken Szubzda on 2/21/15.
//  Copyright (c) 2015 Ken Szubzda. All rights reserved.
//

#import "TweetDetailsController.h"
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"
#import "TwitterClient.h"
#import "ComposeTweetController.h"

@interface TweetDetailsController () <ComposeTweetControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *screenNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tweetTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberRetweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberFavoritesLabel;

@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoritesButton;

@end

@implementation TweetDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // setup view
    User *user = self.tweet.user;
    [self.thumbnailView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    self.screenNameLabel.text = user.name;
    self.handleLabel.text = [NSString stringWithFormat:@"@%@", user.screenName];
    self.tweetTextLabel.text = self.tweet.text;
    self.numberRetweetsLabel.text = [@(self.tweet.retweetsCount) stringValue];
    self.retweetButton.selected = self.tweet.retweeted;
    self.numberFavoritesLabel.text = [@(self.tweet.favoritesCount) stringValue];
    self.favoritesButton.selected = self.tweet.favorited;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"M/d/yy, h:mm a"];
    self.dateLabel.text = [NSString stringWithFormat:@"%@", [dateFormat stringFromDate:self.tweet.createdAt]];
    
    // round the corners of the thumbnail
    self.thumbnailView.layer.cornerRadius = 3;
    self.thumbnailView.clipsToBounds = YES;
    
    [self.favoritesButton setImage:[UIImage imageNamed:@"favorite_on"] forState:UIControlStateSelected];
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet_on"] forState:UIControlStateSelected];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onReply:(id)sender {
    ComposeTweetController *ctc = [[ComposeTweetController alloc] init];
    ctc.replyToTweet = self.tweet;
    ctc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:ctc];
    [self presentViewController:nvc animated:YES completion:nil];
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
    self.numberRetweetsLabel.text = [@(self.tweet.retweetsCount) stringValue];
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
    self.numberFavoritesLabel.text = [@(self.tweet.favoritesCount) stringValue];
}

- (void)setTweet:(Tweet *)tweet {
    _tweet = tweet;
}

- (void)composeTweetController:(ComposeTweetController *)composeTweetController didSendTweet:(NSString *)tweet inReplyToStatusId:(NSInteger)statusId {
    NSDictionary *params = @{@"in_reply_to_status_id" : @(statusId)};
    [[TwitterClient sharedInstance] createTweetWithTweet:tweet params:params completion:^(Tweet *tweet, NSError *error) {
        if (error == nil) {
            NSLog(@"succesfully replied");
        } else {
            NSLog(@"%@", error);
        }
    }];
}


@end
