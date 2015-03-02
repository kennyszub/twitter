//
//  MenuViewController.m
//  Twitter
//
//  Created by Ken Szubzda on 2/28/15.
//  Copyright (c) 2015 Ken Szubzda. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuCell.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *sections;
@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuCell" bundle:nil] forCellReuseIdentifier:@"MenuCell"];
    self.tableView.rowHeight = 100;
    
    self.sections = [[NSArray alloc] initWithObjects:@"Profile", @"Timeline", @"Mentions", @"Sign Out", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Table view methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuCell *menuCell = [self.tableView dequeueReusableCellWithIdentifier:@"MenuCell" forIndexPath:indexPath];
    menuCell.sectionLabel.text = self.sections[indexPath.row];
    return menuCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.delegate menuViewController:self didSelectMenuCellAtIndexPath:indexPath];
}


@end
