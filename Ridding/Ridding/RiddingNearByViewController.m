//
//  RiddingNearByViewController.m
//  Ridding
//
//  Created by zys on 13-3-10.
//
//

#import "RiddingNearByViewController.h"
#import "SVProgressHUD.h"
#import "Utilities.h"
#import "MyLocationManager.h"
#import "PublicDetailViewController.h"
#import "RiddingLocationDao.h"
#import "MapUtil.h"
#import "QQNRFeedViewController.h"
#define keyLimit 10
@interface RiddingNearByViewController ()

@end

@implementation RiddingNearByViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
  self.canMoveLeft=YES;
  self.hasLeftView = TRUE;
  self.view.backgroundColor = [UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"qqnr_bg")];
  self.tv.backgroundColor = [UIColor clearColor];
  
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_list") forState:UIControlStateNormal];
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_list_hl") forState:UIControlStateHighlighted];

  [self.barView.leftButton setHidden:NO];

  [self.barView.titleLabel setText:@"附近路线"];
  [self addTableHeader];
  [self addTableFooter];
  _isTheEnd = FALSE;
  _isLoadOld = FALSE;
  _dataSource = [[NSMutableArray alloc] init];
  
}

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  if (!self.didAppearOnce) {
    self.didAppearOnce = TRUE;
    [SVProgressHUD showWithStatus:@"获取中"];
    [self showMylocationRidding];
    
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showMylocationRidding{
  
  MyLocationManager *manager = [MyLocationManager getSingleton];
  [manager startUpdateMyLocation:^(QQNRMyLocation *location) {
    if (location == nil) {
      [SVProgressHUD showSuccessWithStatus:@"请开启定位服务以定位到您的位置" duration:2.0];
      return;
    }
    _latitude=location.latitude;
    _longitude=location.longtitude;
    [self download];
  }];

}

- (void)download{
  if (_isLoading) {
    return;
  }
  _isLoading = TRUE;
  [SVProgressHUD showWithStatus:@"请稍候"];
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSArray *array= [self.requestUtil getRiddingNearBy:_latitude longitude:_longitude limit:keyLimit offset:_extOffset];
    dispatch_async(dispatch_get_main_queue(), ^{
      if (!_isLoadOld) {
        [_dataSource removeAllObjects];
        _isTheEnd = FALSE;
      } else{
        [self doneLoadingTableViewData];
      }
      [self doUpdate:array];
      if (_isTheEnd) {
        [_ego setHidden:YES];
      } else {
        [_ego setHidden:NO];
      }
      if ([_dataSource count] == 0) {
        [self.lineView setHidden:YES];
        [_ego setHidden:YES];
      }else{
        [self.lineView setHidden:NO];
      }
      [self.tv reloadData];
      [self downLoadMapRoutes];
      [SVProgressHUD dismiss];
      _isLoading = FALSE;
    });
  });
}

