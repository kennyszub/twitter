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

@interface TweetsViewController () <UITableViewDataSource, UITableViewDelegate, ComposeTweetControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tweets;

@end

@implementation TweetsViewController

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
    self.navigationItem.title = @"Home";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onLogout)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(onCompose)];
    
    // get tweets
    [[TwitterClient sharedInstance] homeTimelineWithParams:nil completion:^(NSMutableArray *tweets, NSError *error) {
        self.tweets = tweets;
        [self.tableView reloadData];
    }];
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

    [[TwitterClient sharedInstance] homeTimelineWithParams:params completion:^(NSMutableArray *tweets, NSError *error) {
        if (tweets && tweets.count > 0) {
            [self.tweets addObjectsFromArray:tweets];
            [self.tableView reloadData];
        }
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}

- (void)onLogout {
    [User logout];
}

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

#pragma mark - Table view methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    cell.tweet = self.tweets[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
//    BusinessDetailsController *bc = [[BusinessDetailsController alloc] init];
//    bc.business = self.businesses[indexPath.row];
//    [self.navigationController pushViewController:bc animated:YES];
//}


@end
