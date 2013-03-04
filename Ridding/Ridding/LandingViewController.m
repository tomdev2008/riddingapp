//
//  LandingViewController.m
//  Ridding
//
//  Created by Chenhao Wu on 7/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LandingViewController.h"
#import "UIImage+UIImage_Retina4.h"
@implementation LandingViewController
@synthesize imageList;
@synthesize imageSwipeViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];

  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated {

  imageSwipeViewController.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {

}

- (void)viewWillDisappear:(BOOL)animated {

  imageSwipeViewController.delegate = nil;
}

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

  [super viewDidLoad];
  
  UIImage *img1 = [UIImage retina4ImageNamed:@"screenshot1" type:@"png"] ;
  UIImage *img2 = [UIImage retina4ImageNamed:@"screenshot2" type:@"png"] ;
  UIImage *img3 = [UIImage retina4ImageNamed:@"screenshot3" type:@"png"] ;
  UIImage *img4 = [UIImage retina4ImageNamed:@"screenshot4" type:@"png"] ;
  UIImage *img5 = [UIImage retina4ImageNamed:@"screenshot5" type:@"png"] ;

  NSArray *imgArray = [NSArray arrayWithObjects:img1, img2, img3,img4,img5, nil];
  imageSwipeViewController = [[ImageSwipeViewController alloc] initWithFrameRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+20) ImageArray:imgArray];
  imageSwipeViewController.delegate = self;

 
 
  [self.view addSubview:imageSwipeViewController.view];

}


- (void)viewDidUnload {

  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (void)startApp:(UIGestureRecognizer *)gestureRecognizer {
  [[UIApplication sharedApplication] setStatusBarHidden:NO
                                          withAnimation:UIStatusBarAnimationNone];
  [self dismissModalViewControllerAnimated:NO];
  
}
#pragma mark - imageSwipeViewController delegate
- (void)startApp {

  [self startApp:nil];
}
@end
