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

@interface TweetDetailsController : UIViewController
@property (nonatomic, strong) Tweet *tweet;

@end
