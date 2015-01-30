//
//  cameraViewController.h
//  spectraSnapp
//
//  Created by james collinsworth on 8/27/12.
//  Copyright (c) 2012 Breakthrough Technologies, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "global.h"
#import "BBAppDelegate.h"

@interface analysisViewController : UIViewController
{
    NSArray *spectraLibrary;
    
    IBOutlet UIImageView *imageView;
    IBOutlet UIImageView *spectraImageView;
    IBOutlet UILabel *spectraTitle;
    IBOutlet UITextView *spectraDescription;
}
@property (nonatomic, retain) NSArray *spectraLibrary;

-(IBAction)previousSpectra:(id)sender;
-(IBAction)nextSpectra:(id)sender;

@end
