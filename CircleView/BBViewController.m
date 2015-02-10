//
//  BBViewController.m
//  CircleView
//
//  Created by Bharath Booshan on 6/8/12.
//  Copyright (c) 2012 Bharath Booshan Inc. All rights reserved.
//

#import "BBViewController.h"
#import "BBCell.h"
#import <QuartzCore/QuartzCore.h>
#import "BBAppDelegate.h"
#import "webViewController.h"
#import "cameraViewController.h"
#import "calibrationViewController.h"
#import "analysisViewController.h"
#import <AviarySDK/AviarySDK.h>
//#import "AFPhotoEditorController.h"

@interface BBViewController ()
-(void)setupShapeFormationInVisibleCells;
-(void)loadDataSource;
-(float)getDistanceRatio;
@end

@implementation BBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [mTableView setBackgroundColor:[UIColor clearColor]];
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.opaque=NO;
    mTableView.showsHorizontalScrollIndicator=NO;
    mTableView.showsVerticalScrollIndicator=NO;
    
    int height = self.navigationController.navigationBar.frame.size.height;
    int width = self.navigationController.navigationBar.frame.size.width;
    
    UILabel *navLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    navLabel.backgroundColor = [UIColor clearColor];
    navLabel.textColor = [UIColor whiteColor];
    navLabel.shadowColor = [UIColor lightGrayColor];
    navLabel.font = [UIFont fontWithName:@"Futura-Medium" size:28.0];
    navLabel.textAlignment = NSTextAlignmentCenter;
    navLabel.text = @"SpectraSnapp";
    self.navigationItem.titleView = navLabel;
    
    //self.navigationItem.title = @"SpectraSnapp";
    
    [self loadDataSource];
    
    UIDevice *device = [UIDevice currentDevice];					//Get the device object
	[device beginGeneratingDeviceOrientationNotifications];			//Tell it to start monitoring the accelerometer for orientation
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];	//Get the notification centre for the app
	[nc addObserver:self											//Add yourself as an observer
		   selector:@selector(orientationChanged:)
			   name:UIDeviceOrientationDidChangeNotification
			 object:device];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Set title
    self.navigationItem.title=@"Spectrum Snapp";
    UIImage *backgroundImage = [UIImage imageNamed:@"CustomNavBG.png"];
    // need conditional logic to change navigation bar image, changed in ios5
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    } else {
        [self.navigationController.navigationBar insertSubview:[[UIImageView alloc] initWithImage:backgroundImage] atIndex:1];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    
    // Set title
    self.navigationItem.title=@"Back";
}

