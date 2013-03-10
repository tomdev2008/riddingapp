//
//  UserHelpViewController.m
//  Ridding
//
//  Created by zys on 13-3-5.
//
//

#import "UserHelpViewController.h"
#import "UIImage+UIImage_Retina4.h"
#import "UserSettingCell.h"
#import "Utilities.h"
@interface UserHelpViewController ()

@end

@implementation UserHelpViewController

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
  
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back") forState:UIControlStateNormal];
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back_hl") forState:UIControlStateHighlighted];
  [self.barView.leftButton setHidden:NO];
  
  [self.barView.titleLabel setText:@"设置"];
  self.view.backgroundColor = [UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"qqnr_bg")];
  self.uiTableView.backgroundColor=[UIColor clearColor];
  
  GADSearchBannerView *bannerView = [[GADSearchBannerView alloc] initWithAdSize:GADAdSizeFromCGSize(GAD_SIZE_320x50) origin:CGPointMake(0, SCREEN_HEIGHT- 50)];
  bannerView.adUnitID = MY_BANNER_UNIT_ID;
  bannerView.rootViewController = self;
  [self.view addSubview:bannerView];
  GADSearchRequest *adRequest = [[GADSearchRequest alloc] init];
  [adRequest setQuery:@"sport"];
  [bannerView loadRequest:[adRequest request]];

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

  UserSettingCell *cell = (UserSettingCell *) [Utilities cellByClassName:@"UserSettingCell" inNib:@"UserSettingCell" forTableView:self.uiTableView];
  if ([indexPath row] == 0) {
    [cell initView:@"创建骑行活动"];
  } else if ([indexPath row] == 1) {
    [cell initView:@"个人活动路线"];
  }
  return cell;
}

- (void)      tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if ([indexPath row] == 0) {
    UIButton *imageView=[UIButton buttonWithType:UIButtonTypeCustom];
    imageView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [imageView setImage:[UIImage retina4ImageNamed:@"qqnr_mapcreate_help_bg" type:@"png"] forState:UIControlStateNormal];
    [imageView addTarget:self action:@selector(imageViewCilck:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imageView];
    
    
  } else if ([indexPath row] == 1) {
    UIButton *imageView=[UIButton buttonWithType:UIButtonTypeCustom];
    imageView.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [imageView setImage:[UIImage retina4ImageNamed:@"qqnr_dl_first_bg" type:@"png"] forState:UIControlStateNormal];
    [imageView addTarget:self action:@selector(imageViewCilck:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imageView];
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

- (void)imageViewCilck:(id)sender{
  UIView *view=(UIView*)sender;
  [view removeFromSuperview];
}


@end
