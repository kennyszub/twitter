//
//  ComposeTweetController.h
//  Twitter
//
//  Created by Ken Szubzda on 2/22/15.
//  Copyright (c) 2015 Ken Szubzda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

@class ComposeTweetController;

@protocol ComposeTweetControllerDelegate <NSObject>

@optional
- (void)composeTweetController:(ComposeTweetController *)composeTweetController didSendTweet:(NSString *)tweet;
- (void)composeTweetController:(ComposeTweetController *)composeTweetController didSendTweet:(NSString *)tweet inReplyToStatusId:(NSInteger)statusId;

@end

@interface ComposeTweetController : UIViewController

@property (nonatomic, weak) id<ComposeTweetControllerDelegate> delegate;
@property (nonatomic, strong) Tweet *replyToTweet;

@end
