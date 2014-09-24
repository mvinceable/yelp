//
//  SearchResultsViewController.h
//  yelp
//
//  Created by Vince Magistrado on 9/21/14.
//  Copyright (c) 2014 Vince Magistrado. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterViewController.h"

@interface SearchResultsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, FilterViewControllerDelegate>

@end
