//
//  TwitterClient.m
//  Twitter
//
//  Created by Ken Szubzda on 2/19/15.
//  Copyright (c) 2015 Ken Szubzda. All rights reserved.
//

#import "TwitterClient.h"
#import "Tweet.h"

NSString * const kTwitterConsumerKey = @"zC6GBxJ1hLud2mp3jpgt3Fw1f";
NSString * const kTwitterConsumerSecret = @"36nr0nbeFZlnziYgn1ISDvY59qCgUyS1W1i7bnCdVtCV17Wi1w";
NSString * const kTwitterBaseUrl = @"https://api.twitter.com";

@interface TwitterClient()

@property (nonatomic, strong) void (^loginCompletion)(User *, NSError *);

@end

@implementation TwitterClient

+ (TwitterClient *)sharedInstance {
    static TwitterClient *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
  
    return instance;
}

- (void)loginWithCompletion:(void (^)(User *, NSError *))completion {
    self.loginCompletion = completion;
    
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:@"oauth/request_token" method:@"GET" callbackURL:[NSURL URLWithString:@"kentwitterdemo://oauth"] scope:nil
                            success:^(BDBOAuth1Credential *requestToken) {
                                NSLog(@"got the request token");
                                NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@", requestToken.token]];
                                [[UIApplication sharedApplication] openURL:authURL];
                            } failure:^(NSError *error) {
                                NSLog(@"failed to get request token");
                                self.loginCompletion(nil, error);
                            }];
}

- (void)openURL:(NSURL *)url {
    [self fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        NSLog(@"got the access token!");
        [self.requestSerializer saveAccessToken:accessToken];
        [self GET:@"1.1/account/verify_credentials.json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"current user: %@", responseObject);
            User *user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];
            NSLog(@"current user: %@", user.name);
            self.loginCompletion(user, nil);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"failed getting current user");
            self.loginCompletion(nil, error);
        }];
        
    } failure:^(NSError *error) {
        NSLog(@"failed to get the access token!");
    }];

}

- (void)homeTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSMutableArray *, NSError *))completion {
    [self GET:@"1.1/statuses/home_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        completion(nil, error);
    }];
}

- (void)mentionsTimelineWithParams:(NSDictionary *)params completion:(void (^)(NSMutableArray *, NSError *))completion {
    [self GET:@"1.1/statuses/mentions_timeline.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *tweets = [Tweet tweetsWithArray:responseObject];
        completion(tweets, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        completion(nil, error);
    }];
}

- (void)favoriteTweet:(NSInteger)tweetId {
    NSDictionary *params = @{@"id" : @(tweetId)};
    [self POST:@"1.1/favorites/create.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"successfully favorited");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to favorite");
    }];
}

- (void)unfavoriteTweet:(NSInteger)tweetId {
    NSDictionary *params = @{@"id" : @(tweetId)};
    [self POST:@"1.1/favorites/destroy.json" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"successfully unfavorited");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to unfavorite");
    }];
}

- (void)retweetTweet:(NSInteger)tweetId completion:(void (^)(NSInteger, NSError *))completion {
    NSString *retweetUrl = [NSString stringWithFormat:@"1.1/statuses/retweet/%ld.json", tweetId];
    [self POST:retweetUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"successfully retweeted");
        NSInteger retweetId = [responseObject[@"id"] integerValue];
        completion(retweetId, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to retweet");
        completion(-1, error);
    }];
}

- (void)unRetweetTweet:(NSInteger)tweetId completion:(void (^)(NSError *))completion {
    NSString *retweetUrl = [NSString stringWithFormat:@"1.1/statuses/destroy/%ld.json", tweetId];
    [self POST:retweetUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"successfully unRetweeted");
        completion(nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to unRetweet");
        completion(error);
    }];
}

- (void)createTweetWithTweet:(NSString *)tweet params:(NSDictionary *)params completion:(void (^)(Tweet *tweet, NSError *))completion {
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithDictionary:params];
    [parameters setObject:tweet forKey:@"status"];
    [self POST:@"1.1/statuses/update.json" parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:responseObject];
        completion(tweet, nil);
        NSLog(@"successfully tweeted");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completion(nil, error);
        NSLog(@"failed to tweet");
    }];
}



@end
