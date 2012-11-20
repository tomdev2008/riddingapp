//
//  SourceLoginViewController.m
//  Ridding
//
//  Created by zys on 12-6-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "QQNRSourceLoginViewController.h"
#import "SqlUtil.h"
#import "ASIFormDataRequest.h"
#import "UserMap.h"
#import "Reachability.h"
#import "QQNRFeedViewController.h"
#import "SinaApiRequestUtil.h"
#import "UIColor+XMin.h"
@interface QQNRSourceLoginViewController ()

@end

@implementation QQNRSourceLoginViewController
@synthesize web=_web;
@synthesize activityView=_activityView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.barView.titleLabel.text=@"登录";
  NSString *OAuthUrl=[NSString stringWithFormat:@"%@/bind/mobilesinabind/",QIQUNARHOME];
  NSString *url = [[NSString alloc]initWithString:OAuthUrl];
  NSURLRequest *loginRequest = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
  [self.web loadRequest:loginRequest];
  _sendWeiBo=TRUE;
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  if(![prefs objectForKey:@"recomApp"]){
    [self setFollowView];    
  }
  
  

}

-(void)leftBtnClicked:(id)sender
{
  if (self.navigationController) {
    [self.navigationController popViewControllerAnimated:YES];
  }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait||interfaceOrientation ==UIInterfaceOrientationPortraitUpsideDown);
}


- (void)viewDidUnload
{
  [super viewDidUnload];
}
- (void)viewWillAppear:(BOOL)animated
{
  self.navigationController.navigationBarHidden = YES;
  [super viewWillAppear:animated];
  
}
- (void)viewWillDisappear:(BOOL)animated
{
  self.web.delegate=nil;
  [super viewWillDisappear:animated];
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
  if(!self.activityView){
    self.activityView=[[ActivityView alloc]init:@"加载中..." lat:self.view.frame.size.width/2 log:self.view.frame.size.height/2];
    [self.view addSubview:self.activityView];
  }
  [self.activityView setHidden:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
  [self.activityView setHidden:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
  NSString  *queryStr=[[request URL] query];
  NSDictionary *dic = [[self explodeString:queryStr ToDictionaryInnerGlue:@"=" outterGlue:@"&"] copy];
  if ([dic objectForKey:@"userId"] != nil) {
    StaticInfo *staticInfo=[StaticInfo getSinglton];
    staticInfo.user.userId=[dic objectForKey:@"userId"];
    staticInfo.user.authToken=[dic objectForKey:@"authToken"];
    staticInfo.user.sourceType=SOURCE_SINA;//新浪微博
    
    NSDictionary *profileDic=[[RequestUtil getSinglton] getUserProfile:staticInfo.user.userId sourceType:staticInfo.user.sourceType];
    [staticInfo.user setProperties:profileDic];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:staticInfo.user.userId forKey:@"userId"];
    [prefs setObject:staticInfo.user.name forKey:@"nickname"];
    [prefs setObject:staticInfo.user.name forKey:@"nickname"];
    [prefs setObject:staticInfo.user.authToken forKey:@"authToken"];
    [prefs setInteger:staticInfo.user.sourceType forKey:@"sourceType"];
    [prefs setObject:staticInfo.user.accessToken forKey:@"accessToken"];
    [prefs setObject:staticInfo.user.accessUserId forKey:@"accessUserId"];
    [prefs setInteger:staticInfo.user.nowRiddingCount forKey:@"riddingCount"];
    
    staticInfo.logined=true;
    [[SinaApiRequestUtil getSinglton] friendShip:@"骑去哪儿网" accessUserId:riddingappuid];
    
    [[RequestUtil getSinglton] sendApns];
    
    QQNRFeedViewController *CVF=[[QQNRFeedViewController alloc]initWithUser:staticInfo.user exUser:nil];
     
    if(_sendWeiBo){
      [[SinaApiRequestUtil getSinglton]sendLoginRidding:[NSString stringWithFormat:@"我刚刚下载了#骑行者#,在这里推荐给热爱骑行的好友们。@骑去哪儿网 下载地址:%@ %@",downLoadPath,QIQUNARHOME]];
      
    }else{
      [MobClick event:@"2012111906"];
    }
   [prefs setObject:@"" forKey:@"recomApp"];
    
    CVF.isMyFeedHome=TRUE;
    [self.navigationController pushViewController:CVF animated:YES];
    [self.activityView removeFromSuperview];
  }
  return  YES;
}

- (void)setFollowView{
  CGRect frame = self.view.frame;
  
	CGRect toolbarFrame = CGRectMake(0, SCREEN_HEIGHT - 44, frame.size.width, 44);
	UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:toolbarFrame];
	NSMutableArray *items = [[NSMutableArray alloc] init];
	
	UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[items addObject:space];
	
	UIBarButtonItem *lb = [[UIBarButtonItem alloc] initWithTitle:@"发微博推荐给好友" style:UIBarButtonItemStylePlain target:nil action:nil];
	[items addObject:lb];
	
	space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
	[items addObject:space];
	
  
  _redSC= [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"不推荐?", @"推荐!", nil]];
  [_redSC addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
  _redSC.crossFadeLabelsOnDrag = YES;
  _redSC.thumb.tintColor = [UIColor getColor:ColorBlue];
  _redSC.selectedIndex = 1;
  [self.view addSubview:_redSC];
  _redSC.center = CGPointMake(240,355);
  _sendWeiBo=TRUE;
  
	UIBarButtonItem *sb = [[UIBarButtonItem alloc] initWithCustomView:_redSC];
	[items addObject:sb];
	
	[toolBar setItems:items];
	
	toolBar.barStyle = UIBarStyleBlackOpaque;
	[self.view addSubview:toolBar];
  
}

- (NSMutableDictionary *)explodeString:(NSString*)src ToDictionaryInnerGlue:(NSString *)innerGlue outterGlue:(NSString *)outterGlue {
  // Explode based on outter glue
  NSArray *firstExplode = [src componentsSeparatedByString:outterGlue];
  NSArray *secondExplode;
  
  // Explode based on inner glue
  NSInteger count = [firstExplode count];
  NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithCapacity:count];
  for (NSInteger i = 0; i < count; i++) {
    secondExplode = [(NSString *)[firstExplode objectAtIndex:i] componentsSeparatedByString:innerGlue];
    if ([secondExplode count] == 2) {
      [returnDictionary setObject:[secondExplode objectAtIndex:1] forKey:[secondExplode objectAtIndex:0]];
    }
  }
  
  return returnDictionary;
}

#pragma mark -
#pragma mark SPSegmentedControl
- (void)segmentedControlChangedValue:(SVSegmentedControl*)segmentedControl {
  if(segmentedControl.selectedIndex==0){
    _sendWeiBo=FALSE;
  }else if(segmentedControl.selectedIndex==1){
    _sendWeiBo=TRUE;
  }
}

@end
