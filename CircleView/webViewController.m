//
//  webViewController.m
//  spectraSnapp
//
//  Created by james collinsworth on 8/27/12.
//  Copyright (c) 2012 Breakthrough Technologies, LLC. All rights reserved.
//

#import "webViewController.h"
#import "BBAppDelegate.h"
#import "BBViewController.h"



@interface webViewController ()

@end

@implementation webViewController
@synthesize webView = _webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *urlString = [[APPDELEGATE selectedMenuData] objectForKey:KEY_URL];
    NSString *path = [[NSBundle mainBundle] pathForResource:urlString ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    int height = self.navigationController.navigationBar.frame.size.height;
    int width = self.navigationController.navigationBar.frame.size.width;
    
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width-100, height)];
    navLabel.backgroundColor = [UIColor clearColor];
    navLabel.textColor = [UIColor whiteColor];
    navLabel.shadowColor = [UIColor darkGrayColor];
    //navLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    navLabel.font = [UIFont fontWithName:@"Futura-Medium" size:28.0];
    navLabel.textAlignment = NSTextAlignmentCenter;
    navLabel.text = [[APPDELEGATE selectedMenuData] objectForKey:KEY_TITLE];
    self.navigationItem.titleView = navLabel;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return UIInterfaceOrientationIsPortrait(interfaceOrientation);
    return YES;
}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSLog(@"willRotateToInterfaceOrientation");
}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    
    return YES;
}

@end
