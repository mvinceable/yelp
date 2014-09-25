//
//  InfoViewController.h
//  yelp
//
//  Created by Vince Magistrado on 9/24/14.
//  Copyright (c) 2014 Vince Magistrado. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController

- (id)initWithImgUrl:(NSString *)imgUrl ratingImgUrl:(NSString *)ratingImgUrl name:(NSString *)name reviewCount:(NSNumber *)reviewCount categories:(NSString *)categories address:(NSString *)address phone:(NSString *)phone snippetImgUrl:(NSString *)snippetImgUrl snippet:(NSString *)snippet;

@end
