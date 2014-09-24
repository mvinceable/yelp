//
//  CategoryFilterCell.h
//  yelp
//
//  Created by Vince Magistrado on 9/23/14.
//  Copyright (c) 2014 Vince Magistrado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryFilterCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UISwitch *categorySwitch;

@end
