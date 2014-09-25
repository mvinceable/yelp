//
//  CategoryFilterCell.m
//  yelp
//
//  Created by Vince Magistrado on 9/23/14.
//  Copyright (c) 2014 Vince Magistrado. All rights reserved.
//

#import "CategoryFilterCell.h"

@implementation CategoryFilterCell
- (IBAction)switchChanged:(id)sender {
    [self.delegate switchChanged:sender];
}

- (void)awakeFromNib {
    // Initialization code
    self.accessoryView = self.categorySwitch;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
