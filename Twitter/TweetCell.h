//
//  TweetCell.h
//  Twitter
//
//  Created by Ken Szubzda on 2/21/15.
//  Copyright (c) 2015 Ken Szubzda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class TweetCell;

@protocol TweetCellDelegate <NSObject>

- (void)tweetCell:(TweetCell *)cell didReplyToTweet:(Tweet *)tweet;
- (void)tweetCell:(TweetCell *)cell didTapUser:(User *)user;

@end

@interface TweetCell : UITableViewCell

@property (nonatomic, strong) Tweet * tweet;
@property (nonatomic, weak) id<TweetCellDelegate> delegate;

@end
