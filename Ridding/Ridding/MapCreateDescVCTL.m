//
//  MapCreateDescVCTL.m
//  Ridding
//
//  Created by zys on 12-11-17.
//
//

#import "MapCreateDescVCTL.h"
#import "UIColor+XMin.h"
#import "SVProgressHUD.h"
#import "QQNRFeedViewController.h"
#import "MapUtil.h"
#import "RiddingLocationDao.h"
#import "PublicDetailViewController.h"
#import "ShortMapViewController.h"
@interface MapCreateDescVCTL ()

@end

@implementation MapCreateDescVCTL

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ridding:(Ridding *)ridding isShortPath:(BOOL)isShortPath{

  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _ridding = ridding;
    _isShortPath=isShortPath;
  }
  return self;
}

- (void)viewDidLoad {

  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"qqnr_bg")];
  
  [self.barView.rightButton setImage:UIIMAGE_FROMPNG(@"qqnr_dl_navbar_icon_create") forState:UIControlStateNormal];
  [self.barView.rightButton setImage:UIIMAGE_FROMPNG(@"qqnr_dl_navbar_icon_create") forState:UIControlStateHighlighted];
  [self.barView.rightButton setHidden:NO];
  
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back") forState:UIControlStateNormal];
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back_hl") forState:UIControlStateHighlighted];
  [self.barView.leftButton setHidden:NO];

  self.barView.titleLabel.text = @"创建活动";
  self.beginLocationTV.text = _ridding.map.beginLocation;
  
  if(_isShortPath){
    
    self.nameField.text=@"短途旅行";
    
  }else{
    
    self.endLocationTV.text = _ridding.map.endLocation;
    self.totalDistanceLB.text = [NSString stringWithFormat:@"%@", [_ridding.map totalDistanceToKm]];
    NSMutableArray *routes = [[NSMutableArray alloc] init];
    [[MapUtil getSinglton] calculate_routes_from:_ridding.map.mapTaps map:_ridding.map];
    [routes addObjectsFromArray:[[MapUtil getSinglton] decodePolyLineArray:_ridding.map.mapPoint]];
    [[MapUtil getSinglton] center_map:_mapView routes:routes];
    [[MapUtil getSinglton] update_route_view:_mapView to:_lineImageView line_color:[UIColor getColor:lineColor] routes:routes width:5.0];

  }
  
  self.nameField.returnKeyType = UIReturnKeyGo;

  self.separatorLine1.image=[UIIMAGE_FROMPNG(@"qqnr_pd_comment_line") stretchableImageWithLeftCapWidth:17 topCapHeight:0];
  self.separatorLine2.image=[UIIMAGE_FROMPNG(@"qqnr_pd_comment_line") stretchableImageWithLeftCapWidth:17 topCapHeight:0];
  _isSyncWifi = FALSE;

  _lineImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
  _lineImageView.layer.borderWidth = 5.0;
  
}

