//
//  ContainerViewController.m
//  Twitter
//
//  Created by Ken Szubzda on 2/25/15.
//  Copyright (c) 2015 Ken Szubzda. All rights reserved.
//

#import "ContainerViewController.h"

@interface ContainerViewController ()
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, assign) CGPoint originalContentCenter;
@property (nonatomic, assign) CGPoint contentViewRightPosition;

@end

@implementation ContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.contentViewRightPosition = CGPointMake(self.view.frame.size.width * 1.25, self.view.center.y);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.originalContentCenter = self.contentView.center;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        double newCenterX = self.originalContentCenter.x + [sender translationInView:self.view].x;
        if ((newCenterX <= self.contentViewRightPosition.x) && (newCenterX >= self.view.center.x)) {
            self.contentView.center = CGPointMake(newCenterX, self.originalContentCenter.y);
        }
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint velocity = [sender velocityInView:self.view];
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionTransitionNone animations:^{
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


@end
