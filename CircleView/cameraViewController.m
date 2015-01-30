//
//  sampleViewController.m
//  spectraSnapp
//
//  Created by james collinsworth on 8/28/12.
//  Copyright (c) 2012 Breakthrough Technologies, LLC. All rights reserved.
//

#import "cameraViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "BBAppDelegate.h"
#import "BBViewController.h"


@interface cameraViewController ()

@end

@implementation cameraViewController
//@synthesize imageView = _imageView;

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
    
}
-(void)viewDidAppear:(BOOL)animated
{
    imageView.image = [APPDELEGATE sampleImage];
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

- (void) useCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = NO;
        [self presentModalViewController:imagePicker animated:YES];
        newMedia = YES;
    }
}

- (void) useCameraRoll
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = NO;
        [self presentModalViewController:imagePicker animated:YES];
        newMedia = NO;
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    [self dismissModalViewControllerAnimated:YES];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
        
        imageView.image = image;
        
        if (newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
        
        // save selected image to global
        [APPDELEGATE setSampleImage:image];

    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
		// Code here to support video if enabled
	}
    
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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissModalViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)backButtonPressed:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    NSLog(@"willShowViewController");
    UIImage *backgroundImage = [UIImage imageNamed:@"CustomNavBG.png"];
    // need conditional logic to change navigation bar image, changed in ios5
    if ([navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    } else {
        [navigationController.navigationBar insertSubview:[[UIImageView alloc] initWithImage:backgroundImage] atIndex:1];
    }
}

@end
