//
//  PublicDetailViewController.m
//  Ridding
//
//  Created by zys on 12-11-11.
//
//

#import "PublicDetailViewController.h"
#import "PublicCommentVCTL.h"
#import "SDWebImageManager.h"
#import "UserMap.h"
#import "QQNRImagesScrollVCTL.h"
#import "SVProgressHUD.h"
#import "QQNRFeedViewController.h"

#define pageSize 10

@interface PublicDetailViewController ()

@end

@implementation PublicDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
              ridding:(Ridding *)ridding
             isMyHome:(BOOL)isMyHome
               toUser:(User *)toUser {

  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _ridding = ridding;
    _isMyFeedHome = isMyHome;
    _toUser = toUser;
    if ([RiddingAppDelegate isMyFeedHome:_toUser]) {
      self.isMyFeedHome = TRUE;
    }
  }
  return self;
}

- (void)viewDidLoad {

  [super viewDidLoad];
  self.view.backgroundColor = [UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"qqnr_bg")];

  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back") forState:UIControlStateNormal];
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back_hl") forState:UIControlStateHighlighted];
  _deletePicIndex=-1;
  if (!self.isMyFeedHome) {

    _useBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _useBtn.frame = CGRectMake(190, 8, 32, 25);
    [_useBtn addTarget:self action:@selector(useClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.barView addSubview:_useBtn];

    _careBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_careBtn addTarget:self action:@selector(careClick:) forControlEvents:UIControlEventTouchUpInside];
    _careBtn.frame = CGRectMake(230, 8, 32, 25);
    [self.barView addSubview:_careBtn];

    _commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _commentBtn.frame = CGRectMake(270, 8, 32, 25);
    [_commentBtn addTarget:self action:@selector(commentAdd:) forControlEvents:UIControlEventTouchUpInside];
    [_commentBtn setBackgroundImage:UIIMAGE_FROMPNG(@"qqnr_pd_comment") forState:UIControlStateNormal];
    [_commentBtn setBackgroundImage:UIIMAGE_FROMPNG(@"qqnr_pd_comment_hl") forState:UIControlStateHighlighted];
    [self.barView addSubview:_commentBtn];

    [self.barView.titleLabel removeFromSuperview];
  } else {
    [self.barView.titleLabel setText:_ridding.riddingName];
  }

  [self addTableHeader];
  [self addTableFooter];
  _cellArray = [[NSMutableArray alloc] init];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(succUploadPicture:)
                                               name:kSuccUploadPictureNotification object:nil];

}

- (void)viewDidAppear:(BOOL)animated {

  [super viewDidAppear:animated];
  if (!self.didAppearOnce) {
    _isTheEnd = FALSE;
    _lastUpdateTime = -1;
    _extDateStr = nil;
    [self downLoad];
    if ([[RiddingAppDelegate shareDelegate] canLogin]) {
      [self downLoadRiddingAction];
    } else {
      [self resetActionBtn];
    }
    self.didAppearOnce = TRUE;
  }
}

- (void)downLoadRiddingAction {

  dispatch_async(dispatch_queue_create("downLoad", NULL), ^{
    NSDictionary *dic = [self.requestUtil getUserRiddingAction:_ridding.riddingId];
    if (dic) {
      Ridding *ridding = [[Ridding alloc] initWithJSONDic:[dic objectForKey:keyRidding]];
      if (ridding) {
        _ridding.nowUserCared = ridding.nowUserCared;
        _ridding.nowUserLiked = ridding.nowUserLiked;
        _ridding.nowUserUsed = ridding.nowUserUsed;
        _ridding.useCount = ridding.useCount;
        _ridding.careCount = ridding.careCount;
        _ridding.likeCount = ridding.likeCount;
        _ridding.commentCount = ridding.commentCount;
      }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      [self resetActionBtn];
    });
  });
}

- (void)downLoad {

  [SVProgressHUD showWithStatus:@"加载中"];
  dispatch_async(dispatch_queue_create("downLoad", NULL), ^{
    NSArray *serverArray = [self.requestUtil getUploadedPhoto:_ridding.riddingId limit:pageSize lastUpdateTime:_lastUpdateTime];
    [_cellArray removeAllObjects];
    if ([serverArray count] > 0) {
      NSMutableArray *mulArray = [[NSMutableArray alloc] init];
      for (NSDictionary *dic in serverArray) {
        RiddingPicture *picture = [[RiddingPicture alloc] initWithJSONDic:[dic objectForKey:keyRiddingPicture]];
        if (!_extDateStr || ![_extDateStr isEqualToString:picture.takePicDateStr]) {
          picture.isFirstPic = TRUE;
          _extDateStr = picture.takePicDateStr;
        } else {
          picture.isFirstPic = FALSE;
        }
        [mulArray addObject:picture];
      }
      [_cellArray addObjectsFromArray:mulArray];
    }
    RiddingPicture *picture = (RiddingPicture *) [_cellArray lastObject];
    _lastUpdateTime = picture.createTime;
    dispatch_async(dispatch_get_main_queue(), ^{
      if ([serverArray count] < pageSize) {
        _isTheEnd = TRUE;
        [_ego setHidden:YES];
      } else {
        [_ego setHidden:NO];
      }
      [self.tv reloadData];
      [self doneLoadingTableViewData];
      [SVProgressHUD dismiss];
    });
  });
}

