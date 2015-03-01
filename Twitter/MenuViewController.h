//
//  MenuViewController.h
//  Twitter
//
//  Created by Ken Szubzda on 2/28/15.
//  Copyright (c) 2015 Ken Szubzda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuViewController;

@protocol MenuViewControllerDelegate <NSObject>

- (void)menuViewController:(MenuViewController *)viewController didSelectMenuCellAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface MenuViewController : UIViewController

@property (nonatomic, weak) id<MenuViewControllerDelegate> delegate;

@end
