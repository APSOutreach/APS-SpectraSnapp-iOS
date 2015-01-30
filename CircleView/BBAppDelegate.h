//
//  BBAppDelegate.h
//  CircleView
//
//  Created by Bharath Booshan on 6/8/12.
//  Copyright (c) 2012 Bharath Booshan Inc All rights reserved.
//

#import <UIKit/UIKit.h>
#import "global.h"

@class BBViewController;

@interface BBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BBViewController *viewController;

@property (strong, nonatomic) UINavigationController *navController;

@property (strong, nonatomic) UIImage *sampleImage;             // currently selected spectra image
@property (strong, nonatomic) UIImage *analysisImage;

@property (nonatomic, assign) NSInteger analysisImageIndex;     // current/last selected analysis image (0 means first/default)

@property (strong, nonatomic) NSDictionary *selectedMenuData;

@property (nonatomic, assign) NSInteger menuIndex;  //current/last select menu index item

@end
