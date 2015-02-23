//
//  TweetDetailsController.h
//  Twitter
//
//  Created by Ken Szubzda on 2/21/15.
//  Copyright (c) 2015 Ken Szubzda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class TweetDetailsController;

@protocol TweetDetailsControllerDelegate <NSObject>

- (void)tweetDetailsController:(TweetDetailsController *)detailsController didReplyToTweet:(Tweet *)tweet;

@end

@interface TweetDetailsController : UIViewController
@property (nonatomic, strong) Tweet *tweet;
@property (nonatomic, weak) id<TweetDetailsControllerDelegate> delegate;

@end
