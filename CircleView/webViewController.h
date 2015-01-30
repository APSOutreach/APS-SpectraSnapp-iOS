//
//  webViewController.h
//  spectraSnapp
//
//  Created by james collinsworth on 8/27/12.
//  Copyright (c) 2012 Breakthrough Technologies, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "global.h"
//#import "BBAppDelegate.h"
//#import "BBViewController.m"

@interface webViewController : UIViewController 
{
    UIWebView *webView;
}
@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