- (void)didReceiveMemoryWarning {

  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)rightBtnClicked:(id)sender {

  [MobClick event:@"2012111903"];
  self.barView.rightButton.enabled = NO;
  if ([self.nameField.text isEqualToString:@""] || [self.nameField.text isEqualToString:@"添加活动名称"]) {
    [SVProgressHUD showErrorWithStatus:@"去添加下活动名称咯~" duration:2];
    self.barView.rightButton.enabled = YES;
    return;
  }
  if(!_isShortPath){
    if ([self.beginLocationTV.text isEqualToString:@""]) {
      [SVProgressHUD showErrorWithStatus:@"请输入起点" duration:2];
      self.barView.rightButton.enabled = YES;
      return;
    }
    if ([self.endLocationTV.text isEqualToString:@""]) {
      [SVProgressHUD showErrorWithStatus:@"去输入终点" duration:2];
      self.barView.rightButton.enabled = YES;
      return;
    }
    _ridding.map.endLocation = self.endLocationTV.text;
    _ridding.map.beginLocation = self.beginLocationTV.text;
  }
  [self.nameField resignFirstResponder];
  [SVProgressHUD showWithStatus:@"创建中,请稍候"];
  _ridding.riddingName = self.nameField.text;
  dispatch_queue_t q;
  q = dispatch_queue_create("riddingCreate", NULL);
  dispatch_async(q, ^{
    RequestUtil *requestUtil = [[RequestUtil alloc] init];
    NSDictionary *dic = [requestUtil addRidding:_ridding];
    if (dic) {
      Ridding *returnRidding = [[Ridding alloc] initWithJSONDic:[dic objectForKey:keyRidding]];
      _ridding.riddingId=returnRidding.riddingId;
      dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showWithStatus:@"正在保存数据"];
      });
      if(!_isShortPath){
        //保存到本地数据库
        Map *map = _ridding.map;
        NSArray *array = map.mapPoint;
        [[MapUtil getSinglton] calculate_routes_from:map.mapTaps map:map];
        NSMutableArray *mapPoints = [[MapUtil getSinglton] decodePolyLineArray:array];
        [RiddingLocationDao setRiddingLocationToDB:mapPoints riddingId:_ridding.riddingId];
      }
      
      dispatch_async(dispatch_get_main_queue(), ^{
        
        [[NSNotificationCenter defaultCenter]postNotificationName:kSuccAddRiddingNotification object:nil];
        [SVProgressHUD dismiss];
        RiddingAppDelegate *delegate = [RiddingAppDelegate shareDelegate];
        if(_isShortPath){
          QQNRFeedViewController *FVC = [[QQNRFeedViewController alloc] initWithUser:[StaticInfo getSinglton].user isFromLeft:TRUE];
          [RiddingAppDelegate popAllNavgation];
          PublicDetailViewController *publicDetail=[[PublicDetailViewController alloc]initWithNibName:@"PublicDetailViewController" bundle:nil ridding:_ridding isMyHome:TRUE toUser:[StaticInfo getSinglton].user];
          ShortMapViewController *shortMap=[[ShortMapViewController alloc]init];
          [delegate.navController pushViewController:FVC animated:NO];
          [delegate.navController pushViewController:publicDetail animated:NO];
          [delegate.navController pushViewController:shortMap animated:YES];
          
        }else{
          
          QQNRFeedViewController *FVC = [[QQNRFeedViewController alloc] initWithUser:[StaticInfo getSinglton].user isFromLeft:TRUE];
          [RiddingAppDelegate popAllNavgation];
          [delegate.navController pushViewController:FVC animated:NO];
        }
      });
    }
  });

}

- (void)leftBtnClicked:(id)sender {

  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

  [textField resignFirstResponder];
  return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

  if(textField==self.nameField){
    if([self.nameField.text isEqualToString:@"添加活动名称"]){
      self.nameField.text=@"";
    }
  }

  return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {

  [textField resignFirstResponder];
}

- (IBAction)viewClick:(id)sender {

  UIView *view = (UIView *) sender;
  if (view != self.nameField) {
    [self.nameField resignFirstResponder];
  }
  if (view != self.beginLocationTV) {
    [self.beginLocationTV resignFirstResponder];
  }
  if (view != self.endLocationTV) {
    [self.endLocationTV resignFirstResponder];
  }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

  NSMutableString *text = [textField.text mutableCopy];
  [text replaceCharactersInRange:range withString:string];
  return [text length] <= 12;
}

- (IBAction)syncSinaBtn:(id)sender{
  
  if(_isSyncWifi){
    
    _isSyncWifi=FALSE;
    [self.syncSinaBtn setImage:UIIMAGE_FROMPNG(@"qqnr_createmap_sina_disable") forState:UIControlStateNormal];
  }else{
    
    _isSyncWifi=TRUE;
    [self.syncSinaBtn setImage:UIIMAGE_FROMPNG(@"qqnr_createmap_sina") forState:UIControlStateNormal];
  }
}
#pragma mark -
#pragma mark UITextViewDelegate

- (void)moveView:(CGFloat)viewHeight {

  if ((_showingKeyBoard && viewHeight > 0) || (!_showingKeyBoard && viewHeight < 0)) {
    if (_showingKeyBoard) {
      _showingKeyBoard = FALSE;
    } else {
      _showingKeyBoard = TRUE;
    }

    [UIView animateWithDuration:0.2
        animations:^{
          self.view.frame = CGRectMake(self.view.frame.origin.x,
              self.view.frame.origin.y + viewHeight,
              self.view.frame.size.width,
              self.view.frame.size.height);
        } completion:^(BOOL completed) {
    }];
  }
}


#pragma mark -
#pragma mark QQNRServerTask Delegate
- (void)serverTask:(QQNRServerTask *)task finishedWithServerJSON:(NSDictionary *)jsonData {

}

- (void)serverTask:(QQNRServerTask *)task errorWithServerJSON:(NSDictionary *)jsonData {

}


@end
