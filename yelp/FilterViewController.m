//
//  FilterViewController.m
//  yelp
//
//  Created by Vince Magistrado on 9/21/14.
//  Copyright (c) 2014 Vince Magistrado. All rights reserved.
//

#import "FilterViewController.h"
#import "CategoryFilterCell.h"

@interface FilterViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSMutableDictionary *isCategoryEnabled;
@property (strong, nonatomic) NSArray *sortTypes;
@property (strong, nonatomic) NSArray *distances;

@property (nonatomic) BOOL isCategoriesExpanded;
@property (nonatomic) BOOL isSortExpanded;
@property (nonatomic) NSInteger selectedSortType;
@property (nonatomic) BOOL isDistanceExpanded;
@property (nonatomic) NSInteger selectedDistance;
@property (nonatomic) BOOL isDealsEnabled;

@end

@implementation FilterViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // init settings
        // categories
        self.categories = @[
                           @{ @"name" : @"American (New)",
                              @"id" : @"newamerican"},
                           @{ @"name" : @"Barbeque",
                              @"id" : @"bbq"},
                           @{ @"name" : @"Cafes",
                              @"id" : @"cafes"},
                           @{ @"name" : @"Diners",
                              @"id" : @"diners"},
                           @{ @"name" : @"Ethiopian",
                              @"id" : @"ethiopian"},
                           @{ @"name" : @"Filipino",
                              @"id" : @"filipino"},
                           @{ @"name" : @"Greek",
                              @"id" : @"greek"},
                           @{ @"name" : @"Hawaiian",
                              @"id" : @"hawaiian"},
                           @{ @"name" : @"Italian",
                              @"id" : @"italian"},
                           @{ @"name" : @"Japanase",
                              @"id" : @"japanese"},
                           @{ @"name" : @"Korean",
                              @"id" : @"korean"},
                           @{ @"name" : @"Latin American",
                              @"id" : @"latin"},
                           @{ @"name" : @"Mexican",
                              @"id" : @"mexican"},
                           @{ @"name" : @"Night Food",
                              @"id" : @"nightfood"},
                           @{ @"name" : @"Open Sandwiches",
                              @"id" : @"opensandwiches"},
                           @{ @"name" : @"Pizza",
                              @"id" : @"pizza"},
                           @{ @"name" : @"Rice",
                              @"id" : @"riceshop"},
                           @{ @"name" : @"Seafood",
                              @"id" : @"seafood"},
                           @{ @"name" : @"Thai",
                              @"id" : @"thai"},
                           @{ @"name" : @"Ukrainian",
                              @"id" : @"ukrainian"},
                           @{ @"name" : @"Vietnamese",
                              @"id" : @"vietnamese"},
                           @{ @"name" : @"Wraps",
                              @"id" : @"wraps"},
                           @{ @"name" : @"Yugoslav",
                              @"id" : @"yugoslav"}
                           ];
        self.isCategoriesExpanded = NO;
        self.isCategoryEnabled = [NSMutableDictionary dictionary];
        
        // sort
        self.isSortExpanded = NO;
        self.sortTypes = @[
                           @"Best Match",
                           @"Distance",
                           @"Highest Rated"
                           ];
        self.selectedSortType = 0;
        
        // distance
        self.isDistanceExpanded = NO;
        self.distances = @[
                           @{ @"name" : @"400 meters",
                              @"meters" : @"400"},
                           @{ @"name" : @"1600 meters",
                              @"meters" : @"1600"},
                           @{ @"name" : @"8000 meters",
                              @"meters" : @"8000"},
                           @{ @"name" : @"40000 meters",
                              @"meters" : @"40000"}
                           ];
        self.selectedDistance = 2;
        
        // deals
        self.isDealsEnabled = NO;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // set delegates
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // set title
    self.navigationItem.title = @"Filter";
    
    // register nib
    [self.tableView registerNib:[UINib nibWithNibName:@"CategoryFilterCell" bundle:nil] forCellReuseIdentifier:@"CategoryFilterCell"];
    
    // add search button
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(applyFilters)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) categoryChanged:(id)sender {
    UISwitch *categorySwitch = (UISwitch *)sender;
    UITableViewCell *cell = (UITableViewCell *) categorySwitch.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        self.isCategoryEnabled[@(row)] = @(categorySwitch.on);
    } else if (section == 3) {
        self.isDealsEnabled = categorySwitch.on;
    }
}

