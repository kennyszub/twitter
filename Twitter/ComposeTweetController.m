//
//  ComposeTweetController.m
//  Twitter
//
//  Created by Ken Szubzda on 2/22/15.
//  Copyright (c) 2015 Ken Szubzda. All rights reserved.
//

#import "ComposeTweetController.h"

@interface ComposeTweetController ()

@end

@implementation ComposeTweetController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    
    // set navigation bar colors
    [self.navigationController.navigationBar setBarTintColor:[[UIColor alloc] initWithRed:245/255.0 green:248/255.0 blue:250/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTintColor:[[UIColor alloc] initWithRed:85/255.0 green:172/255.0 blue:238/255.0 alpha:1.0]];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(onCancelButton)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(onCancelButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStyleDone target:self action:@selector(onCancelButton)];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onCancelButton {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
