//
//  BasicViewController.m
//  Ridding
//
//  Created by zys on 12-9-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BasicViewController.h"
#import "UIColor+XMin.h"
#import "RiddingViewController.h"
#import "SVProgressHUD.h"
#define kTriggerOffSet      50.0f
#define kSensitiveTrigger   5.0f
#define kTagOverView        10098
@interface BasicViewController ()

@end

@implementation BasicViewController
@synthesize barView=_barView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    
  }
  return self;
}

-(void)rightBtnClicked:(id)sender
{
  // [self dismissModalViewControllerAnimated:YES];
}
-(void)leftBtnClicked:(id)sender
{
  if(self.hasLeftView){
    [self showLeftView];
  }else if(self.navigationController){
    [self.navigationController popViewControllerAnimated:YES];
  }
}


- (void)showLeftView{
  if (_position==POSITION_RIGHT||_position==POSITION_MID) {
    [self restoreViewLocation];
  }else{
    [RiddingAppDelegate moveMidNavgation];
    [self createHideView];
  }
}


- (void)viewDidLoad
{
  self.requestUtil=[[RequestUtil alloc]init];
  self.requestUtil.delegate=self;
  [super viewDidLoad];
  self.barView.backgroundColor=[UIColor getColor:@"f8f7f2"];
  self.barView.delegate=self;
  // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)myTask {
	sleep(3000);
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
  
	if (leftViewControllerDisabled && rightViewControllerDisabled) {
		return;
	}
  if(!self.hasLeftView){
    return;
  }
  UITouch *touch=[touches anyObject];
  
  touchBeganPoint = [touch locationInView:[[UIApplication sharedApplication] keyWindow]];
  
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
  if(!self.hasLeftView){
    return;
  }
  UITouch *touch = [touches anyObject];
  
  CGPoint touchPoint = [touch locationInView:[[UIApplication sharedApplication] keyWindow]];
  
  
  
  CGFloat xOffSet = touchPoint.x - touchBeganPoint.x;
  
  
  
  
  if (xOffSet < 0) {
    if (rightViewControllerDisabled) {
      [self touchesCancelled:touches withEvent:event];
      return;
      
    }else{
      [RiddingAppDelegate moveLeftNavgation];
    }
    
  }
  
  else if (xOffSet > 0) {
    if (leftViewControllerDisabled) {
      [self touchesCancelled:touches withEvent:event];
      return;
    }else {
      [RiddingAppDelegate moveMidNavgation];
    }
    
  }
  
  
  if(xOffSet<0){
    //不移动到右边
    return;
  }
  
  self.navigationController.view.frame = CGRectMake(xOffSet,
                                                    
                                                    self.navigationController.view.frame.origin.y,
                                                    
                                                    self.navigationController.view.frame.size.width,
                                                    
                                                    self.navigationController.view.frame.size.height);
  
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  if(!self.hasLeftView){
    return;
  }
  if (leftViewControllerDisabled && rightViewControllerDisabled) {
		return;
	}
  
  UITouch *endPoint = [touches anyObject];
	CGPoint touchPoint = [endPoint locationInView:[[UIApplication sharedApplication] keyWindow]];
  
  CGFloat xOffSet = touchPoint.x - touchBeganPoint.x;
  
  if (abs(xOffSet) < kSensitiveTrigger) {
    return;
  }
  
  if (self.navigationController.view.frame.origin.x < kTriggerOffSet){
    [RiddingAppDelegate moveLeftNavgation];
    
  }
  
  // animate to right side
  
  else if (self.navigationController.view.frame.origin.x >= kTriggerOffSet){
    [RiddingAppDelegate moveMidNavgation];
    [self createHideView];
  }
  
  // reset
  
  else
  {
    
  }
  
}

- (void)createHideView{
  UIControl *overView = [[UIControl alloc] init];
  overView.tag = kTagOverView;
  overView.backgroundColor = [UIColor clearColor];
  //overView.frame = self.navigationController.view.frame;
  overView.frame = self.navigationController.view.bounds;
  [overView addTarget:self action:@selector(restoreViewLocation) forControlEvents:UIControlEventTouchDown];
  [self.view addSubview:overView];
  
}


- (void)restoreViewLocation {
    UINavigationController *navController=[RiddingAppDelegate shareDelegate].navController;
    UIControl *overView = (UIControl *)[[navController view] viewWithTag:kTagOverView];
    if (overView) {
      [overView removeFromSuperview];
    }
    NSLog(@"1234");
    [RiddingAppDelegate moveLeftNavgation];
}

#pragma mark - TouchEnabledTableViewDelegate
- (void)onTableView:(TouchEnabledTableView *)tableView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[tableView setScrollEnabled:NO];
	[self touchesBegan:touches withEvent:event];
}

- (void)onTableView:(TouchEnabledTableView *)tableView touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[self touchesMoved:touches withEvent:event];
}

- (void)onTableView:(TouchEnabledTableView *)tableView touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
  
	[self touchesEnded:touches withEvent:event];
	[tableView setScrollEnabled:YES];
}

- (void)onTableView:(TouchEnabledTableView *)tableView touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event {
	
	// do nothing
	[tableView setScrollEnabled:YES];
}
#pragma mark requestUtil delegate
-(void)asyncReturnDic:(NSDictionary*)dic{
  //delegate实现
}
-(void)asyncReturnArray:(NSArray*)array{
  //delegate实现
}

-(void)checkServerError:(RequestUtil *)request code:(int)code asiRequest:(ASIHTTPRequest*)asiRequest{
  if([asiRequest responseStatusCode]!=200){
    [SVProgressHUD showErrorWithStatus:@"服务器请求失败"];
    return;
  }
  
  NSString *message=[self returnErrorMessage:code];
  if(message){
    [SVProgressHUD showErrorWithStatus:message];
  }
}

- (NSString*)returnErrorMessage:(int)code{
  if(code==kServerSuccessCode){
    return nil;
  }else if(code == -300) {
    return @"请确实所有队员退出之后，队长才能退出";
  }else if(code == -301) {
    return @"活动不存在";
  }else if(code == -302) {
    return @"用户不在该骑行活动中";
  }else if(code == -202) {
    return @"只有队长才有该权限";
  }else if(code == -100) {
    return @"数据解析失败，请重新发送请求";
  }else if(code==-310){
    return @"每个人只有一次机会噢";
  }else if(code==-311){
    return @"对于自己的活动无法执行";
  }else if(code==-444){
    return @"登陆信息失效，请重新登陆";
  }
  [MobClick event:@"2012112002"];
  return @"操作失败";
}

- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  [SVProgressHUD dismiss];
}


@end