- (void)applyFilters {
    NSString *distance = self.distances[self.selectedDistance][@"meters"];
    [self.delegate applyCategories:self.categories categoriesEnabled:self.isCategoryEnabled sortType:self.selectedSortType distance:distance deals:self.isDealsEnabled];
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        // category
        case 0:
            if (self.isCategoriesExpanded) {
                return [self.categories count];
            } else {
                return 4;
            }
        // sort
        case 1:
            if (self.isSortExpanded) {
                return [self.sortTypes count];
            } else {
                return 1;
            }
        // distance
        case 2:
            if (self.isDistanceExpanded) {
                return [self.distances count];
            } else {
                return 1;
            }
        // deals
        case 3:
            return 1;
        default:    // should never get here
            return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) { // categories
        if (row < 3 || self.isCategoriesExpanded) {
            CategoryFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryFilterCell"];
            cell.categoryLabel.text = self.categories[row][@"name"];
            if ([self.isCategoryEnabled[@(row)] boolValue]) {
                [cell.categorySwitch setOn:YES animated:NO];
            } else {
                [cell.categorySwitch setOn:NO animated:NO];
            }
            // add handler for UISwitch
            cell.accessoryView = cell.categorySwitch;
            [cell.categorySwitch addTarget:self action:@selector(categoryChanged:) forControlEvents:UIControlEventValueChanged];
            
            return cell;
        } else {
            // the Show All cell
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            UILabel *showAllLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 320, 50)];
            showAllLabel.text = @"Show All";
            [cell addSubview:showAllLabel];
            return cell;
        }
    } else if (section == 1) {  // sort
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        UILabel *sortLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 320, 50)];
        if (self.isSortExpanded) {
            sortLabel.text = self.sortTypes[row];
        } else {
            sortLabel.text = self.sortTypes[self.selectedSortType];
        }
        [cell addSubview:sortLabel];
        return cell;
    } else if (section == 2) {  // distance
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        UILabel *distanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 320, 50)];
        if (self.isDistanceExpanded) {
            distanceLabel.text = self.distances[row][@"name"];
        } else {
            distanceLabel.text = self.distances[self.selectedDistance][@"name"];
        }
        [cell addSubview:distanceLabel];

        return cell;
    } else if (section == 3) {
        CategoryFilterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryFilterCell"];
        cell.categoryLabel.text = @"Deals";
        if (self.isDealsEnabled) {
            [cell.categorySwitch setOn:YES animated:NO];
        } else {
            [cell.categorySwitch setOn:NO animated:NO];
        }
        // add handler for UISwitch
        cell.accessoryView = cell.categorySwitch;
        [cell.categorySwitch addTarget:self action:@selector(categoryChanged:) forControlEvents:UIControlEventValueChanged];
            
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // unhighlight selection
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        // Show All Categories
        if (row == 3 && !self.isCategoriesExpanded) {
            self.isCategoriesExpanded = YES;
        }
    } else if (section == 1) {
        self.isSortExpanded = !self.isSortExpanded;
        if (!self.isSortExpanded) {
            self.selectedSortType = row;
        }
    } else if (section == 2) {
        self.isDistanceExpanded = !self.isDistanceExpanded;
        if (!self.isDistanceExpanded) {
            self.selectedDistance = row;
        }
    } else if (section == 3) {
        self.isDealsEnabled = !self.isDealsEnabled;
    }
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // one section each for category, sort, radius, and deals
    return 4;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    headerView.backgroundColor = [UIColor colorWithWhite:.9 alpha:.9];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 320, 50)];
    switch (section) {
        case 0:
            headerLabel.text = @"Category";
            break;
        case 1:
            headerLabel.text = @"Sort";
            break;
        case 2:
            headerLabel.text = @"Distance";
            break;
        case 3:
            headerLabel.text = @"Deals";
            break;
    }
    headerLabel.font = [UIFont systemFontOfSize:16];
    headerLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    [headerView addSubview:headerLabel];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
