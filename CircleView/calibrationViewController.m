//
//  calibrationViewController.m
//  spectraSnapp
//
//  Created by james collinsworth on 8/28/12.
//  Copyright (c) 2012 Integral Development Corporation. All rights reserved.
//

#import "calibrationViewController.h"
#import "BBAppDelegate.h"
#import "BBViewController.h"

@interface calibrationViewController ()

@end

@implementation calibrationViewController

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
    NSString *kAviaryAPIKey = @"c412254e31ef9365";
    NSString *kAviarySecret = @"53352286e9d322ed";
    
    
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width-100, height)];
    navLabel.backgroundColor = [UIColor clearColor];
    navLabel.textColor = [UIColor whiteColor];
    navLabel.shadowColor = [UIColor darkGrayColor];
    //navLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    navLabel.font = [UIFont fontWithName:@"Futura-Medium" size:28.0];
    navLabel.textAlignment = NSTextAlignmentCenter;
    navLabel.text = [[APPDELEGATE selectedMenuData] objectForKey:KEY_TITLE];
    self.navigationItem.titleView = navLabel;
    
    // testing code for the image editing framework
    /*
    NSArray *tools = @[kAFCrop, kAFOrientation, kAFContrast, kAFBrightness, kAFSaturation];
    AFPhotoEditorController *editorController = [[AFPhotoEditorController alloc] initWithImage:[APPDELEGATE sampleImage] options:[NSDictionary dictionaryWithObject:tools forKey:kAFPhotoEditorControllerToolsKey]];
    editorController.title = @"Calibration";
    [editorController setDelegate:self];
    [self presentModalViewController:editorController animated:YES];
    NSLog(@"%@", self.presentedViewController);
     */
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{[AFPhotoEditorController setAPIKey:kAviaryAPIKey secret:kAviarySecret];
    });
    
    AFPhotoEditorController *editorController = [[AFPhotoEditorController alloc] initWithImage:[APPDELEGATE sampleImage]];
    [AFPhotoEditorCustomization setToolOrder:@[kAFCrop, kAFOrientation, kAFSharpness, kAFEffects]];
    [editorController setDelegate:self];
    [self presentViewController:editorController animated:YES completion:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    NSLog(@"calibrationViewController-viewDidUnload");
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    //return UIInterfaceOrientationIsPortrait(interfaceOrientation);
    return YES;
}

- (void)photoEditor:(AFPhotoEditorController *)editor finishedWithImage:(UIImage *)image
{
    // Handle the result image here
    // Save image to photostream and to global
    [APPDELEGATE setSampleImage:image];
    UIImageWriteToSavedPhotosAlbum(image,
                                   self,
                                   @selector(image:finishedSavingWithError:contextInfo:),
                                   nil);

    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)photoEditorCanceled:(AFPhotoEditorController *)editor
{
    // Handle cancelation here
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) viewWillAppear:(BOOL)animated  {
    NSLog(@"viewDidAppear");
}

@end
