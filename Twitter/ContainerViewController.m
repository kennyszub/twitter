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

@interface ContainerViewController () <MenuViewControllerDelegate>
@property (nonatomic, assign) CGPoint originalContentCenter;
@property (nonatomic, assign) CGPoint contentViewRightPosition;

@property (strong, nonatomic) MenuViewController *menuController;
@property (strong, nonatomic) UINavigationController *contentController;

@property (strong, nonatomic) UINavigationController *profileController;
@property (strong, nonatomic) UINavigationController *timelineController;
@property (strong, nonatomic) UINavigationController *mentionsController;

@end

@implementation ContainerViewController

- (id)initWithMenuView:(MenuViewController *)menuViewController contentView:(UINavigationController *)navigationController {
    self = [super init];
    if (self) {
        self.menuController = menuViewController;
        self.menuController.delegate = self;
        self.contentController = navigationController;
        self.timelineController = navigationController;
        self.mentionsController = nil;
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
    [self.view addSubview:self.contentController.view];
    [self.view addGestureRecognizer:panGesture];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.contentViewRightPosition = CGPointMake(self.view.frame.size.width * 1.25, self.view.center.y);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self addChildViewController:self.menuController];
    [self addChildViewController:self.contentController];
    self.menuController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width * 0.75, self.view.frame.size.height);
    self.contentController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    [self.menuController didMoveToParentViewController:self];
    [self.contentController didMoveToParentViewController:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onPanGesture:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.originalContentCenter = self.contentController.view.center;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        double newCenterX = self.originalContentCenter.x + [sender translationInView:self.view].x;
        if ((newCenterX <= self.contentViewRightPosition.x) && (newCenterX >= self.view.center.x)) {
            self.contentController.view.center = CGPointMake(newCenterX, self.originalContentCenter.y);
        }
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [sender velocityInView:self.view];
        [UIView animateWithDuration:0.4 animations:^{
            if (velocity.x > 0) {
                // going right
                self.contentController.view.center = self.contentViewRightPosition;
            } else {
                self.contentController.view.center = self.view.center;
            }
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)menuViewController:(MenuViewController *)viewController didSelectMenuCellAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: // profile
            break;
        case 1: // timeline
            [self.contentController.view addSubview:self.timelineController.view];
            break;
        case 2: // mentions
            if (self.mentionsController == nil) {
                TweetsViewController *tvc = [[TweetsViewController alloc] initWithMentionsTimeline];
                UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:tvc];
                self.mentionsController = nvc;
                self.mentionsController.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
            }
            [self.contentController.view addSubview:self.mentionsController.view];
            break;
        default:
            break;
    }
}



@end
