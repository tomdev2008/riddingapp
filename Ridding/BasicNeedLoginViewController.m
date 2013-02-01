//
//  BasicNeedLoginViewController.m
//  Ridding
//
//  Created by zys on 12-12-23.
//
//

#import "BasicNeedLoginViewController.h"

@interface BasicNeedLoginViewController ()

@end

@implementation BasicNeedLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {

  [super viewDidLoad];
  // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {

  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)showLoginAlertView {

  UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您还没登录噢" message:@"该操作需要登录后才能执行" delegate:self cancelButtonTitle:@"暂时不登录" otherButtonTitles:@"登录", nil];
  [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

  if (alertView.cancelButtonIndex != buttonIndex) {
    [self presentLoginView];
  }
}

- (void)presentLoginView {

  RiddingViewController *riddingViewController = [[RiddingViewController alloc] init];
  riddingViewController.delegate = self;
  [self presentModalViewController:riddingViewController animated:YES];
}

#pragma mark - RiddingViewController delegate
- (void)didClickLogin:(RiddingViewController *)controller {

  [controller dismissModalViewControllerAnimated:NO];
  QQNRSourceLoginViewController *loginController = [[QQNRSourceLoginViewController alloc] init];
  loginController.delegate = self;
  [self presentModalViewController:loginController animated:YES];
}

#pragma mark - RiddingViewController delegate
- (void)didFinishLogined:(QQNRSourceLoginViewController *)controller {

  [controller dismissModalViewControllerAnimated:YES];
}

@end
