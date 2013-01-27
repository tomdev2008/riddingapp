//
//  TutorialViewController.m
//  Ridding
//
//  Created by Wu Chenhao on 5/8/12.
//  Copyright (c) 2012 MicroStrategy. All rights reserved.
//

#import "TutorialViewController.h"

@implementation TutorialViewController

@synthesize tutorialImage;
@synthesize imageList;

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

  self.navigationController.navigationBarHidden = YES;
  [super viewWillAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {

  [super viewWillDisappear:animated];
}

- (void)viewDidLoad {

  [super viewDidLoad];
  UIImage *img1 = [UIImage imageNamed:@"help1.png"];
  UIImage *img2 = [UIImage imageNamed:@"help2.png"];
  UIImage *img3 = [UIImage imageNamed:@"help3.png"];

  NSArray *imgArray = [NSArray arrayWithObjects:img1, img2, img3, nil];
  imageSwipeViewController = [[ImageSwipeViewController alloc] initWithFrameRect:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) ImageArray:imgArray];
  imageSwipeViewController.delegate = self;
  CGFloat height = SCREEN_HEIGHT;
  UIImageView *startButton = [[UIImageView alloc] initWithFrame:CGRectMake(900, height * 1.0 / 2.0 - (25 / 2), 25, 25)];
  startButton.image = [UIImage imageNamed:@"bf.png"];

  startButton.userInteractionEnabled = YES;
  UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
  [startButton addGestureRecognizer:singleTap];

  [self.view addSubview:imageSwipeViewController.view];
  [imageSwipeViewController.scrollView addSubview:startButton];

}

- (void)back {
  // Tell the controller to go back
  [self dismissModalViewControllerAnimated:NO];
  //[self.navigationController popViewControllerAnimated:YES];
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


#pragma mark - imageSwipeViewController delegate
- (void)startApp {

  [self back];
}
@end
