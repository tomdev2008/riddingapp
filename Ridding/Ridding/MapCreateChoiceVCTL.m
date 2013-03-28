//
//  MapCreateChoiceVCTL.m
//  Ridding
//
//  Created by zys on 13-3-13.
//
//

#import "MapCreateChoiceVCTL.h"
#import "MapCreateVCTL.h"
#import "Ridding.h"
#import "MapCreateDescVCTL.h"
#import "SVProgressHUD.h"
#import "MyLocationManager.h"
#import "PublicDetailViewController.h"
#import "ShortMapViewController.h"
#import "QQNRFeedViewController.h"
@interface MapCreateChoiceVCTL ()

@end

@implementation MapCreateChoiceVCTL

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  self.canMoveLeft=YES;
  self.hasLeftView = TRUE;
  [super viewDidLoad];
  
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_list") forState:UIControlStateNormal];
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_list_hl") forState:UIControlStateHighlighted];
  
  self.barView.titleLabel.text = @"创建路线";
  self.view.backgroundColor = [UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"qqnr_bg")];
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  
}

- (void)leftBtnClicked:(id)sender{
  
  
}


- (IBAction)shortPathClick:(id)sender{
  
  [SVProgressHUD showWithStatus:@"Gps启动中。。"];
  
  MyLocationManager *manager = [MyLocationManager getSingleton];
  [manager startUpdateMyLocation:^(QQNRMyLocation *location) {
    if (location == nil) {
      [SVProgressHUD showSuccessWithStatus:@"请开启定位服务以定位到您的位置" duration:2.0];
      return;
    }
    Ridding *ridding=[[Ridding alloc]init];
    NSString *cityName=location.name;
    if (location.city) {
      cityName = location.city;
    } else if (cityName) {
      cityName = cityName;
    } 
    ridding.map.cityName=cityName;
    ridding.map.beginLocation=location.name;
    ridding.map.midLocations = [NSArray array];
    ridding.map.beginLocation = @"";
    ridding.map.mapPoint = [NSArray array];
    ridding.map.distance = 0;
    ridding.map.mapTaps = [NSArray array];
    ridding.riddingType=RiddingType_ShortAway;
    
    ridding.map.endLocation = @"";
    ridding.riddingName = @"骑行活动";
    
    dispatch_queue_t q;
    q = dispatch_queue_create("riddingCreate", NULL);
    dispatch_async(q, ^{
      RequestUtil *requestUtil = [[RequestUtil alloc] init];
      NSDictionary *dic = [requestUtil addRidding:ridding];
      if (dic) {
        Ridding *returnRidding = [[Ridding alloc] initWithJSONDic:[dic objectForKey:keyRidding]];
        ridding.riddingId=returnRidding.riddingId;
        dispatch_async(dispatch_get_main_queue(), ^{
          
          [[NSNotificationCenter defaultCenter]postNotificationName:kSuccAddRiddingNotification object:nil];
          [SVProgressHUD dismiss];
          RiddingAppDelegate *delegate = [RiddingAppDelegate shareDelegate];
          
          QQNRFeedViewController *FVC = [[QQNRFeedViewController alloc] initWithUser:[StaticInfo getSinglton].user isFromLeft:TRUE];
          [RiddingAppDelegate popAllNavgation];
          
          ShortMapViewController *shortMap=[[ShortMapViewController alloc]initWithUser:[StaticInfo getSinglton].user ridding:returnRidding isMyFeedHome:YES];
          [delegate.navController pushViewController:FVC animated:NO];
          [delegate.navController pushViewController:shortMap animated:YES];
        });
      }
    });
  }];

  
}

- (IBAction)longPathClick:(id)sender{
  
  MapCreateVCTL *mapCreateVCTL=[[MapCreateVCTL alloc]init];
  [self.navigationController pushViewController: mapCreateVCTL animated:YES];
  
}

@end
