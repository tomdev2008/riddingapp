//
//  RiddingViewController.m
//  Ridding
//
//  Created by zys on 12-3-19.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "UIImage+UIImage_Retina4.h"
#import "UIColor+XMin.h"

@implementation RiddingViewController
@synthesize bgImageView = _bgImageView;
@synthesize loginBtn = _loginBtn;

//点击新浪微博
- (IBAction)clickSinaWeibo:(id)sender {

  if (self.delegate) {
    [self.delegate didClickLogin:self];
  }
}

#pragma mark - View lifecycle
- (void)viewDidLoad {

  [self.barView.leftButton setTitle:@"取消" forState:UIControlStateNormal];
  [self.barView.leftButton setTitle:@"取消" forState:UIControlStateHighlighted];


  self.bgImageView.frame = CGRectMake(self.view.frame.origin.x, self.barView.frame.size.height, self.view.frame.size.width, SCREEN_HEIGHT_WITHOUT_STATUS_BAR);
  RiddingAppDelegate *delegate = (RiddingAppDelegate *) [[UIApplication sharedApplication] delegate];
  [delegate setUserInfo];
  self.bgImageView.image = [UIImage retina4ImageNamed:@"loginBg" type:@"png"];
  self.loginBtn.backgroundColor = [UIColor getColor:@"f08313"];
  self.loginBtn.layer.cornerRadius = 10;
  self.loginBtn.layer.masksToBounds = YES;
  UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sinalogo.png"]];
  imageView.frame = CGRectMake(20, 0, 38, 38);
  [self.loginBtn addSubview:imageView];
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 130, 38)];
  label.textColor = [UIColor whiteColor];
  label.backgroundColor = [UIColor clearColor];
  label.text = @"新浪微博登录";
  label.textAlignment = UITextAlignmentCenter;
  label.font = [UIFont systemFontOfSize:15];
  [self.loginBtn addSubview:label];
  [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {

  [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {

  [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {

  [super viewWillAppear:animated];


}

- (void)leftBtnClicked:(id)sender {

  RiddingAppDelegate *delegate = [RiddingAppDelegate shareDelegate];
  POSITION position = ((BasicViewController *) delegate.navController.visibleViewController).position;
  if (position == POSITION_RIGHT) {
    [RiddingAppDelegate moveMidNavgation];
  }
  [self dismissModalViewControllerAnimated:YES];
}


- (void)viewDidAppear:(BOOL)animated {

  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {

  [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {

  [super viewDidDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

@end
