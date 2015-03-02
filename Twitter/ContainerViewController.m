//
//  ContainerViewController.m
//  Twitter
//
//  Created by Ken Szubzda on 2/25/15.
//  Copyright (c) 2015 Ken Szubzda. All rights reserved.
//

#import "ContainerViewController.h"
#import "MenuViewController.h"
#import "TweetsViewController.h"
#import "ProfileViewController.h"
#import "User.h"

NSString * const UserDidTapHamburger = @"UserDidTapHamburger";


@interface ContainerViewController () <MenuViewControllerDelegate>
@property (nonatomic, assign) CGPoint originalContentCenter;
@property (nonatomic, assign) CGPoint contentViewRightPosition;

@property (strong, nonatomic) MenuViewController *menuController;
@property (strong, nonatomic) UIView *contentView; // TODO maybe this should be a UINavigationController

@property (strong, nonatomic) UINavigationController *profileController;
@property (strong, nonatomic) UINavigationController *timelineController;
@property (strong, nonatomic) UINavigationController *mentionsController;

@end

@implementation ContainerViewController

- (id)initWithMenuView:(MenuViewController *)menuViewController contentView:(UINavigationController *)navigationController {
    self = [super init];
    if (self) {
        // initialize container view
        self.contentView = [[UIView alloc] init];
        // set menu controller
        self.menuController = menuViewController;
        self.menuController.delegate = self;
        // initialize timeline and mentions view controllers
        self.timelineController = navigationController;
        self.mentionsController = nil;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidTapHamburger) name:UserDidTapHamburger object:nil];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view from its nib.

    // add pan gesture for hamburger
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGesture:)];
    [self.view addSubview:self.menuController.view];
    [self.view addSubview:self.contentView];
    [self.view addGestureRecognizer:panGesture];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.contentViewRightPosition = CGPointMake(self.view.frame.size.width * 1.25, self.view.center.y);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self addChildViewController:self.menuController];
    [self addChildViewController:self.timelineController];
    
    self.menuController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width * 0.75, self.view.frame.size.height);
    self.contentView.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    
    // show timeline controller
    [self.contentView addSubview:self.timelineController.view];
    
    [self.menuController didMoveToParentViewController:self];
    [self.timelineController didMoveToParentViewController:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onPanGesture:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.originalContentCenter = self.contentView.center;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        double newCenterX = self.originalContentCenter.x + [sender translationInView:self.view].x;
        if ((newCenterX <= self.contentViewRightPosition.x) && (newCenterX >= self.view.center.x)) {
            self.contentView.center = CGPointMake(newCenterX, self.originalContentCenter.y);
        }
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [sender velocityInView:self.view];
        [UIView animateWithDuration:0.4 animations:^{
            if (velocity.x > 0) {
                // going right
                self.contentView.center = self.contentViewRightPosition;
            } else {
                self.contentView.center = self.view.center;
            }
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)menuViewController:(MenuViewController *)viewController didSelectMenuCellAtIndexPath:(NSIndexPath *)indexPath {
    [UIView animateWithDuration:0.4 animations:^{
        self.contentView.center = self.view.center;
    }];
    switch (indexPath.row) {
        case 0: // profile
            if (self.profileController == nil) {
                ProfileViewController *pvc = [[ProfileViewController alloc] initWithUser:[User currentUser]];
                UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:pvc];
                self.profileController = nvc;
                
//                [self addChildViewController:self.profileController];
                
                self.profileController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                [self.profileController didMoveToParentViewController:self];
            }
            [self.contentView addSubview:self.profileController.view];
            break;
        case 1: // timeline
            [self.contentView addSubview:self.timelineController.view];
            break;
        case 2: // mentions
            if (self.mentionsController == nil) {
                TweetsViewController *tvc = [[TweetsViewController alloc] initWithMentionsTimeline];
                UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:tvc];
                self.mentionsController = nvc;
                
                [self addChildViewController:self.mentionsController];
                self.mentionsController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
                [self.mentionsController didMoveToParentViewController:self];
            }
            [self.contentView addSubview:self.mentionsController.view];
            break;
        case 3: // sign out
            [User logout];
            break;
        default:
            break;
    }
}

- (void)userDidTapHamburger {
    [UIView animateWithDuration:0.4 animations:^{
        self.contentView.center = self.contentViewRightPosition;
    }];

}



@end
