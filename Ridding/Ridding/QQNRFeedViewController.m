//
//  QQNRFeedViewController.m
//  Ridding
//
//  Created by zys on 12-9-27.
//
//

#import "QQNRFeedViewController.h"
#import "UserSettingViewController.h"
#import "TutorialViewController.h"
#import "SVProgressHUD.h"
#import "Utilities.h"
#import "QQNRServerTaskQueue.h"
#import "PublicDetailViewController.h"
#import "QiNiuUtils.h"
#import "UIImageView+WebCache.h"
#import "RiddingLocationDao.h"
#import "MapUtil.h"

#define dataLimit 10

@interface QQNRFeedViewController ()

@end

@implementation QQNRFeedViewController
@synthesize isMyFeedHome = _isMyFeedHome;

- (id)initWithUser:(User *)toUser isFromLeft:(BOOL)isFromLeft {

  self = [super init];
  if (self) {
    _toUser = toUser;
    if ([RiddingAppDelegate isMyFeedHome:_toUser]) {
      self.isMyFeedHome = TRUE;
    }
    _isFromLeft = isFromLeft;
  }
  return self;
}

- (void)viewDidLoad {

  [super viewDidLoad];
  self.barView.titleLabel.text = _toUser.name;
  self.view.backgroundColor = [UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"QQNR_MAIN_BG")];
  self.tv.backgroundColor = [UIColor clearColor];

  if (_isFromLeft) {
    [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"QQNR_LIST") forState:UIControlStateNormal];
    [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"QQNR_LIST") forState:UIControlStateHighlighted];
    [self.barView.leftButton setHidden:NO];
    self.hasLeftView = TRUE;
  }

  _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_STATUS_BAR, SCREEN_WIDTH, QQNRFeedHeaderView_Default_Height)];
  NSURL *url = [QiNiuUtils getUrlByWidthToUrl:_backgroundImageView.frame.size.width url:_toUser.backGroundUrl type:QINIUMODE_DEDEFAULT];
  [_backgroundImageView setImageWithURL:url placeholderImage:nil];
  _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
  _backgroundImageView.clipsToBounds = YES;
  [self.view addSubview:_backgroundImageView];


  [self addTableHeader];
  [self addTableFooter];

  [self.view bringSubviewToFront:self.tv];

  _endCreateTime = -1;
  _isTheEnd = FALSE;
  _isLoadOld = FALSE;
  _dataSource = [[NSMutableArray alloc] init];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(succAddRidding:)
                                               name:kSuccAddRiddingNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(succUpdateBackground:)
                                               name:kSuccUploadBackgroundNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(succAddFriends:)
                                               name:kSuccAddFriendsNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {

  [super viewDidAppear:animated];
  if (!self.didAppearOnce) {
    self.didAppearOnce = TRUE;
    [self download];
    if ([[ResponseCodeCheck getSinglton] isWifi]) {
      NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

      if ([StaticInfo getSinglton].user.nowRiddingCount >= 3 && ![prefs objectForKey:@"recomComment"]) {
        UIAlertView *alert = nil;
        if ([StaticInfo getSinglton].user.nowRiddingCount >= 10) {
          alert = [[UIAlertView alloc] initWithTitle:@"喜欢这款骑行应用吗?"
                                             message:@"你已经是老玩家咯,希望得到您的好评"
                                            delegate:self cancelButtonTitle:@"我再玩玩看"
                                   otherButtonTitles:@"这就去", nil];

        } else {
          alert = [[UIAlertView alloc] initWithTitle:@"喜欢这款骑行应用吗?"
                                             message:@"玩了这么久，觉得这款应用如何?"
                                            delegate:self cancelButtonTitle:@"我再玩玩看"
                                   otherButtonTitles:@"还不错噢", nil];
        }
        [alert show];
        [prefs setObject:@"" forKey:@"recomComment"];
      }
    }
  }
}

- (void)didReceiveMemoryWarning {

  [super didReceiveMemoryWarning];
}


- (void)download {

  if (_isLoading) {
    return;
  }
  _isLoading = TRUE;
  [SVProgressHUD showWithStatus:@"请稍候"];
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSArray *array;
    if (_isLoadOld) {
      array = [self.requestUtil getUserMaps:dataLimit createTime:_endCreateTime userId:[StaticInfo getSinglton].user.userId isLarger:0];
    } else {
      array = [self.requestUtil getUserMaps:dataLimit createTime:-1 userId:[StaticInfo getSinglton].user.userId isLarger:0];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      if (!_isLoadOld) {
        [_dataSource removeAllObjects];
        _isTheEnd = FALSE;
      } else {
        [self doneLoadingTableViewData];
      }
      [self doUpdate:array];
      if (_isTheEnd) {
        [_ego setHidden:YES];
      } else {
        [_ego setHidden:NO];
      }
      if ([_dataSource count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"开始骑行之旅"
                                                        message:@"您的骑行之旅还没有骑行活动吗?^_^"
                                                       delegate:self cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"去创建一个", nil];
        [alert show];
      }
      [self.tv reloadData];
      [self downLoadMapRoutes];
      [SVProgressHUD dismiss];
      _isLoading = FALSE;
    });
  });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

  if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"去创建一个"]) {
    MapCreateVCTL *mapCreate = [[MapCreateVCTL alloc] init];
    [self presentModalViewController:mapCreate animated:YES];
  } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"还不错噢"]) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkAppStore]];
  } else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"这就去"]) {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkAppStore]];
  }
}


