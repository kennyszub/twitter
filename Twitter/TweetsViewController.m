//
//  TweetsViewController.m
//  Twitter
//
//  Created by Ken Szubzda on 2/21/15.
//  Copyright (c) 2015 Ken Szubzda. All rights reserved.
//

#import "TweetsViewController.h"
#import "User.h"
#import "TwitterClient.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "UIScrollView+SVPullToRefresh.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "ComposeTweetController.h"
#import "TweetDetailsController.h"
#import "ProfileViewController.h"

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate, ComposeTweetControllerDelegate, TweetCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) NSString *title;

@end

@implementation TweetsViewController

- (id)initWithHomeTimeline {
    self = [super self];
    if (self) {
        [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSMutableArray *tweets, NSError *error) {
            self.tweets = tweets;
            [self.tableView reloadData];
        }];
        self.title = @"Home";
    }
    return self;
}

- (id)initWithMentionsTimeline {
    self = [super self];
    if (self) {
        [[TwitterClient sharedInstance] mentionsTimelineWithParams:nil completion:^(NSMutableArray *tweets, NSError *error) {
            self.tweets = tweets;
            [self.tableView reloadData];
        }];
        self.title = @"Mentions";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // setup tableview
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // setup nav bar
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    self.navigationItem.title = self.title;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hamburger"] style:UIBarButtonItemStyleDone target:self action:@selector(onHamburgerTap)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(onCompose)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.tableView addPullToRefreshWithActionHandler:^{
        [self onRefresh];
        [self.tableView.pullToRefreshView stopAnimating];
    }];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [self onInfiniteScroll];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Private methods

- (void)onCompose {
    ComposeTweetController *ctc = [[ComposeTweetController alloc] init];
    ctc.delegate = self;
    ctc.replyToTweet = nil;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:ctc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)onRefresh {
    Tweet *newestTweet = self.tweets[0];
    NSDictionary *params = [NSDictionary dictionaryWithObject:@(newestTweet.tweetId) forKey:@"since_id"];

    [[TwitterClient sharedInstance] homeTimelineWithParams:params completion:^(NSMutableArray *tweets, NSError *error) {
        if (tweets && tweets.count > 0) {
            NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, tweets.count)];
            [self.tweets insertObjects:tweets atIndexes:indexes];
            [self.tableView reloadData];
        }        
    }];
}

- (void)onInfiniteScroll {
    Tweet *oldestTweet = self.tweets[self.tweets.count - 1];
    
    NSDictionary *params = [NSDictionary dictionaryWithObject:@(oldestTweet.tweetId - 1) forKey:@"max_id"];

    // TODO do this in a better way
    if ([self.title isEqualToString:@"Home"]) {
        [[TwitterClient sharedInstance] homeTimelineWithParams:params completion:^(NSMutableArray *tweets, NSError *error) {
            if (tweets && tweets.count > 0) {
                [self.tweets addObjectsFromArray:tweets];
                [self.tableView reloadData];
            }
            [self.tableView.infiniteScrollingView stopAnimating];
        }];
    } else {
        [[TwitterClient sharedInstance] mentionsTimelineWithParams:params completion:^(NSMutableArray *tweets, NSError *error) {
            if (tweets && tweets.count > 0) {
                [self.tweets addObjectsFromArray:tweets];
                [self.tableView reloadData];
            }
            [self.tableView.infiniteScrollingView stopAnimating];
        }];
    }

}

- (void)onHamburgerTap {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidTapHamburger" object:nil];
}




# pragma mark - Delegate methods
- (void)composeTweetController:(ComposeTweetController *)composeTweetController didSendTweet:(NSString *)tweet {
    [[TwitterClient sharedInstance] createTweetWithTweet:tweet params:nil completion:^(Tweet *tweet, NSError *error) {
        if (error == nil) {
            [self.tweets insertObject:tweet atIndex:0];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)composeTweetController:(ComposeTweetController *)composeTweetController didSendTweet:(NSString *)tweet inReplyToStatusId:(NSInteger)statusId {
    NSDictionary *params = @{@"in_reply_to_status_id" : @(statusId)};
    [[TwitterClient sharedInstance] createTweetWithTweet:tweet params:params completion:^(Tweet *tweet, NSError *error) {
        if (error == nil) {
            [self.tweets insertObject:tweet atIndex:0];
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error);
        }
    }];
}

- (void)tweetCell:(TweetCell *)cell didReplyToTweet:(Tweet *)tweet {
    ComposeTweetController *ctc = [[ComposeTweetController alloc] init];
    ctc.replyToTweet = tweet;
    ctc.delegate = self;
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:ctc];
    [self presentViewController:nvc animated:YES completion:nil];
}

- (void)tweetCell:(TweetCell *)cell didTapUser:(User *)user {
    ProfileViewController *pvc = [[ProfileViewController alloc] initWithUser:user];
    [self.navigationController pushViewController:pvc animated:YES];
}

#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    cell.tweet = self.tweets[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    TweetDetailsController *tc = [[TweetDetailsController alloc] init];
    tc.tweet = self.tweets[indexPath.row];
    [self.navigationController pushViewController:tc animated:YES];
}


@end
