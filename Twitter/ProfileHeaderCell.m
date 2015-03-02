//
//  ProfileHeaderCell.m
//  Twitter
//
//  Created by Ken Szubzda on 3/1/15.
//  Copyright (c) 2015 Ken Szubzda. All rights reserved.
//

#import "ProfileHeaderCell.h"
#import "UIImageView+AFNetworking.h"

@interface ProfileHeaderCell ()
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *handleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberTweetsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberFollowersLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberFollowingLabel;

@end

@implementation ProfileHeaderCell

- (void)awakeFromNib {
    // Initialization code
    // round the corners of the thumbnail
    self.thumbImageView.layer.cornerRadius = 3;
    self.thumbImageView.clipsToBounds = YES;
    [self.thumbImageView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.thumbImageView.layer setBorderWidth:2.0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(User *)user {
    _user = user;
    user.profileImageUrl = [user.profileImageUrl stringByReplacingOccurrencesOfString:@"normal" withString:@"bigger"];
    [self.thumbImageView setImageWithURL:[NSURL URLWithString:user.profileImageUrl]];
    self.nameLabel.text = user.name;
    self.handleLabel.text = [NSString stringWithFormat:@"@%@", user.screenName];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    self.numberTweetsLabel.text = [formatter stringFromNumber:[NSNumber numberWithInteger:user.numberTweets]];
    self.numberFollowingLabel.text = [formatter stringFromNumber:[NSNumber numberWithInteger:user.numberFollowing]];
    self.numberFollowersLabel.text = [formatter stringFromNumber:[NSNumber numberWithInteger:user.numberFollowers]];
}

@end