- (void)doUpdate:(NSArray *)array {

  if (array && [array count] > 0) {
    for (NSDictionary *dic in array) {
      Ridding *ridding = [[Ridding alloc] initWithJSONDic:[dic objectForKey:keyRidding]];

      [_dataSource addObject:ridding];
    }
    if ([array count] < dataLimit) {
      _isTheEnd = TRUE;
    }
    Ridding *ridding = (Ridding *) [_dataSource lastObject];
    _endCreateTime = ridding.createTime;
  }
}

#pragma mark - QQNRFeedHeaderViewDelegate
- (void)addTableHeader {

  _FHV = [[QQNRFeedHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, QQNRFeedHeaderView_Default_Height) user:_toUser];
  _FHV.backgroundColor = [UIColor clearColor];
  _FHV.delegate = self;
  [self.tv setTableHeaderView:_FHV];
}

- (void)addTableFooter {

  _ego = [[UP_EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 10, SCREEN_WIDTH, 45) withBackgroundColor:[UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"feed_cbg")]];
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

  QQNRFeedTableCell *cell = (QQNRFeedTableCell *) [Utilities cellByClassName:@"QQNRFeedTableCell" inNib:@"QQNRFeedTableCell" forTableView:self.tv];
  cell.backgroundColor = [UIColor clearColor];
  cell.delegate = self;
  cell.userInteractionEnabled = YES;
  cell.index = indexPath.row;
  UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressOnCell:)];
  [cell addGestureRecognizer:longPressRecognizer];

  Ridding *ridding = [_dataSource objectAtIndex:indexPath.row];
  [cell initContentView:ridding];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  Ridding *ridding = [_dataSource objectAtIndex:indexPath.row];
  PublicDetailViewController *pdVCTL = [[PublicDetailViewController alloc] initWithNibName:@"PublicDetailViewController" bundle:nil ridding:ridding isMyHome:_isMyFeedHome toUser:_toUser];
  [self.navigationController pushViewController:pdVCTL animated:YES];
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

  CGRect frame = _backgroundImageView.frame;
  if (scrollView.contentOffset.y < 0) {
    frame.size.height = QQNRFeedHeaderView_Default_Height - scrollView.contentOffset.y;
  } else if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < QQNRFeedHeaderView_Default_Height) {
    frame.size.height = QQNRFeedHeaderView_Default_Height - scrollView.contentOffset.y;
  } else if (scrollView.contentOffset.y > QQNRFeedHeaderView_Default_Height) {
    frame.size.height = 0;
  }
  [_backgroundImageView setFrame:frame];
  if (!_isTheEnd) {
    [_ego egoRefreshScrollViewDidScroll:scrollView];
  }
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
}


- (void)downLoadMapRoutes {

  NSArray *cellArray = [self.tv visibleCells];
  if (cellArray) {
    for (QQNRFeedTableCell *cell in cellArray) {
      NSMutableArray *routes = [[NSMutableArray alloc] init];
      dispatch_queue_t q;
      q = dispatch_queue_create("drawRoutes", NULL);
      dispatch_async(q, ^{
        Ridding *ridding = [_dataSource objectAtIndex:cell.index];
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
        [cell drawRoutes:routes];
      });

    }
  }
}

#pragma mark (ActionSheet)
- (void)longPressOnCell:(UILongPressGestureRecognizer *)gestureRecognize {

  if (_isShowingSheet) {
    return;
  }
  [MobClick event:@"2012111909"];
  _isShowingSheet = TRUE;
  if ([gestureRecognize.view isKindOfClass:[QQNRFeedTableCell class]]) {
    QQNRFeedTableCell *cell = (QQNRFeedTableCell *) gestureRecognize.view;
    [self showActionSheet:cell];
  }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

  NSString *str = [actionSheet buttonTitleAtIndex:buttonIndex];

  Ridding *ridding = [_dataSource objectAtIndex:_selectedCell.index];
  if ([str isEqualToString:@"完成活动"]) {
    [MobClick event:@"2012070206"];
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      [self.requestUtil finishActivity:ridding.riddingId];
      [ridding setEnd];
      [StaticInfo getSinglton].user.totalDistance += ridding.map.distance;
      dispatch_async(dispatch_get_main_queue(), ^{
        [_FHV finishRidding];
        [self.tv reloadData];
        [SVProgressHUD dismiss];
      });
    });
  } else if ([str isEqualToString:@"退出"]) {
    [MobClick event:@"2012070207"];
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      int returnCode = [self.requestUtil quitActivity:ridding.riddingId];
      dispatch_async(dispatch_get_main_queue(), ^{
        if (returnCode == kServerSuccessCode) {
          [_dataSource removeObject:ridding];
          [self.tv reloadData];
          [SVProgressHUD showSuccessWithStatus:@"退出成功" duration:1.0];
        }
        [SVProgressHUD dismiss];
      });
    });
  } else if ([str isEqualToString:@"相机"]) {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [self presentModalViewController:imagePicker animated:YES];
  } else if ([str isEqualToString:@"本地相册"]) {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentModalViewController:imagePicker animated:YES];
  }
  _isShowingSheet = FALSE;
  return;
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet {

  _isShowingSheet = FALSE;
  [actionSheet setHidden:YES];
  [actionSheet removeFromSuperview];
}

