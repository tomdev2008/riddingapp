//
//  BasicViewController.m
//  Ridding
//
//  Created by zys on 12-9-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicViewController ()

@end

@implementation BasicViewController
@synthesize barView=_barView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)rightBtnClicked:(id)sender
{
   // [self dismissModalViewControllerAnimated:YES];
}
-(void)leftBtnClicked:(id)sender
{
  if(self.navigationController&&self){
      [self.navigationController popViewControllerAnimated:YES];
  }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestCallBack:) name:kRequestNotification object:nil];
    self.barView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"navbg.png"]];
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

- (void)initHUD{
  if(!_HUD){
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    _HUD.delegate = self;
  }
}
- (void)myTask {
	// Do something usefull in here instead of sleeping ...
	sleep(3000);
}

- (void)requestCallBack:(NSNotification*)noti{
  NSDictionary *category=[noti userInfo];
  int statusCode=[[category objectForKey:@"statusCode"]intValue];
  int code=[[category objectForKey:@"code"]intValue];
  NSLog(@"code%d",code);
  NSLog(@"statusCode%d",statusCode);
  if(code==1){
    return ;
  }
  else if(code == -300) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出活动失败"
                                                    message:@"请确实所有队员退出之后，队长才能退出"
                                                   delegate:self cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    
  }
  else if(code == -310) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出活动失败"
                                                    message:@"活动不存在"
                                                   delegate:self cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    
  }
  else if(code == -302) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出活动失败"
                                                    message:@"用户不在该骑行活动中"
                                                   delegate:self cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    
  }
  else if(code == -202) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"用户没有权限"
                                                    message:@"只有队长才有该权限"
                                                   delegate:self cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    
  }
  else if(code == -100) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"解析失败"
                                                    message:@"数据解析失败，请重新发送请求"
                                                   delegate:self cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    
  }
  else if(statusCode!=200){
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"连接服务器失败"
                                                    message:@"连接服务器失败，请检查当前网络"
                                                   delegate:self cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
  }else {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未知错误"
                                                    message:@"未知错误"
                                                   delegate:self cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
  }
  [MobClick event:@"2012112002" attributes:[[NSDictionary alloc] initWithObjectsAndKeys:category,@"category", nil]];
  return;
}
@end
