//
//  PublicViewController.m
//  Ridding
//
//  Created by zys on 12-12-2.
//
//

#import "PublicViewCell.h"
#import "Utilities.h"
#import "QiNiuUtils.h"
#import "UIImageView+WebCache.h"
#import "PublicDetailViewController.h"
#import "SVProgressHUD.h"

#define dataLimit 2

@interface PublicViewController ()

@end

@implementation PublicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad {

  [super viewDidLoad];
  //self.view.backgroundColor=[UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"QQNR_MAIN_BG")];

  [self.barView.titleLabel setText:@"推荐骑记"];
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"QQNR_LIST") forState:UIControlStateNormal];
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"QQNR_LIST") forState:UIControlStateHighlighted];

  _dataSource = [[NSMutableArray alloc] init];
  _endUpdateTime = -1;
  _endWeight = -1;
  _isTheEnd = FALSE;
  _isLoadOld = FALSE;
  _isLoading = FALSE;
  _type = ActivityInfoType_Recom;
  self.tv.touchDelegate = self;
  self.hasLeftView = TRUE;

  [self.barView.leftButton setHidden:NO];

  [self addTableHeader];
  [self addTableFooter];

}

- (void)viewDidAppear:(BOOL)animated {

  [super viewDidAppear:animated];
  if (!self.didAppearOnce) {
    [self download];
    self.didAppearOnce = TRUE;
  }
}

- (void)didReceiveMemoryWarning {

  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

//时间是用在进行中的列表，weight是用在推荐列表
- (void)download {

  if (_isLoading) {
    return;
  }
  _isLoading = TRUE;
  [SVProgressHUD showWithStatus:@"加载中"];
  dispatch_async(dispatch_queue_create("download", NULL), ^{
    NSArray *serverArray = [self.requestUtil getRiddingPublicList:_endUpdateTime limit:dataLimit isLarger:0 type:_type weight:_endWeight];
    if (!_isLoadOld) {
      [_dataSource removeAllObjects];
    }
    [self doUpdate:serverArray];
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.tv reloadData];
      if ([serverArray count] < dataLimit) {
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

- (void)doUpdate:(NSArray *)array {

  if (array && [array count] > 0) {
    for (NSDictionary *dic in array) {
      ActivityInfo *actInfo = [[ActivityInfo alloc] initWithJSONDic:[dic objectForKey:@"activity"]];
      [_dataSource addObject:actInfo];
    }
    if (_type == ActivityInfoType_Recom) {
      ActivityInfo *info = (ActivityInfo *) [_dataSource lastObject];
      _endWeight = info.weight;
    } else {
      ActivityInfo *info = (ActivityInfo *) [_dataSource lastObject];
      _endUpdateTime = info.ridding.createTime;
    }
  }

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

  return 170;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  PublicViewCell *cell = (PublicViewCell *) [Utilities cellByClassName:@"PublicViewCell" inNib:@"PublicViewCell" forTableView:self.tv];
  ActivityInfo *info = [_dataSource objectAtIndex:indexPath.row];
  NSURL *url = [QiNiuUtils getUrlBySizeToUrl:cell.firstPicImageView.frame.size url:info.firstPicUrl type:QINIUMODE_DEDEFAULT];
  [cell.firstPicImageView setImageWithURL:url placeholderImage:nil];
  cell.nameLabel.text = info.ridding.riddingName;
  cell.dateLabel.text = info.ridding.createTimeStr;
  cell.distanceLabel.text = [NSString stringWithFormat:@"%0.2fKM", info.ridding.map.distance * 1.0 / 1000];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  ActivityInfo *actInfo = [_dataSource objectAtIndex:indexPath.row];
  PublicDetailViewController *pdVCTL = [[PublicDetailViewController alloc] initWithNibName:@"PublicDetailViewController" bundle:nil ridding:actInfo.ridding isMyHome:FALSE toUser:actInfo.ridding.leaderUser];
  [self.navigationController pushViewController:pdVCTL animated:YES];
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
    [self download];
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
    _endWeight = -1;
    _endUpdateTime = -1;
    [self download];
  }
}

- (void)down_egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view {

  [self downEGOReload];
}

- (BOOL)down_egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view {

  return _isLoading; // should return if data source model is reloading
}

@end