- (void)showActionSheet:(QQNRFeedTableCell *)cell {

  if (self.isMyFeedHome && cell) {
    _selectedCell = cell;
    UIActionSheet *showSheet = nil;
    Ridding *ridding = [_dataSource objectAtIndex:cell.index];
    if ([Ridding isLeader:ridding.userRole] && ![ridding isEnd]) {
      showSheet = [[UIActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"完成活动" otherButtonTitles:@"退出", nil];
    } else if (![ridding isEnd]) {
      showSheet = [[UIActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出" otherButtonTitles:nil];
    } else {
      return;
    }
    showSheet.delegate = self;
    [showSheet showInView:self.view];
  }
}

#pragma mark -
#pragma mark (QQNRFeedTableCellDelegate)
- (void)leaderTap:(QQNRFeedTableCell *)cell {

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    Ridding *ridding = [_dataSource objectAtIndex:cell.index];
    NSDictionary *dic = [self.requestUtil getUserProfile:ridding.leaderUser.userId sourceType:SOURCE_SINA];
    User *_user = [[User alloc] initWithJSONDic:[dic objectForKey:keyUser]];
    dispatch_async(dispatch_get_main_queue(), ^{
      if (self) {
        QQNRFeedViewController *QQNRFVC = [[QQNRFeedViewController alloc] initWithUser:_user isFromLeft:FALSE];
        [self.navigationController pushViewController:QQNRFVC animated:YES];
      }
    });
  });
}

- (void)statusTap:(QQNRFeedTableCell *)cell {

  [MobClick event:@"2012111908"];
  [self showActionSheet:cell];
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

- (IBAction)initBtnPress:(id)sender {

  TutorialViewController *tutorialViewController = [[TutorialViewController alloc] initWithNibName:@"TutorialViewController" bundle:nil];
  [self presentModalViewController:tutorialViewController animated:YES];
}


#pragma mark - MapCreateVCTL delegate
- (void)finishCreate:(MapCreateVCTL *)controller ridding:(Ridding *)ridding {

  [controller dismissModalViewControllerAnimated:NO];
  MapCreateDescVCTL *descVCTL = [[MapCreateDescVCTL alloc] initWithNibName:@"MapCreateDescVCTL" bundle:nil ridding:ridding];

  [self presentModalViewController:descVCTL animated:YES];
}
#pragma mark - MapCreateDescVCTL delegate
- (void)succAddRidding:(NSNotification *)note {

  _isLoadOld = FALSE;
  [self download];
}

#pragma mark - QQNRFeedHeaderView delegate
- (void)backGroupViewClick:(QQNRFeedHeaderView *)view {

  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择照片来源" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"相机" otherButtonTitles:@"本地相册", nil];
  actionSheet.delegate = self;
  [actionSheet showInView:self.view];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

  UIImage *newImage = [info objectForKey:UIImagePickerControllerOriginalImage];
  CGFloat width;
  CGFloat height;
  if (newImage.imageOrientation == UIImageOrientationLeft || newImage.imageOrientation == UIImageOrientationRight) {
    width = CGImageGetHeight([newImage CGImage]);
    height = CGImageGetWidth([newImage CGImage]);
  } else {
    width = CGImageGetWidth([newImage CGImage]);
    height = CGImageGetHeight([newImage CGImage]);
  }
  QQNRServerTask *task = [[QQNRServerTask alloc] init];
  task.step = STEP_UPLOADBACKGROUNDPHOTO;
  File *file = [[File alloc] init];
  file.fileImage = newImage;
  file.width = width;
  file.height = height;
  NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
  SET_DICTIONARY_A_OBJ_B_FOR_KEY_C_ONLYIF_B_IS_NOT_NIL(dic, file, kFileClientServerUpload_File);
  task.paramDic = dic;

  QQNRServerTaskQueue *queue = [QQNRServerTaskQueue sharedQueue];
  [queue addTask:task withDependency:NO];
  [picker dismissModalViewControllerAnimated:YES];
}

- (void)succUpdateBackground:(NSNotification *)noti {

  NSString *urlStr = [StaticInfo getSinglton].user.backGroundUrl;
  NSLog(@"%@", urlStr);
  NSURL *url = [QiNiuUtils getUrlBySizeToUrl:_backgroundImageView.frame.size url:urlStr type:QINIUMODE_DEDEFAULT];
  [_backgroundImageView setImageWithURL:url];
}

- (void)succAddFriends:(NSNotification *)notif {

  self.didAppearOnce = FALSE;
}

@end
