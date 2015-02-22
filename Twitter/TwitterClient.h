//
//  TwitterClient.h
//  Twitter
//
//  Created by Ken Szubzda on 2/19/15.
//  Copyright (c) 2015 Ken Szubzda. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

+ (TwitterClient *)sharedInstance;

- (void)loginWithCompletion:(void (^)(User *user, NSError *error))completion;
- (void)openURL:(NSURL *)url;

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSMutableArray *tweets, NSError *error))completion;
- (void)favoriteTweet:(NSInteger)tweetId;
- (void)unfavoriteTweet:(NSInteger)tweetId;
- (void)retweetTweet:(NSInteger)tweetId completion:(void (^)(NSInteger retweetId, NSError *error))completion;
- (void)unRetweetTweet:(NSInteger)tweetId completion:(void (^)(NSError *error))completion;

@end
