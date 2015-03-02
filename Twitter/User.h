//
//  User.h
//  Twitter
//
//  Created by Ken Szubzda on 2/19/15.
//  Copyright (c) 2015 Ken Szubzda. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const UserDidLoginNotification;
extern NSString * const UserDidLogoutNotification;

@interface User : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *tagline;
@property (nonatomic, strong) NSString *profileBackgroundImageUrl;
@property (nonatomic, assign) NSInteger numberTweets;
@property (nonatomic, assign) NSInteger numberFollowers;
@property (nonatomic, assign) NSInteger numberFollowing;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (User *)currentUser;
+ (void)setCurrentUser:(User*)currentUser;

+ (void)logout;
@end
