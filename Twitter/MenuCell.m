//
//  MenuCell.m
//  Twitter
//
//  Created by Ken Szubzda on 2/28/15.
//  Copyright (c) 2015 Ken Szubzda. All rights reserved.
//

#import "MenuCell.h"

@interface MenuCell ()
@property (weak, nonatomic) IBOutlet UILabel *sectionLabel;

@end

@implementation MenuCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
