//
//  ComposeTweetController.h
//  Twitter
//
//  Created by Ken Szubzda on 2/22/15.
//  Copyright (c) 2015 Ken Szubzda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ComposeTweetController;

@protocol ComposeTweetControllerDelegate <NSObject>
- (void)composeTweetController:(ComposeTweetController *)composeTweetController didSendTweet:(NSString *)tweet;
@end

@interface ComposeTweetController : UIViewController

@property (nonatomic, weak) id<ComposeTweetControllerDelegate> delegate;

@end
