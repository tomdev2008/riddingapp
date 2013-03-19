//
//  PhotoSyncViewController.m
//  Ridding
//
//  Created by zys on 13-3-14.
//
//

#import "PhotoSyncViewController.h"
#import "UserSettingCell.h"
#import "Utilities.h"
#import "RiddingPictureDao.h"
#import "BlockAlertView.h"
#import "SVSegmentedControl.h"
#import "UIColor+XMin.h"
#import "RiddingPicture.h"
@interface PhotoSyncViewController ()

@end

@implementation PhotoSyncViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCount:(int)count{
  self=[super init];
  if(self){
    _count=count;
  }
  return self;
}

- (void)viewDidLoad
{
  
  [super viewDidLoad];
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back") forState:UIControlStateNormal];
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back_hl") forState:UIControlStateHighlighted];
  [self.barView.leftButton setHidden:NO];
  
  [self.barView.titleLabel setText:@"拍照设置"];
  self.view.backgroundColor = [UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"qqnr_bg")];
  self.uiTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
  self.uiTableView.backgroundColor=[UIColor clearColor];
  
  
#ifdef isProVersion
#else
  GADSearchBannerView *bannerView = [[GADSearchBannerView alloc] initWithAdSize:GADAdSizeFromCGSize(GAD_SIZE_320x50) origin:CGPointMake(0, SCREEN_HEIGHT- 50)];
  bannerView.adUnitID = MY_BANNER_UNIT_ID;
  bannerView.rootViewController = self;
  [self.view addSubview:bannerView];
  GADSearchRequest *adRequest = [[GADSearchRequest alloc] init];
  [adRequest setQuery:@"sport"];
  [bannerView loadRequest:[adRequest request]];
#endif
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(succUploadPicture:)
                                               name:kSuccUploadPictureNotification object:nil];
  
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableView data source and delegate methods
//每个section显示的标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  
  return @"";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if(indexPath.row==0){
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.textLabel.textAlignment=UITextAlignmentLeft;
    cell.textLabel.textColor=[UIColor whiteColor];
    if(_count>0){
      cell.textLabel.text=[NSString stringWithFormat:@"未上传照片(点击上传)"];
    }else{
      cell.textLabel.text=[NSString stringWithFormat:@"未上传照片"];
    }
    UILabel *countLabel=[[UILabel alloc]initWithFrame:CGRectMake(250, 18, 50, 20)];
    countLabel.textColor=[UIColor whiteColor];
    countLabel.backgroundColor=[UIColor clearColor];
    countLabel.text=[NSString stringWithFormat:@"%d 张",_count];
    [cell.contentView addSubview:countLabel];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return  cell;
  }else {
    UITableViewCell *cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.textLabel.textAlignment=UITextAlignmentLeft;
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.textLabel.text=@"只在wifi状态下上传照片?";
    SVSegmentedControl *redSC = [[SVSegmentedControl alloc] initWithSectionTitles:[NSArray arrayWithObjects:@" 否 ", @" 是 ", nil]];
    [redSC addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    redSC.crossFadeLabelsOnDrag = YES;
    redSC.thumb.tintColor = [UIColor getColor:ColorBlue];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([prefs objectForKey:kStaticInfo_SaveInWifi]){
      redSC.selectedIndex = 1;
    }else{
      redSC.selectedIndex = 0;
    }
    
    [cell.contentView addSubview:redSC];
    redSC.center = CGPointMake(260, 25);
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
  }
  return nil;
}

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if ([indexPath row] == 0) {
    if(_count>0){
      BlockAlertView *alert = [[BlockAlertView alloc] initWithTitle:@"图片上传" message:[NSString stringWithFormat:@"您还有%d张相片没有上传",_count]];
      [alert setCancelButtonWithTitle:@"暂时不上传" block:^(void) {
        
      }];
      [alert addButtonWithTitle:@"现在上传" block:^{
        [RiddingPicture uploadRiddingPictureFromLocal];
      }];
      [alert show];
    }

  } else if ([indexPath row] == 1) {
    
  }
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
  
}
#pragma mark -
#pragma mark Table Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  return 50;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  return UITableViewCellEditingStyleNone;
}

#pragma mark -
#pragma mark SPSegmentedControl
- (void)segmentedControlChangedValue:(SVSegmentedControl *)segmentedControl {
   NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  if (segmentedControl.selectedIndex == 0) {
    [prefs setBool:NO forKey:kStaticInfo_SaveInWifi];
    
  } else if (segmentedControl.selectedIndex == 1) {
    [prefs setBool:YES forKey:kStaticInfo_SaveInWifi];
  }
   [prefs setBool:NO forKey:kStaticInfo_SaveInWifiTips];
  [prefs synchronize];
  [MobClick event:@"2013031906"];
}

#pragma mark - MapCreateDescVCTL delegate
- (void)succUploadPicture:(NSNotification *)note {
  
    _count= [RiddingPictureDao getRiddingPictureCount];
    [self.uiTableView reloadData];
  
}

@end
