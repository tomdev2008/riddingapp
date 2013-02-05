//
//  MapCreateDescVCTL.m
//  Ridding
//
//  Created by zys on 12-11-17.
//
//

#import "MapCreateDescVCTL.h"
#import "UIColor+XMin.h"
#import "SinaApiRequestUtil.h"
#import "SVProgressHUD.h"
#import "QQNRFeedViewController.h"
#import "MapUtil.h"
#import "RiddingLocationDao.h"
@interface MapCreateDescVCTL ()

@end

@implementation MapCreateDescVCTL

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ridding:(Ridding *)ridding {

  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _ridding = ridding;
  }
  return self;
}

- (void)viewDidLoad {

  [super viewDidLoad];

  self.view.backgroundColor = [UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"qqnr_bg")];
  
  [self.barView.rightButton setTitle:@"确定" forState:UIControlStateNormal];
  [self.barView.rightButton setTitle:@"确定" forState:UIControlStateHighlighted];
  [self.barView.rightButton setHidden:NO];
  
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back") forState:UIControlStateNormal];
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back_hl") forState:UIControlStateHighlighted];
  [self.barView.leftButton setHidden:NO];

  self.barView.titleLabel.text = @"创建活动";
  
  self.beginLocationTV.text = _ridding.map.beginLocation;
  self.endLocationTV.text = _ridding.map.endLocation;
  
  self.totalDistanceLB.text = [NSString stringWithFormat:@"总行程:%@", [_ridding.map totalDistanceToKm]];

  self.nameField.returnKeyType = UIReturnKeyGo;

  
  _isSyncSina = FALSE;

  NSMutableArray *routes = [[NSMutableArray alloc] init];
  [[MapUtil getSinglton] calculate_routes_from:_ridding.map.mapTaps map:_ridding.map];
  [routes addObjectsFromArray:[[MapUtil getSinglton] decodePolyLineArray:_ridding.map.mapPoint]];
  [[MapUtil getSinglton] center_map:_mapView routes:routes];
  [[MapUtil getSinglton] update_route_view:_mapView to:_lineImageView line_color:[UIColor getColor:lineColor] routes:routes];

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
  [SVProgressHUD showWithStatus:@"创建进行中"];
  _ridding.riddingName = self.nameField.text;
  _ridding.map.beginLocation = self.beginLocationTV.text;
  _ridding.map.endLocation = self.endLocationTV.text;
  _ridding.isSyncSina = _isSyncSina ? 1 : 0;

  dispatch_queue_t q;
  q = dispatch_queue_create("riddingCreate", NULL);
  dispatch_async(q, ^{
    RequestUtil *requestUtil = [[RequestUtil alloc] init];
    NSDictionary *dic = [requestUtil addRidding:_ridding];
    if (dic) {
      _ridding = [[Ridding alloc] initWithJSONDic:[dic objectForKey:keyRidding]];
      dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter]postNotificationName:kSuccAddRiddingNotification object:nil];
        [SVProgressHUD dismiss];
      });
    }
  });
  self.barView.rightButton.enabled = YES;

  RiddingAppDelegate *delegate = [RiddingAppDelegate shareDelegate];
  QQNRFeedViewController *FVC = [[QQNRFeedViewController alloc] initWithUser:[StaticInfo getSinglton].user isFromLeft:TRUE];
  [RiddingAppDelegate popAllNavgation];
  [delegate.navController pushViewController:FVC animated:NO];
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
#pragma mark -
#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {

  [self moveView:-150];
}

- (void)textViewDidEndEditing:(UITextView *)textView {

  [self moveView:150];
}

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
