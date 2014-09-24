//
//  FilterViewController.h
//  yelp
//
//  Created by Vince Magistrado on 9/21/14.
//  Copyright (c) 2014 Vince Magistrado. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterViewControllerDelegate <NSObject>

- (void)applyCategories:(NSArray *)categories categoriesEnabled:(NSMutableDictionary *) categoriesEnabled sortType:(NSInteger) sortType distance:(NSString *) distance deals:(BOOL) isDealsEnabled;
@end

@interface FilterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) id <FilterViewControllerDelegate> delegate;

@end
