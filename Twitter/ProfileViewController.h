//
//  ProfileViewController.h
//  Twitter
//
//  Created by Ken Szubzda on 3/1/15.
//  Copyright (c) 2015 Ken Szubzda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "ComposeTweetController.h"

@interface ProfileViewController : UIViewController
- (id)initWithUser:(User *)user;
@end
