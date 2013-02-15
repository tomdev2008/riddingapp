//
//  NearByUserViewController.m
//  Ridding
//
//  Created by zys on 13-2-8.
//
//

#import "NearByUserViewController.h"
#import "UserNearBy.h"
#import "NearByUserCell.h"
#import "SVProgressHUD.h"
#import "MyLocationManager.h"
#import "QiNiuUtils.h"
#import "Utilities.h"
#import "UIButton+WebCache.h"
#define limit 20
@interface NearByUserViewController ()

@end

@implementation NearByUserViewController

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
  [super viewDidLoad];
  _dataSource=[[NSMutableArray alloc]init];
  
  [self addTableHeader];
  [self addTableFooter];
}
- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  if (!self.didAppearOnce) {
    MyLocationManager *manager = [MyLocationManager getSingleton];
    [manager startUpdateMyLocation:^(QQNRMyLocation *location) {
      if (location == nil) {
        [SVProgressHUD showSuccessWithStatus:@"请开启定位服务以定位到您的位置" duration:2.0];
        [SVProgressHUD dismiss];
        return;
      }
      [self download:location.latitude longitude:location.longtitude];
    }];
    self.didAppearOnce = TRUE;
  }
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

//时间是用在进行中的列表，weight是用在推荐列表
- (void)download:(double)latitude longitude:(double)longitude {
  
  if (_isLoading) {
    return;
  }
  _isLoading = TRUE;
  [SVProgressHUD showWithStatus:@"加载中"];
  dispatch_async(dispatch_queue_create("download", NULL), ^{
    NSArray *array = [self.requestUtil nearByUsers:limit offset:_endOffset latitude:latitude longitude:longitude];
    if (!_isLoadOld) {
      [_dataSource removeAllObjects];
    }
    if(array&&[array count]>0){
      for (NSDictionary *dic in array) {
        UserNearBy *nearBy=[[UserNearBy alloc]initWithJSONDic:[dic objectForKey:keyUserNearBy]];
        [_dataSource addObject:nearBy];
      }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.tv reloadData];
      if (!array||[array count] < limit) {
        _isTheEnd = TRUE;
        [_ego setHidden:YES];
      } else {
        [_ego setHidden:NO];
      }
      [self doneLoadingTableViewData];
      [self doneDOWNLoadingTableViewData];
      _isLoading = FALSE;
      [SVProgressHUD dismiss];
    });
  });
}


- (void)addTableHeader {
  
  _top_Ego = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -45, SCREEN_WIDTH, 45)];
  _top_Ego.delegate = self;
  _top_Ego.backgroundColor = [UIColor clearColor];
  [self.tv setTableHeaderView:_top_Ego];
}

- (void)addTableFooter {
  
  _ego = [[UP_EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 10, SCREEN_WIDTH, 45) withBackgroundColor:[UIColor whiteColor]];
  _ego.delegate = self;
  _ego.backgroundColor = [UIColor clearColor];
  [self.tv setTableFooterView:_ego];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NearByUserCell *cell = (NearByUserCell *) [Utilities cellByClassName:@"NearByUserCell" inNib:@"NearByUserCell" forTableView:self.tv];
  UserNearBy *nearBy = [_dataSource objectAtIndex:indexPath.row];
  NSURL *url = [QiNiuUtils getUrlBySizeToUrl:cell.avatorBtn.frame.size url:nearBy.user.savatorUrl type:QINIUMODE_DEDEFAULT];
  [cell.avatorBtn setImageWithURL:url placeholderImage:nil];
  cell.nameLabel.text = nearBy.user.name;
  cell.distanceLabel.text=INT2STR(nearBy.distance);
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
  if (!_isTheEnd) {
    [_ego egoRefreshScrollViewDidScroll:scrollView];
  }
  [_top_Ego egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  
  if (!_isTheEnd) {
    [_ego egoRefreshScrollViewDidEndDragging:scrollView];
  }
  [_top_Ego egoRefreshScrollViewDidEndDragging:scrollView];
  if (!decelerate) {
    //在滚动停止是加载图片
  }
  
}

#pragma mark - EGO delegate
- (void)reloadTableViewDataSource {
  
  if (!_isTheEnd) {
    _isLoadOld = TRUE;
 //   [self download:<#(double)#> longitude:<#(double)#>];
  }
}

- (void)doneLoadingTableViewData {
  //  model should call this when its done loading
  if (!_isTheEnd) {
    [_ego egoRefreshScrollViewDataSourceDidFinishedLoading:self.tv];
  }
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(UP_EGORefreshTableHeaderView *)view {
  
  [self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(UP_EGORefreshTableHeaderView *)view {
  
  return _isLoading; // should return if data source model is reloading
}

#pragma mark - DownEGO
- (void)doneDOWNLoadingTableViewData {
  //  model should call this when its done loading
  [_top_Ego egoRefreshScrollViewDataSourceDidFinishedLoading:self.tv];
  
}

- (void)downEGOReload {
  
  if (!_isLoading) {
    _isLoadOld = FALSE;
    _isTheEnd = FALSE;
 //   [self download:<#(double)#> longitude:<#(double)#>];
  }
}

- (void)down_egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view {
  
  [self downEGOReload];
}

- (BOOL)down_egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view {
  
  return _isLoading; // should return if data source model is reloading
}

@end
