//
//  SearchResultsViewController.m
//  yelp
//
//  Created by Vince Magistrado on 9/21/14.
//  Copyright (c) 2014 Vince Magistrado. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "YelpResultCell.h"
#import "YelpClient.h"
#import "UIImageView+AFNetworking.h"
#import "FilterViewController.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface SearchResultsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISearchBar *searchBar;

@property (nonatomic, strong) YelpClient *client;

@property (nonatomic, strong) NSArray *results;
@property (nonatomic, strong) NSString *searchTerm;

@end

@implementation SearchResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 116;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // add filter button
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filter)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    // add search bar to nav bar
    self.searchBar = [[UISearchBar alloc] init];
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.delegate = self;
    
    // customize back button
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    // register nib
    [self.tableView registerNib:[UINib nibWithNibName:@"YelpResultCell" bundle:nil] forCellReuseIdentifier:@"YelpResultCell"];
    
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    
    // start with focus on the search input
    [self.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *business = self.results[indexPath.row];
    
    YelpResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YelpResultCell"];
    
    NSString *thumbUrl = business[@"image_url"];
    [cell.thumbView setImageWithURL:[NSURL URLWithString:thumbUrl]];
    
    NSString *ratingUrl = business[@"rating_img_url"];
    [cell.ratingView setImageWithURL:[NSURL URLWithString:ratingUrl]];
    
    cell.businessName.text = [NSString stringWithFormat:@"%d. %@", indexPath.row + 1, business[@"name"]];
    
    NSNumber *reviewCount = business[@"review_count"];
    
    // grammar
    if ([reviewCount isEqualToNumber:@1]) {
        cell.reviewCount.text = @"1 Review";
    } else {
        cell.reviewCount.text = [NSString stringWithFormat:@"%@ Reviews", reviewCount];
    }
    
    NSArray *displayAddress = [business valueForKeyPath:@"location.display_address"];
    
    cell.address.text = [displayAddress objectAtIndex:0];
    
    NSArray *categoriesArray = business[@"categories"];
    NSArray *firstCategory = [categoriesArray objectAtIndex:0];
    
    if (firstCategory[0]) {
        NSMutableString *categories = [NSMutableString stringWithString:firstCategory[0]];
    
        for (int i = 1; i < categoriesArray.count; i++) {
            [categories appendString:[NSString stringWithFormat:@", %@", [categoriesArray[i] objectAtIndex:0]]];
        }
    
        cell.categories.text = categories;
    } else {
        cell.categories.text = @"";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // unhighlight selection
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)searchWithTerm:(NSString *)term withFilters:(NSDictionary *)filters {
    [self.client searchWithTerm:term withFilters:filters success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"response: %@", response);
        self.results = response[@"businesses"];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchWithTerm:searchText withFilters:nil];
}

- (void)filter {
    FilterViewController *vc = [[FilterViewController alloc] init];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)applyCategories:(NSArray *)categories categoriesEnabled:(NSMutableDictionary *)isCategoryEnabled sortType:(NSInteger)sortType distance:(NSString *)distance deals:(BOOL) isDealsEnabled {
    int numCategories = [categories count];
    int numEnabled = 0;
    NSMutableString *categoryList = [NSMutableString stringWithString:@""];
    
    for (int i = 0; i < numCategories; i++) {
        if ([isCategoryEnabled[@(i)] boolValue]) {
            if (numEnabled == 0) {
                [categoryList appendString:categories[i][@"id"]];
            } else {
                [categoryList appendString:[NSString stringWithFormat:@",%@", categories[i][@"id"]]];
            }
            numEnabled++;
        }
    }
    
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    
    filters[@"category_filter"] = categoryList;
    filters[@"sort"] = @(sortType);
    filters[@"radius_filter"] = distance;
    filters[@"deals_filter"] = @(isDealsEnabled);
    
    [self searchWithTerm:self.searchBar.text withFilters:filters];
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