//********** ORIENTATION CHANGED **********
- (void)orientationChanged:(NSNotification *)note
{
    
    UIInterfaceOrientation iOrientation = [UIApplication sharedApplication].statusBarOrientation;
    UIDeviceOrientation dOrientation = [UIDevice currentDevice].orientation;

    bool landscape;
    
    if (dOrientation == UIDeviceOrientationUnknown || dOrientation == UIDeviceOrientationFaceUp || dOrientation == UIDeviceOrientationFaceDown) {
        // If the device is laying down, use the UIInterfaceOrientation based on the status bar.
        landscape = UIInterfaceOrientationIsLandscape(iOrientation);
    } else {
        // If the device is not laying down, use UIDeviceOrientation.
        landscape = UIDeviceOrientationIsLandscape(dOrientation);
        
        // There's a bug in iOS!!!! http://openradar.appspot.com/7216046
        // So values needs to be reversed for landscape!
        if (dOrientation == UIDeviceOrientationLandscapeLeft) iOrientation = UIInterfaceOrientationLandscapeRight;
        else if (dOrientation == UIDeviceOrientationLandscapeRight) iOrientation = UIInterfaceOrientationLandscapeLeft;
        
        else if (dOrientation == UIDeviceOrientationPortrait) iOrientation = UIInterfaceOrientationPortrait;
        else if (dOrientation == UIDeviceOrientationPortraitUpsideDown) iOrientation = UIInterfaceOrientationPortraitUpsideDown;
    }
    
    if (landscape) {
        mSpectrumView = [[UIView alloc] init];
        [mSpectrumView setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];
        
        int flip = 1;
        if (dOrientation == UIDeviceOrientationLandscapeLeft) {
            flip = 1;
        } else {
            flip = -1;
        }
        
        if ([APPDELEGATE sampleImage] == nil) {
            UILabel *sampleLabel = [[UILabel alloc] initWithFrame:CGRectMake(1,159,159,159)];
            [sampleLabel setBackgroundColor:[UIColor blackColor]];
            [sampleLabel setTextColor:[UIColor whiteColor]];
            [sampleLabel setTransform:CGAffineTransformMakeRotation(flip*M_PI / 2)];
            [sampleLabel setText:@"no sample yet"];
            [mSpectrumView addSubview:sampleLabel];
        }
        else
        {
            UIImage *sampleImagePortrait = [APPDELEGATE sampleImage];
            UIImage *sampleImageLandscape;
            if (flip == -1) {
                sampleImageLandscape = [[UIImage alloc] initWithCGImage:sampleImagePortrait.CGImage scale:sampleImageLandscape.scale orientation:UIImageOrientationLeft];
            } else {
                sampleImageLandscape = [[UIImage alloc] initWithCGImage:sampleImagePortrait.CGImage scale:sampleImageLandscape.scale orientation:UIImageOrientationRight];
            }
            UIImageView *imageViewSample = [[UIImageView alloc] initWithImage:sampleImageLandscape];
            imageViewSample.frame = CGRectMake(1, 1, 159, 479);
            [mSpectrumView addSubview:imageViewSample];
        }
        
        
        if ([APPDELEGATE analysisImage] == nil) {
            UILabel *analysisLabel = [[UILabel alloc] initWithFrame:CGRectMake(161,159,159,159)];
            [analysisLabel setBackgroundColor:[UIColor blackColor]];
            [analysisLabel setTextColor:[UIColor whiteColor]];
            [analysisLabel setTransform:CGAffineTransformMakeRotation(flip*M_PI / 2)];
            [analysisLabel setText:@"no analysis yet"];
            [mSpectrumView addSubview:analysisLabel];
        }
        else
        {
            UIImage *analysisImagePortrait = [APPDELEGATE analysisImage];
            UIImage *analysisImageLandscape;
            if (flip == -1) {
                    analysisImageLandscape = [[UIImage alloc] initWithCGImage:analysisImagePortrait.CGImage scale:1.0 orientation:UIImageOrientationLeft];
            } else {
                    analysisImageLandscape = [[UIImage alloc] initWithCGImage:analysisImagePortrait.CGImage scale:1.0 orientation:UIImageOrientationRight];
            }
            
            UIImageView *imageViewAnalysis = [[UIImageView alloc] initWithImage:analysisImageLandscape];
            imageViewAnalysis.frame = CGRectMake(161, 1, 319, 479);
            [mSpectrumView addSubview:imageViewAnalysis];
        }
        // show landscape spectra view
        [self.view addSubview:mSpectrumView];        
    } else {
        // remove landscape spectra view
        [mSpectrumView removeFromSuperview];
    }

	//NSLog(@"Orientation has changed: %d", [[note object] orientation]);
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //we need to update the cells as the table might have changed its dimensions after rotation
    [self setupShapeFormationInVisibleCells];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    //update the cells to form the circle shape
    [self setupShapeFormationInVisibleCells];
    [super viewDidAppear:animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mDataSource count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *test = @"table";
    BBCell *cell = (BBCell*)[tableView dequeueReusableCellWithIdentifier:test];
    if( !cell )
    {
        cell = [[BBCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:test];
        
    }
    NSDictionary *info = [mDataSource objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    [cell setCellTitle:[info objectForKey:KEY_TITLE]];
    [cell setIcon:[info objectForKey:KEY_IMAGE]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *vcName = [[mDataSource objectAtIndex:[indexPath row]] objectForKey:KEY_VIEW];
    NSString *vcTitle = [[mDataSource objectAtIndex:[indexPath row]] objectForKey:KEY_TITLE];
    NSString *vcURL = [[mDataSource objectAtIndex:[indexPath row]] objectForKey:KEY_URL];
    

    [self.navigationItem.backBarButtonItem setStyle:UIBarButtonItemStyleBordered];
    
    // save the selection index and dictionary data as global data.
    [APPDELEGATE setMenuIndex:[indexPath row]];
    [APPDELEGATE setSelectedMenuData:[mDataSource objectAtIndex:[indexPath row]]];
    

    
    if ([vcName isEqualToString:@"webLinkController"])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:vcURL]];
    }
    else if ([vcName isEqualToString:@"webViewController"])
    {
        webViewController *webVc;
        webVc = [[webViewController alloc] initWithNibName:vcName bundle:nil];
        webVc.navigationItem.title = vcTitle;
        [self.navigationController pushViewController:webVc animated:YES];
    }
    else if ([vcName isEqualToString:@"cameraViewController"])
    {
        cameraViewController *cameraVc;
        cameraVc = [[cameraViewController alloc] initWithNibName:vcName bundle:nil];
        cameraVc.navigationItem.title = vcTitle;
        [self.navigationController pushViewController:cameraVc animated:YES];
    }
    else if ([vcName isEqualToString:@"calibrationViewController"])
    {
        if ([APPDELEGATE sampleImage] == nil) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Instrument Error"
                                  message: @"Need to sample a spectrum before calibration"
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        } else {
            calibrationViewController *calibrationVc;
            calibrationVc = [[calibrationViewController alloc] initWithNibName:vcName bundle:nil];
            calibrationVc.navigationItem.title = vcTitle;
            [self.navigationController pushViewController:calibrationVc animated:YES];
        }
    }
    else if ([vcName isEqualToString:@"analysisViewController"])
    {
        if ([APPDELEGATE sampleImage] == nil) {
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Instrument Error"
                                  message: @"Need to sample a spectrum before analysis"
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        } else {
            analysisViewController *analysisVc;
            analysisVc = [[analysisViewController alloc] initWithNibName:vcName bundle:nil];
            analysisVc.navigationItem.title = vcTitle;
            [self.navigationController pushViewController:analysisVc animated:YES];
        }
    }
    
   // [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



- (float)getDistanceRatio
{
    return (UIDeviceOrientationIsLandscape([[UIDevice currentDevice] orientation]) ? VERTICAL_RADIUS_RATIO : HORIZONTAL_RADIUS_RATIO);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self setupShapeFormationInVisibleCells];
    float totalHeight = [mTableView rowHeight] * [mTableView.dataSource tableView:(UITableView*)scrollView numberOfRowsInSection:0]-14;
    if( scrollView.contentOffset.y >= totalHeight )
    {
        [scrollView scrollRectToVisible:CGRectMake(0.0, 0.0, 320.0, 80.0) animated:NO];
        
    } 
       
}

