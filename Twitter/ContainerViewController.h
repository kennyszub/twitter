//
//  ContainerViewController.h
//  Twitter
//
//  Created by Ken Szubzda on 2/25/15.
//  Copyright (c) 2015 Ken Szubzda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
#import "TweetsViewController.h"

@interface ContainerViewController : UIViewController

- (id)initWithMenuView:(MenuViewController *)menuViewController contentView:(UINavigationController *)navigationController;

@end
