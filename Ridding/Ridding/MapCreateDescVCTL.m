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
#import "QQNRServerTaskQueue.h"
#import "QQNRFeedViewController.h"

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

  [self.barView.rightButton setTitle:@"确定" forState:UIControlStateNormal];
  [self.barView.rightButton setTitle:@"确定" forState:UIControlStateHighlighted];
  [self.barView.rightButton setHidden:NO];

  self.barView.titleLabel.text = @"创建活动";
  self.beginLocationTV.textColor = [UIColor getColor:@"666666"];
  self.endLocationTV.textColor = [UIColor getColor:@"666666"];
  self.nameField.textColor = [UIColor getColor:@"666666"];
  self.totalDistanceLB.textColor = [UIColor getColor:@"666666"];
  self.beginLocationTV.text = [NSString stringWithFormat:@"%@", _ridding.map.beginLocation];
  self.endLocationTV.text = [NSString stringWithFormat:@"%@", _ridding.map.endLocation];
  self.totalDistanceLB.text = [NSString stringWithFormat:@"总行程:%0.2fKM", _ridding.map.distance * 1.0 / 1000];

  self.nameField.returnKeyType = UIReturnKeyGo;
  self.mapImageView.image = _ridding.map.coverImage;
  self.view.backgroundColor = [UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"bg_dt")];

  _redSC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"不分享", @"分享", nil]];
  [_redSC addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
  _redSC.crossFadeLabelsOnDrag = YES;
  _redSC.thumb.tintColor = [UIColor getColor:ColorBlue];
  _redSC.selectedIndex = 0;
  [self.view addSubview:_redSC];
  _redSC.center = CGPointMake(280, 405);
  _sendWeiBo = FALSE;


  _publicSC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@"不公开", @"公开", nil]];
  [_publicSC addTarget:self action:@selector(publicChangedValue:) forControlEvents:UIControlEventValueChanged];
  _publicSC.crossFadeLabelsOnDrag = YES;
  _publicSC.thumb.tintColor = [UIColor getColor:ColorBlue];
  _publicSC.selectedIndex = 1;
  [self.view addSubview:_publicSC];
  _publicSC.center = CGPointMake(240, 355);

  _isPublic = TRUE;


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

  QQNRServerTask *task = [[QQNRServerTask alloc] init];
  task.step = STEP_UPLOADRIDDING;
  task.taskDelegate = self;

  QQNRServerTaskQueue *queue = [QQNRServerTaskQueue sharedQueue];
  [queue addTask:task withDependency:YES];

  __block NSString *riddingName = self.nameField.text;
  __block NSString *beginLocation = self.beginLocationTV.text;
  __block NSString *endLocation = self.endLocationTV.text;
  __block int isPublic = _isPublic ? 1 : 0;
  __block BOOL sendWeiBo = _sendWeiBo;
  [task setDataProcessBlock:(BlockProcessLastTaskData) ^(NSDictionary *dic) {
    if (dic) {
      Ridding *ridding = [dic objectForKey:kFileClientServerUpload_Ridding];
      ridding.riddingName = riddingName;
      ridding.map.beginLocation = beginLocation;
      ridding.map.endLocation = endLocation;
      ridding.isPublic = isPublic;
#warning issync
      ridding.isSyncSina = isPublic;

      NSMutableDictionary *mulDic = [[NSMutableDictionary alloc] init];
      [mulDic setObject:ridding forKey:kFileClientServerUpload_Ridding];
      task.paramDic = mulDic;
      if (sendWeiBo) {
        NSString *status = [NSString stringWithFormat:@"我刚刚用#骑行者#创建了一个骑行活动:%@,推荐给大家。 @骑去哪儿网 下载地址:%@", _ridding.riddingName, downLoadPath];
        [[SinaApiRequestUtil getSinglton] sendCreateRidding:status url:[NSString stringWithFormat:@"%@/%@", imageHost, ridding.map.fileKey]];
      } else {
        [MobClick event:@"2012111905"];
      }

    }
  }];

  self.barView.rightButton.enabled = YES;
  [SVProgressHUD dismiss];

  RiddingAppDelegate *delegate = [RiddingAppDelegate shareDelegate];
  QQNRFeedViewController *FVC = [[QQNRFeedViewController alloc] initWithUser:[StaticInfo getSinglton].user isFromLeft:TRUE];
  [RiddingAppDelegate popAllNavgation];
  [delegate.navController pushViewController:FVC animated:NO];
}

- (void)leftBtnClicked:(id)sender {

  [self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark textFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

  [textField resignFirstResponder];
  return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

  [self.nameField setText:@""];
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
#pragma mark SPSegmentedControl
- (void)segmentedControlChangedValue:(SVSegmentedControl *)segmentedControl {

  if (segmentedControl.selectedIndex == 0) {
    _sendWeiBo = FALSE;
  } else if (segmentedControl.selectedIndex == 1) {
    _sendWeiBo = TRUE;
  }
}

- (void)publicChangedValue:(SVSegmentedControl *)segmentedControl {

  if (segmentedControl.selectedIndex == 0) {
    _isPublic = FALSE;
  } else if (segmentedControl.selectedIndex == 1) {
    _isPublic = TRUE;
  }
}

#pragma mark -
#pragma mark QQNRServerTask Delegate
- (void)serverTask:(QQNRServerTask *)task finishedWithServerJSON:(NSDictionary *)jsonData {

}

- (void)serverTask:(QQNRServerTask *)task errorWithServerJSON:(NSDictionary *)jsonData {

}


@end