//The heart of this app.
//this function iterates through all visible cells and lay them in a circular shape
- (void)setupShapeFormationInVisibleCells
{
    NSArray *indexpaths = [mTableView indexPathsForVisibleRows];
    float shift = ((int)mTableView.contentOffset.y % (int)mTableView.rowHeight);  
    int totalVisibleCells =[indexpaths count];
    float y = 0.0;
    //float radius = mTableView.frame.size.height/2.0f;
    float radius = mTableView.contentSize.height/2.0f;
    
    float xRadius = radius;
    
    for( NSUInteger index =0; index < totalVisibleCells; index++ )
    {
        BBCell *cell = (BBCell*)[mTableView cellForRowAtIndexPath:[ indexpaths objectAtIndex:index]];
        CGRect frame = cell.frame;
        //we get the yPoint on the circle of this Cell
        //jpc - hack to fix first menu item position
        //TODO: better fix is to upgrade circlecell framework version, but that would require refactoring
        if (index == 0) {
            y = (radius-(1*mTableView.rowHeight/2.6) );//ideal yPoint if the scroll offset is zero
        } else {
            y = (radius-(index*mTableView.rowHeight) );//ideal yPoint if the scroll offset is zero
        }
        y+=shift;//add the scroll offset
        
        //We can find the x Point by finding the Angle from the Ellipse Equation of finding y
        //i.e. Y= vertical_radius * sin(t )
        // t= asin(Y / vertical_radius) or asin = sin inverse
        float angle = asinf(y/(radius));
        
        if( CIRCLE_DIRECTION_RIGHT )
        {
            angle =  angle + M_PI;
        }
        
        //Apply Angle in X point of Ellipse equation
        //i.e. X = horizontal_radius * cos( t )
        //here horizontal_radius would be some percentage off the vertical radius. percentage is defined by HORIZONTAL_RADIUS_RATIO
        //HORIZONTAL_RADIUS_RATIO of 1 is equal to circle
        float x = (floorf(xRadius*[self getDistanceRatio])) * cosf(angle );

        if( CIRCLE_DIRECTION_RIGHT )
        {
            x = x + HORIZONTAL_TRANSLATION*-2;// we have to shift the center of the circle toward the right
        }
        else {
            x = x + HORIZONTAL_TRANSLATION;
        }
        
        frame.origin.x = x ;
        if( !isnan(x))
        {
            cell.frame = frame;
        }
    }
}

//read the data from the plist and alos the image will be masked to form a circular shape
- (void)loadDataSource
{
    NSMutableArray *dataSource = [[NSMutableArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"]];
    
    mDataSource = [[NSMutableArray alloc] init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //generate image clipped in a circle
        for( NSDictionary * dataInfo in dataSource )
        {
            NSMutableDictionary *info = [dataInfo mutableCopy];
            UIImage *image = [UIImage imageNamed:[info objectForKey:KEY_IMAGE_NAME]];
            UIImage *finalImage = nil;
            UIGraphicsBeginImageContext(image.size);
            {
                CGContextRef ctx = UIGraphicsGetCurrentContext();
                CGAffineTransform trnsfrm = CGAffineTransformConcat(CGAffineTransformIdentity, CGAffineTransformMakeScale(1.0, -1.0));
                trnsfrm = CGAffineTransformConcat(trnsfrm, CGAffineTransformMakeTranslation(0.0, image.size.height));
                CGContextConcatCTM(ctx, trnsfrm);
                CGContextBeginPath(ctx);
                CGContextAddEllipseInRect(ctx, CGRectMake(0.0, 0.0, image.size.width, image.size.height));
                CGContextClip(ctx);
                CGContextDrawImage(ctx, CGRectMake(0.0, 0.0, image.size.width, image.size.height), image.CGImage);
                finalImage = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
            }
            [info setObject:finalImage forKey:KEY_IMAGE];
            
            [mDataSource addObject:info];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [mTableView reloadData];
            [self setupShapeFormationInVisibleCells];
        });
    });
}

@end
