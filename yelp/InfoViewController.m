//
//  InfoViewController.m
//  yelp
//
//  Created by Vince Magistrado on 9/24/14.
//  Copyright (c) 2014 Vince Magistrado. All rights reserved.
//

#import "InfoViewController.h"
#import "UIImageView+AFNetworking.h"

@interface InfoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *thumbView;
@property (weak, nonatomic) IBOutlet UIImageView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *businessLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoriesLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIImageView *snippetView;
@property (weak, nonatomic) IBOutlet UILabel *snippetLabel;

@property (strong, nonatomic) NSString *imgUrl;
@property (strong, nonatomic) NSString *ratingImgUrl;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *reviewCount;
@property (strong, nonatomic) NSString *categories;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *snippetImgUrl;
@property (strong, nonatomic) NSString *snippet;

@end

@implementation InfoViewController

- (id) initWithImgUrl:(NSString *)imgUrl ratingImgUrl:(NSString *)ratingImgUrl name:(NSString *)name reviewCount:(NSNumber *)reviewCount categories:(NSString *)categories address:(NSString *)address phone:(NSString *)phone snippetImgUrl:(NSString *)snippetImgUrl snippet:(NSString *)snippet{
    self = [super init];
    if (self) {
        self.navigationItem.title = name;
        self.imgUrl = imgUrl;
        self.ratingImgUrl = ratingImgUrl;
        self.name = name;
        self.reviewCount = reviewCount;
        self.categories = categories;
        self.address = address;
        self.phone = phone;
        self.snippetImgUrl = snippetImgUrl;
        self.snippet = snippet;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.thumbView setImageWithURL:[NSURL URLWithString:self.imgUrl]];
    [self.ratingView setImageWithURL:[NSURL URLWithString:self.ratingImgUrl]];
    self.businessLabel.text = self.name;
    // fix grammar
    if ([self.reviewCount isEqualToNumber:@1]) {
        self.reviewCountLabel.text = @"1 Review";
    } else {
        self.reviewCountLabel.text = [NSString stringWithFormat:@"%@ Reviews", self.reviewCount];
    }
    self.categoriesLabel.text = self.categories;
    self.addressLabel.text = self.address;
    self.phoneLabel.text = self.phone;
    NSLog(self.phone);
    [self.snippetView setImageWithURL:[NSURL URLWithString:self.snippetImgUrl]];
    self.snippetLabel.text = self.snippet;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
