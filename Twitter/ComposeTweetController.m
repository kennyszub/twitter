//
//  ComposeTweetController.m
//  Twitter
//
//  Created by Ken Szubzda on 2/22/15.
//  Copyright (c) 2015 Ken Szubzda. All rights reserved.
//

#import "ComposeTweetController.h"
#import "User.h"
#import "UIImageView+AFNetworking.h"
#import "UIImage+Util.h"

@interface ComposeTweetController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *placeholderText;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ComposeTweetController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    
    // set up navigation bar
    [self.navigationController.navigationBar setBarTintColor:[[UIColor alloc] initWithRed:245/255.0 green:248/255.0 blue:250/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTintColor:[[UIColor alloc] initWithRed:85/255.0 green:172/255.0 blue:238/255.0 alpha:1.0]];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(onCancelButton)];
    
    // set up tweet count
    UILabel *headingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headingLabel.text = @"140";
    headingLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    headingLabel.textColor = [[UIColor alloc] initWithRed:136/255.0 green:153/255.0 blue:166/255.0 alpha:1.0];
    [headingLabel sizeToFit];
    UIBarButtonItem *countItem = [[UIBarButtonItem alloc] initWithCustomView:headingLabel];
    
    // setup tweet button
    UIButton *tweetButton = [self setUpTweetButton];
    UIBarButtonItem *tweetBarButton = [[UIBarButtonItem alloc] initWithCustomView:tweetButton];

    // add to navigation bar
    NSArray *navigationItems = @[tweetBarButton, countItem];
    self.navigationItem.rightBarButtonItems = navigationItems;

    // round the corners of the thumbnail
    self.thumbnailView.layer.cornerRadius = 3;
    self.thumbnailView.clipsToBounds = YES;
    [self setUpUserViews];
    
    self.textView.delegate = self;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setUpUserViews {
    User *currentUser = [User currentUser];
    [self.thumbnailView setImageWithURL:[NSURL URLWithString:currentUser.profileImageUrl]];
    self.nameLabel.text = currentUser.name;
    self.handleLabel.text = [NSString stringWithFormat:@"@%@", currentUser.screenName];
}

- (UIButton *)setUpTweetButton {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 35)];
    button.titleLabel.text =  @"Tweet";
    [button setTitle:@"Tweet" forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [button setBackgroundImage:[UIImage imageWithColor:[[UIColor alloc] initWithRed:85/255.0 green:172/255.0 blue:238/255.0 alpha:1.0]] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageWithColor:[[UIColor alloc] initWithRed:85/255.0 green:172/255.0 blue:238/255.0 alpha:0.5]] forState:UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(onTweetButton) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)onTweetButton {
    [self.delegate composeTweetController:self didSendTweet:self.textView.text];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView hasText]) {
        self.placeholderText.hidden = YES;
    } else {
        self.placeholderText.hidden = NO;
    }
}

@end
