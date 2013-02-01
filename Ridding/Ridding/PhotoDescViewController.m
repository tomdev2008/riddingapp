//
//  PhotoDescViewController.m
//  Ridding
//
//  Created by zys on 12-10-30.
//
//

#import "PhotoDescViewController.h"
#import "QQNRServerTask.h"
#import "QQNRServerTaskQueue.h"
#import "MyLocationManager.h"
#import "SVProgressHUD.h"
#import "SinaApiRequestUtil.h"
@interface PhotoDescViewController ()

@end

@implementation PhotoDescViewController
@synthesize imageView = _imageView;
@synthesize textView = _textView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil riddingPicture:(RiddingPicture *)riddingPicture isSyncSina:(BOOL)isSyncSina{
  _syncSina=isSyncSina;
  _riddingPicture=riddingPicture;
  return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}

- (void)viewDidLoad {

  self.view.backgroundColor = [UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"feed_cbg")];
  [super viewDidLoad];
  self.barView.leftButton.hidden = YES;
  self.barView.rightButton.hidden = NO;
  [self.barView.leftButton setTitle:@"取消" forState:UIControlStateNormal];
  [self.barView.leftButton setTitle:@"取消" forState:UIControlStateHighlighted];
  [self.barView.rightButton setTitle:@"确定" forState:UIControlStateNormal];
  self.barView.titleLabel.text = @"添加描述";
  
  self.imageView.image = [_riddingPicture imageFromLocal];
  self.imageView.displayAsStack = NO;
  
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setDateFormat:@"yyyy年MM月dd日HH时mm分"];
  self.timeLabel.text = [formatter stringFromDate:[NSDate date]];
  self.textView.text = [NSString stringWithFormat:@"描述"];

  UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeLabelClick:)];
  self.timeLabel.userInteractionEnabled = YES;
  [self.timeLabel addGestureRecognizer:tapGesture];

  MyLocationManager *manager=[MyLocationManager getSingleton];
  [manager startUpdateMyLocation:^(QQNRMyLocation *location) {
    if(location==nil){
      [SVProgressHUD showSuccessWithStatus:@"请开启定位服务以定位到您的位置" duration:2.0];
      return;
    }
    self.locationLabel.text=location.city;
    _riddingPicture.location=location.city;
    _riddingPicture.latitude=location.latitude;
    _riddingPicture.longtitude=location.longtitude;
  }];

  if (!_datePicker) {
    _datePicker = [[QQNRDatePicker alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, DEFAULT_HEIGHT)];
    _datePicker.delegate = self;
    [self.view addSubview:_datePicker];
    [_datePicker hideDatePicker];
  }

}

- (void)didReceiveMemoryWarning {

  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void)timeLabelClick:(UIGestureRecognizer *)gesture {

  [self.textView resignFirstResponder];
  [_datePicker showDatePicker];
}

#pragma mark - delegate
- (void)didFinishChoice:(NSString *)dateStr {

  self.timeLabel.text = dateStr;
}

- (void)rightBtnClicked:(id)sender {

  QQNRServerTask *task = [[QQNRServerTask alloc] init];
  task.step = STEP_UPLOADDESC;

  QQNRServerTaskQueue *queue = [QQNRServerTaskQueue sharedQueue];
  [queue addTask:task withDependency:YES];

  __block NSString *desc = self.textView.text;
  [task setDataProcessBlock:(BlockProcessLastTaskData) ^(NSDictionary *dic) {
    RiddingPicture *picture = [dic objectForKey:kFileClientServerUpload_RiddingPicture];
    _riddingPicture.pictureDescription=desc;
    _riddingPicture.fileKey=picture.fileKey;
    
    NSMutableDictionary *mulDic = [[NSMutableDictionary alloc] init];
    [mulDic setObject:_riddingPicture forKey:kFileClientServerUpload_RiddingPicture];
    task.paramDic = mulDic;
    
    //if(_syncSina){
      SinaApiRequestUtil *sinaRequest=[[SinaApiRequestUtil alloc]init];
      [sinaRequest sendWeiBo:desc url:[NSString stringWithFormat:@"%@/%@",imageHost,picture.fileKey] latitude:_riddingPicture.latitude longtitude:_riddingPicture.longtitude];
    //}

  }];
  
   
  [self dismissModalViewControllerAnimated:YES];
}

- (void)leftBtnClicked:(id)sender {

}


- (IBAction)otherClick:(id)sender {

  if (![sender isKindOfClass:[self.textView class]]) {
    [self.textView resignFirstResponder];
  }
}


@end