- (void)didReceiveMemoryWarning {

  [super didReceiveMemoryWarning];
}

- (void)rightBtnClicked:(id)sender {

}


#pragma mark - QQNRFeedHeaderViewDelegate
- (void)addTableHeader {

  _headerView = [[PublicDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 260) ridding:_ridding isMyHome:_isMyFeedHome];
  _headerView.delegate = self;
  [self.tv setTableHeaderView:_headerView];

}

- (void)addTableFooter {

  _ego = [[UP_EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 10, SCREEN_WIDTH, 45) withBackgroundColor:[UIColor whiteColor]];
  _ego.delegate = self;
  [_ego setHidden:YES];
  [self.tv setTableFooterView:_ego];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

  RiddingPicture *picture = [_cellArray objectAtIndex:indexPath.row];
  CGFloat viewHeight = PublicDetailCellDefaultSpace;
  if (picture.isFirstPic) {
    viewHeight += 20;  // datelabel
    viewHeight += 5;//间距
  }
  CGFloat width = PublicDetailCellWidth;
  CGFloat height;
  if (picture.width == 0 || picture.height == 0) {
    height = PublicDetailCellWidth;
  } else if (picture.width / picture.height > 1) {
    height = picture.height * 1.0 / picture.width * width;
  } else {
    height = picture.height * 1.0 / picture.width * width;
  }
  viewHeight += height + 43;
  viewHeight += PublicDetailCellDefaultDownSpace;
  return viewHeight;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  return [_cellArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *kCellID = @"CellID";
  PublicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
  RiddingPicture *picture = [_cellArray objectAtIndex:indexPath.row];
  if (cell == nil) {
    cell = [[PublicDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID info:picture isMyFeedHome:self.isMyFeedHome];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
  }
  cell.info = picture;
  cell.index = indexPath.row;

  [cell initContentView];

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

  if (!_isTheEnd) {
    [_ego egoRefreshScrollViewDidScroll:scrollView];
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

  if (!decelerate) {
    //在滚动停止是加载图片
  }
  if (!_isTheEnd) {
    [_ego egoRefreshScrollViewDidEndDragging:scrollView];
  }
}

#pragma mark - EGO

- (void)reloadTableViewDataSource {

  if (!_isTheEnd) {
    _isLoading = YES;
    [self downLoad];
  }
}

- (void)doneLoadingTableViewData {
  //  model should call this when its done loading
  _isLoading = NO;
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

- (void)likeClick:(id)sender {

  RiddingAppDelegate *delegate = [RiddingAppDelegate shareDelegate];
  if (![delegate canLogin]) {
    [self showLoginAlertView];
    return;
  }
  NSDictionary *dic = [self.requestUtil likeRidding:_ridding.riddingId];
  [self updateRidding:dic];
}

- (void)careClick:(id)sender {

  RiddingAppDelegate *delegate = [RiddingAppDelegate shareDelegate];
  if (![delegate canLogin]) {
    [self showLoginAlertView];
    return;
  }
  NSDictionary *dic = [self.requestUtil careRidding:_ridding.riddingId];
  [self updateRidding:dic];
}

- (void)useClick:(id)sender {

  RiddingAppDelegate *delegate = [RiddingAppDelegate shareDelegate];
  if (![delegate canLogin]) {
    [self showLoginAlertView];
    return;
  }
  NSDictionary *dic = [self.requestUtil useRidding:_ridding.riddingId];
  [self updateRidding:dic];
  if (dic) {
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"恭喜恭喜" message:@"骑行活动创建成功,去看看吧!" delegate:self cancelButtonTitle:@"待会儿去" otherButtonTitles:@"走起!", nil];
    [view show];
  }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  
  if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"走起!"]) {
    QQNRFeedViewController *viewController=[[QQNRFeedViewController alloc]initWithUser:[StaticInfo getSinglton].user isFromLeft:FALSE];
    [self.navigationController pushViewController:viewController animated:YES];
  }
  [super alertView:alertView clickedButtonAtIndex:buttonIndex];
}


- (void)updateRidding:(NSDictionary *)dic {

  if (!dic) {
    return;
  }
  Ridding *returnRidding = [[Ridding alloc] initWithJSONDic:[dic objectForKey:keyRidding]];
  if (returnRidding) {
    _ridding.useCount = returnRidding.useCount;
    _ridding.likeCount = returnRidding.likeCount;
    _ridding.careCount = returnRidding.careCount;
    _ridding.commentCount = returnRidding.commentCount;
    _ridding.nowUserCared = returnRidding.nowUserCared;
    _ridding.nowUserLiked = returnRidding.nowUserLiked;
    _ridding.nowUserUsed = returnRidding.nowUserUsed;
    [self resetActionBtn];
  }
}

- (void)commentAdd:(id)sender {

  self.didAppearOnce = NO;
  PublicCommentVCTL *commentVCTL = [[PublicCommentVCTL alloc] initWithNibName:@"PublicCommentVCTL" bundle:nil ridding:_ridding];
  [self.navigationController pushViewController:commentVCTL animated:YES];
}


- (void)resetActionBtn {

  if (_ridding.nowUserUsed) {
    [_useBtn setBackgroundImage:UIIMAGE_FROMPNG(@"qqnr_join_disable") forState:UIControlStateNormal];
    [_useBtn setBackgroundImage:UIIMAGE_FROMPNG(@"qqnr_join_disable") forState:UIControlStateHighlighted];
    [_useBtn setEnabled:NO];
  } else {
    [_useBtn setEnabled:YES];
    [_useBtn setBackgroundImage:UIIMAGE_FROMPNG(@"qqnr_pd_join") forState:UIControlStateNormal];
    [_useBtn setBackgroundImage:UIIMAGE_FROMPNG(@"qqnr_pd_join_hl") forState:UIControlStateHighlighted];
    
  }
  if (_ridding.nowUserCared) {
    [_careBtn setBackgroundImage:UIIMAGE_FROMPNG(@"qqnr_care_disable") forState:UIControlStateNormal];
    [_careBtn setBackgroundImage:UIIMAGE_FROMPNG(@"qqnr_care_disable") forState:UIControlStateHighlighted];
    [_useBtn setEnabled:YES];
  } else {
    [_useBtn setEnabled:NO];
    [_careBtn setBackgroundImage:UIIMAGE_FROMPNG(@"qqnr_pd_care") forState:UIControlStateNormal];
    [_careBtn setBackgroundImage:UIIMAGE_FROMPNG(@"qqnr_pd_care_hl") forState:UIControlStateHighlighted];
  }

}
#pragma mark - RiddingViewController delegate
- (void)didFinishLogined:(QQNRSourceLoginViewController *)controller {

  [super didFinishLogined:controller];
  [self downLoadRiddingAction];
}

#pragma mark - PublicDetailCell delegate
- (void)imageViewClick:(PublicDetailCell *)view picture:(RiddingPicture *)picture imageView:(UIView *)imageView {

  QQNRImagesScrollVCTL *vctl = [[QQNRImagesScrollVCTL alloc] initWithNibName:@"QQNRImagesScrollVCTL" bundle:nil startPageIndex:view.index];
  vctl.photoArray = _cellArray;
  [self.navigationController pushViewController:vctl animated:YES];
}

- (BOOL)likeBtnClick:(PublicDetailCell *)view picture:(RiddingPicture *)picture {

  RiddingAppDelegate *delegate = [RiddingAppDelegate shareDelegate];
  if (![delegate canLogin]) {
    [self showLoginAlertView];
    return FALSE;
  }
  [self.requestUtil likeRiddingPicture:_ridding.riddingId pictureId:picture.dbId];
  return TRUE;

}

- (void)deletePicture:(PublicDetailCell *)view index:(int)index {
  
  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定要删除这张照片吗?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil];
  actionSheet.delegate = self;
  [actionSheet showInView:self.view];
  _deletePicIndex=index;
  
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
  
  
  NSString *str = [actionSheet buttonTitleAtIndex:buttonIndex];
  
  if ([str isEqualToString:@"删除照片"]) {
    RiddingPicture *picture=[_cellArray objectAtIndex:_deletePicIndex];
    [self.requestUtil deleteRiddingPicture:_ridding.riddingId pictureId:picture.dbId];
    [_cellArray removeObjectAtIndex:_deletePicIndex];
    _deletePicIndex=-1;
  }
}

#pragma mark - PublicDetailHeaderView delegate
- (void)mapViewTap:(PublicDetailHeaderView *)view {

  if (self.isMyFeedHome) {
    UserMap *map = [[UserMap alloc] initWithUser:_toUser ridding:_ridding];
    [self.navigationController pushViewController:map animated:YES];
  }
}

- (void)avatorClick:(PublicDetailHeaderView *)view {

  if (self.isMyFeedHome) {
    return;
  }
  QQNRFeedViewController *qqnrFeedVCTL = [[QQNRFeedViewController alloc] initWithUser:_toUser isFromLeft:FALSE];
  [self.navigationController pushViewController:qqnrFeedVCTL animated:YES];
}


#pragma mark - MapCreateDescVCTL delegate
- (void)succUploadPicture:(NSNotification *)note {

  [_cellArray removeAllObjects];
  _lastUpdateTime = -1;
  [self downLoad];
}

@end