- (void)doUpdate:(NSArray *)array {
  
  if (array && [array count] > 0) {
    for (NSDictionary *dic in array) {
      Ridding *ridding = [[Ridding alloc] initWithJSONDic:[dic objectForKey:keyRidding]];
      [_dataSource addObject:ridding];
    }
    if ([array count] < keyLimit) {
      _isTheEnd = TRUE;
    }
    _extOffset+=[array count];
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
  
  return 230;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *uiTableViewCell=[Utilities cellByClassName:@"QQNRFeedTableCell" inNib:@"QQNRFeedTableCell" forTableView:self.tv];
  if(uiTableViewCell){
    QQNRFeedTableCell *cell = (QQNRFeedTableCell *)uiTableViewCell;
    cell.backgroundColor = [UIColor clearColor];
    cell.delegate = self;
    cell.index = indexPath.row;
    Ridding *ridding = [_dataSource objectAtIndex:indexPath.row];
    [cell initContentView:ridding];
    return cell;
  }
  
  return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  Ridding *ridding = [_dataSource objectAtIndex:indexPath.row];
  PublicDetailViewController *pdVCTL = [[PublicDetailViewController alloc] initWithNibName:@"PublicDetailViewController" bundle:nil ridding:ridding isMyHome:FALSE toUser:ridding.leaderUser];
  [self.navigationController pushViewController:pdVCTL animated:YES];
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

  if (!_isTheEnd) {
    [_ego egoRefreshScrollViewDidScroll:scrollView];
  }
    [_top_Ego egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  
  [self downLoadMapRoutes];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  
  if (!decelerate) {
    [self downLoadMapRoutes];
  }
  if (!_isTheEnd) {
    [_ego egoRefreshScrollViewDidEndDragging:scrollView];
  }
  [_top_Ego egoRefreshScrollViewDidEndDragging:scrollView];
}



- (void)downLoadMapRoutes {
  
  NSArray *cellArray = [self.tv visibleCells];
  if (cellArray) {
    for (int i=0;i<[cellArray count];i++) {
      NSMutableArray *routes = [[NSMutableArray alloc] init];
      QQNRFeedTableCell *cell=(QQNRFeedTableCell*)[cellArray objectAtIndex:i];
      if(cell==nil){
        return;
      }
      dispatch_queue_t q;
      q = dispatch_queue_create("drawRoutes", NULL);
      dispatch_async(q, ^{
        Ridding *ridding = [_dataSource objectAtIndex:cell.index];
        NSArray *tempRoutes=(NSArray*)[[StaticInfo getSinglton].routesDic objectForKey:LONGLONG2NUM(ridding.riddingId)];
        [routes addObjectsFromArray:tempRoutes];
        if(!routes||[routes count]==0){
          int count = [RiddingLocationDao getRiddingLocationCount:ridding.riddingId];
          if (count > 0) {
            NSArray *routeArray = [RiddingLocationDao getRiddingLocations:ridding.riddingId beginWeight:0];
            for (RiddingLocation *location in routeArray) {
              CLLocation *loc = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longtitude];
              [routes addObject:loc];
            }
          } else {
            //如果数据库中存在，那么取数据库中的地图路径，如果不存在，http去请求服务器。
            //数据库中取出是mapTaps或者points
            NSMutableDictionary *map_dic = [self.requestUtil getMapMessage:ridding.riddingId userId:[StaticInfo getSinglton].user.userId];
            Map *map = [[Map alloc] initWithJSONDic:[map_dic objectForKey:keyMap]];
            NSArray *array = map.mapPoint;
            [[MapUtil getSinglton] calculate_routes_from:map.mapTaps map:map];
            [routes addObjectsFromArray:[[MapUtil getSinglton] decodePolyLineArray:array]];
            [RiddingLocationDao setRiddingLocationToDB:routes riddingId:ridding.riddingId];
          }
          [[StaticInfo getSinglton].routesDic setObject:routes forKey:LONGLONG2NUM(ridding.riddingId)];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
          if(cell){
            [cell drawRoutes:routes riddingId:ridding.riddingId];
          }
        });
      });
      
    }
  }
}


#pragma mark - EGO

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
    _extOffset=0;
    [self download];
  }
}

- (void)down_egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view {
  
  [self downEGOReload];
}

- (BOOL)down_egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view {
  
  return _isLoading; // should return if data source model is reloading
}



#pragma mark -
#pragma mark (QQNRFeedTableCellDelegate)
- (void)leaderTap:(QQNRFeedTableCell *)cell {
  
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    Ridding *ridding = [_dataSource objectAtIndex:cell.index];
    NSDictionary *dic = [self.requestUtil getUserProfile:ridding.leaderUser.userId sourceType:SOURCE_SINA needCheckRegister:NO];
    User *_user = [[User alloc] initWithJSONDic:[dic objectForKey:keyUser]];
    dispatch_async(dispatch_get_main_queue(), ^{
      QQNRFeedViewController *QQNRFVC = [[QQNRFeedViewController alloc] initWithUser:_user isFromLeft:FALSE];
      [self.navigationController pushViewController:QQNRFVC animated:YES];
    });
  });
}

- (void)statusTap:(QQNRFeedTableCell *)cell{
  
}


@end
