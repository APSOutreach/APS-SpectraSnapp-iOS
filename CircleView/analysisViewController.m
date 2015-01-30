//
//  cameraViewController.m
//  spectraSnapp
//
//  Created by james collinsworth on 8/27/12.
//  Copyright (c) 2012 Breakthrough Technologies, LLC. All rights reserved.
//

#import "analysisViewController.h"
#import "BBAppDelegate.h"
#import "BBViewController.h"


@interface analysisViewController ()

@end

@implementation analysisViewController
@synthesize spectraLibrary = _spectraLibrary;

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
    
    imageView.image = [APPDELEGATE sampleImage];
    spectraLibrary = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"spectra" ofType:@"plist"]];
    NSDictionary *spectraInfo = [spectraLibrary objectAtIndex:[APPDELEGATE analysisImageIndex]];
    spectraTitle.text = [spectraInfo objectForKey:@"title"];
    spectraDescription.text = [spectraInfo objectForKey:@"description"];
    spectraImageView.image = [UIImage imageNamed:[spectraInfo objectForKey:@"image"]];    
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

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
 
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
        // in landscape mode we display only the two spectra and buttons so
        // hide/show controls as necessary
        
        
    } else {
        
    }
}

- (void) previousSpectra:(id)sender
{
    NSInteger spectraLibrarySize = [spectraLibrary count];
    
    if ([APPDELEGATE analysisImageIndex] == 0) {
            [APPDELEGATE setAnalysisImageIndex:spectraLibrarySize-1];
    } else {
            [APPDELEGATE setAnalysisImageIndex:[APPDELEGATE analysisImageIndex]-1];
    }
    
    NSDictionary *spectraInfo = [spectraLibrary objectAtIndex:[APPDELEGATE analysisImageIndex]];
    spectraTitle.text = [spectraInfo objectForKey:@"title"];
    spectraDescription.text = [spectraInfo objectForKey:@"description"];
    spectraImageView.image = [UIImage imageNamed:[spectraInfo objectForKey:@"image"]];
    [APPDELEGATE setAnalysisImage:spectraImageView.image];
    //NSLog(@"%@", spectraTitle.text);
}

- (void) nextSpectra:(id)sender
{
    NSInteger spectraLibrarySize = [spectraLibrary count];
    
    if ([APPDELEGATE analysisImageIndex] == spectraLibrarySize-1) {
        [APPDELEGATE setAnalysisImageIndex:0];
    } else {
        [APPDELEGATE setAnalysisImageIndex:[APPDELEGATE analysisImageIndex]+1];
    }
    
    NSDictionary *spectraInfo = [spectraLibrary objectAtIndex:[APPDELEGATE analysisImageIndex]];
    spectraTitle.text = [spectraInfo objectForKey:@"title"];
    spectraDescription.text = [spectraInfo objectForKey:@"description"];
    spectraImageView.image = [UIImage imageNamed:[spectraInfo objectForKey:@"image"]];
    [APPDELEGATE setAnalysisImage:spectraImageView.image];
}

@end
