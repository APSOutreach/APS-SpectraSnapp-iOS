//
//  sampleViewController.h
//  spectraSnapp
//
//  Created by james collinsworth on 8/28/12.
//  Copyright (c) 2012 Breakthrough Technologies, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "global.h"
#import "BBAppDelegate.h"

@interface cameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    IBOutlet UIImageView *imageView;
    BOOL    newMedia;
}
//@property (nonatomic, retain) UIImageView *imageView;
- (IBAction)useCamera;
- (IBAction)useCameraRoll;
@end
