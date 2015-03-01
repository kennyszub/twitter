//
//  MenuCell.h
//  Twitter
//
//  Created by Ken Szubzda on 2/28/15.
//  Copyright (c) 2015 Ken Szubzda. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuCell;

@protocol MenuCellDelegate <NSObject>

- (void)menuCell:(MenuCell *)cell didSelectMenuCellAtIndexPath:(NSIndexPath *)indexPath;

@end
@interface MenuCell : UITableViewCell

@end
