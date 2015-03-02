//
//  ProfileViewController.m
//  Twitter
//
//  Created by Ken Szubzda on 3/1/15.
//  Copyright (c) 2015 Ken Szubzda. All rights reserved.
//

#import "ProfileViewController.h"
#import "TwitterClient.h"
#import "TweetCell.h"
#import "ComposeTweetController.h"
#import "UIImageView+AFNetworking.h"
#import "ProfileHeaderCell.h"
#import "UIScrollView+SVInfiniteScrolling.h"
#import "TweetDetailsController.h"


const NSInteger kHeaderHeight = 140;

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource, TweetCellDelegate, ComposeTweetControllerDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *tweets;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) UIImageView *headerImage;

@end

@implementation ProfileViewController

- (id)initWithUser:(User *)user {
    self = [super init];
    if (self) {
        NSDictionary *params = @{@"screen_name" : user.screenName};
        [[TwitterClient sharedInstance] userTimelineWithParams:params completion:^(NSMutableArray *tweets, NSError *error) {
            self.tweets = tweets;
            [self.tableView reloadData];
        }];
        self.user = user;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"ProfileHeaderCell" bundle:nil] forCellReuseIdentifier:@"ProfileHeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TweetCell" bundle:nil] forCellReuseIdentifier:@"TweetCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // setup nav bar
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    self.navigationItem.title = self.user.name;
    
    if (self.user == [User currentUser]) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"hamburger"] style:UIBarButtonItemStyleDone target:self action:@selector(onHamburgerTap)];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(onCompose)];
    
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [self onInfiniteScroll];
    }];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    UIImageView *headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, -kHeaderHeight, self.tableView.frame.size.width, kHeaderHeight)];
    [headerImage setImageWithURL:[NSURL URLWithString:self.user.profileBackgroundImageUrl]];
    headerImage.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImage = headerImage;
    [self.tableView insertSubview:headerImage atIndex:0];
    
    self.tableView.contentInset = UIEdgeInsetsMake(kHeaderHeight, 0, 0, 0);
    self.tableView.contentOffset = CGPointMake(0, -kHeaderHeight);
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
    
    NSDictionary *params = @{@"max_id" : @(oldestTweet.tweetId - 1),
                             @"screen_name" : self.user.screenName};
    [[TwitterClient sharedInstance] userTimelineWithParams:params completion:^(NSMutableArray *tweets, NSError *error) {
        if (tweets && tweets.count > 0) {
            [self.tweets addObjectsFromArray:tweets];
            [self.tableView reloadData];
        }
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}


- (void)onHamburgerTap {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserDidTapHamburger" object:nil];

}

- (void)updateHeaderView {
    CGRect headerRect = CGRectMake(0, -kHeaderHeight, self.tableView.bounds.size.width, kHeaderHeight);
    if (self.tableView.contentOffset.y < -kHeaderHeight) {
        headerRect.origin.y = self.tableView.contentOffset.y;
        headerRect.size.height = - self.tableView.contentOffset.y;
    }
    
    self.headerImage.frame = headerRect;
}

# pragma mark - Delegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateHeaderView];
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
    if (![user.screenName isEqualToString: self.user.screenName]) {
        ProfileViewController *pvc = [[ProfileViewController alloc] initWithUser:user];
        [self.navigationController pushViewController:pvc animated:YES];
    }
}

#pragma mark Table view methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileHeaderCell *profileHeaderCell;
    TweetCell *cell;
    switch (indexPath.row) {
        case 0:
            profileHeaderCell = [self.tableView dequeueReusableCellWithIdentifier:@"ProfileHeaderCell" forIndexPath:indexPath];
            profileHeaderCell.user = self.user;
            return profileHeaderCell;
        default:
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
            cell.tweet = self.tweets[indexPath.row - 1]; // offset the profile header cell
            cell.delegate = self;
            return cell;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    TweetDetailsController *tc = [[TweetDetailsController alloc] init];
    tc.tweet = self.tweets[indexPath.row];
    [self.navigationController pushViewController:tc animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end
