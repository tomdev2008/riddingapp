//
//  QQNRFeedViewController.m
//  Ridding
//
//  Created by zys on 12-9-27.
//
//

#import "QQNRFeedViewController.h"
#import "StaticInfo.h"
#import "RequestUtil.h"
#import "ActivityInfo.h"
#import "QQNRFeedTableCell.h"
#import "UserMap.h"
#import "NSDate+Addition.h"
#import "UserSettingViewController.h"
#import "TutorialViewController.h"
#import "UIColor+XMin.h"
#import "MapCreateVCTL.h"
#import "MapCreateDescVCTL.h"
#import "SinaApiRequestUtil.h"
#import "NSString+TomAddition.h"
#import "SVProgressHUD.h"
#import "Utilities.h"
#define dataLimit 10

@interface QQNRFeedViewController ()

@end

@implementation QQNRFeedViewController
@synthesize isMyFeedHome=_isMyFeedHome;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      
    }
    return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.tv.backgroundColor=[UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"feed_cbg")];
  self.barView.titleLabel.text=_nowUser.name;
  [self.barView.leftButton setTitle:@"主页" forState:UIControlStateNormal];
  [self.barView.leftButton setTitle:@"主页" forState:UIControlStateHighlighted];
  [self.barView.leftButton setHidden:NO];
  self.hasLeftView=TRUE;
  _timeScroller=[[TimeScroller alloc]initWithDelegate:self];
  [self addTableHeader];
  [self addTableFooter];
   _endCreateTime=-1;
  _isTheEnd=FALSE;
  _isLoadOld=FALSE;
  _dataSource = [[NSMutableArray alloc] init];
  if(self.isMyFeedHome){
    [self initAwesomeView];
  }
  [self download];
  if([[ResponseCodeCheck getSinglton] isWifi]){
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
   
    if([StaticInfo getSinglton].user.nowRiddingCount>=3&&![prefs objectForKey:@"recomComment"]){
      UIAlertView *alert=nil;
      if([StaticInfo getSinglton].user.nowRiddingCount>=10){
        alert= [[UIAlertView alloc] initWithTitle:@"喜欢这款骑行应用吗?"
                                          message:@"你已经是老玩家咯,希望得到您的好评"
                                         delegate:self cancelButtonTitle:@"我再玩玩看"
                                otherButtonTitles:@"这就去", nil];
        
      }else{
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

- (void)viewWillAppear:(BOOL)animated{
  _FHV.delegate=self;
  _timeScroller.delegate=self;
  _ego.delegate=self;
}

- (void)viewWillDisappear:(BOOL)animated{
  _FHV.delegate=nil;
  _timeScroller.delegate=nil;
  _ego.delegate=nil;

}
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (id)initWithUser:(User*)nowUser exUser:(User*)exUser{
  self=[super init];
  if(self){
    
    _nowUser=nowUser;
    _exUser=exUser;
  }
  return self;
}

- (void)download{
  if(_isLoading){
    return;
  }
  _isLoading=TRUE;
  [SVProgressHUD showWithStatus:@"请稍候"];
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSArray *array;
    if(_isLoadOld){
      array=[[RequestUtil getSinglton] getUserMaps:dataLimit createTime:_endCreateTime userId:_nowUser.userId isLarger:0];
    }else{
      array=[[RequestUtil getSinglton] getUserMaps:dataLimit createTime:-1 userId:_nowUser.userId isLarger:0];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      if(!_isLoadOld){
        [_dataSource removeAllObjects];
        _isTheEnd=FALSE;
      }else{
        [self doneLoadingTableViewData];
      }
      [self doUpdate:array];
      if(_isTheEnd){
        [_ego setHidden:YES];
      }else{
        [_ego setHidden:NO];
      }
      if([_dataSource count]==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"开始骑行之旅"
                                                        message:@"您的骑行之旅还没有骑行活动吗?^_^"
                                                       delegate:self cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"去创建一个", nil];
        [alert show];
      }
      [self.tv reloadData];
      [SVProgressHUD dismiss];
      _isLoading=FALSE;
    });
  });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if([[alertView buttonTitleAtIndex:buttonIndex]  isEqualToString:@"去创建一个"]){
    MapCreateVCTL *mapCreate=[[MapCreateVCTL alloc]init];
    mapCreate.delegate=self;
    [self presentModalViewController:mapCreate animated:YES];
  }else if([[alertView buttonTitleAtIndex:buttonIndex]  isEqualToString:@"还不错噢"]){
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkAppStore]];
  }else if([[alertView buttonTitleAtIndex:buttonIndex]  isEqualToString:@"这就去"]){
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:linkAppStore]];
  }
}


- (void)doUpdate:(NSArray*)array{
  if(array&&[array count]>0){
    for (NSDictionary *dic in array) {
      Ridding *ridding=[[Ridding alloc]initWithJSONDic:[dic objectForKey:@"ridding"]];

      [_dataSource addObject:ridding];
    }
    if([array count]<dataLimit){
      _isTheEnd=TRUE;
    }
    Ridding *ridding=(Ridding*)[_dataSource lastObject];
    _endCreateTime=ridding.createTime;
  }
}

#pragma mark - QQNRFeedHeaderViewDelegate
- (void)addTableHeader{
  _FHV=[[QQNRFeedHeaderView alloc]initWithFrame:CGRectMake(0, 0, 320, 180) user:_nowUser];
  _FHV.delegate=self;
  [self.tv setTableHeaderView:_FHV];
}

- (void)addTableFooter{
  _ego = [[UP_EGORefreshTableHeaderView alloc] initWithFrame: CGRectMake(0.0f, 10, 320, 45) withBackgroundColor:[UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"feed_cbg")]];
  _ego.delegate = self;
  [self.tv setTableFooterView:_ego];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 360;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  QQNRFeedTableCell *cell = (QQNRFeedTableCell*)[Utilities cellByClassName:@"QQNRFeedTableCell" inNib:@"QQNRFeedTableCell" forTableView:self.tv];
  cell.delegate=self;
  cell.userInteractionEnabled=YES;
  UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressOnCell:)];
  [cell addGestureRecognizer:longPressRecognizer];
  
  Ridding *ridding=[_dataSource objectAtIndex:indexPath.row];
  cell.ridding=ridding;
  [cell initContentView];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Ridding *ridding = [_dataSource objectAtIndex:indexPath.row];
    UserMap *userMap = [[UserMap alloc]initWithUser:_nowUser ridding:ridding riddingStatus:ridding.riddingStatus];
    [self.navigationController pushViewController:userMap animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
  [_timeScroller scrollViewDidScroll];
  if(!_isTheEnd){
    [_ego egoRefreshScrollViewDidScroll:scrollView];
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  [_timeScroller scrollViewDidEndDecelerating];
  //[self loadImagesForOnscreenRows];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  [_timeScroller scrollViewWillBeginDragging];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  if (!decelerate) {
    [_timeScroller scrollViewDidEndDecelerating];
  }
  if(!_isTheEnd){
     [_ego egoRefreshScrollViewDidEndDragging:scrollView];
  }
}

#pragma mark (ActionSheet)
- (void)longPressOnCell:(UILongPressGestureRecognizer*) gestureRecognize{
  if(_isShowingSheet){
    return;
  }
  [MobClick event:@"2012111909"];
  _isShowingSheet=TRUE;
  if([gestureRecognize.view isKindOfClass:[QQNRFeedTableCell class]]){
    QQNRFeedTableCell *cell=(QQNRFeedTableCell*)gestureRecognize.view;
    [self showActionSheet:cell];
  }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  NSString *str=[actionSheet buttonTitleAtIndex:buttonIndex];
  Ridding *ridding=_selectedCell.ridding;
  if ([str isEqualToString:@"完成活动"]) {
    [MobClick event:@"2012070206"];
    [[RequestUtil getSinglton] finishActivity:ridding.riddingId];
    int distance=(ridding.riddingId+[StaticInfo getSinglton].user.totalDistance)*1.0/1000;
    NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%0.2d KM",distance],@"distance", nil];
    [ridding setEnd];
    [[NSNotificationCenter defaultCenter] postNotificationName:kFinishNotification object:self userInfo:dic];
    [self.tv reloadData];
    //tag 修改状态
    //info.status
  }else if([str isEqualToString:@"退出"]){
    [MobClick event:@"2012070207"];
    int statusCode = [[RequestUtil getSinglton] quitActivity:ridding.riddingId];
    if (statusCode ==-300) {
      [SVProgressHUD showErrorWithStatus:@"请确认其他队员已退出" duration:2];
      
    }else if(statusCode<0){
      [SVProgressHUD showErrorWithStatus:@"退出失败" duration:2];
    }else{
      [SVProgressHUD showSuccessWithStatus:@"操作成功" duration:2];
      [_dataSource removeObject:ridding];
      [self.tv reloadData];
    }
  }
  _isShowingSheet=FALSE;
  return;
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
  _isShowingSheet=FALSE;
  [actionSheet setHidden:YES];
  [actionSheet removeFromSuperview];
}

- (void)showActionSheet:(QQNRFeedTableCell*)cell{
  if(self.isMyFeedHome&&cell){
    _selectedCell=cell;
    UIActionSheet *showSheet=nil;
    if([Ridding isLeader:cell.ridding.userRole]&&![cell.ridding isEnd]){
      showSheet = [[UIActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"完成活动" otherButtonTitles:@"退出",nil];
    }else if(![cell.ridding isEnd]){
      showSheet = [[UIActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出" otherButtonTitles:nil];
    }else{
      return;
    }
    showSheet.delegate=self;
    [showSheet showInView:self.view];
  }
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)
- (void)loadImagesForOnscreenRows
{
  if ([_dataSource count] > 0)
  {
    NSArray *visiblePaths = [self.tv indexPathsForVisibleRows];
    for (NSIndexPath *indexPath in visiblePaths)
    {
//      QQNRFeedTableCell *cell =(QQNRFeedTableCell*) [self.tv cellForRowAtIndexPath:indexPath];
//      if(![_stackViewCache objectForKey:cell.info.mapAvatorPicUrl]){
//        [cell inputStackView];
//        [_stackViewCache setObject:cell.stackView forKey:cell.info.mapAvatorPicUrl];
//      }
    }
  }
}

#pragma mark -
#pragma mark (QQNRFeedTableCellDelegate)
- (void)leaderTap:(ActivityInfo *)info{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSDictionary *dic= [[RequestUtil getSinglton]getUserProfile:info.ridding.leaderUser.userId sourceType:SOURCE_SINA];
    User *_user=[[User alloc]initWithJSONDic:[dic objectForKey:@"user"]];
    dispatch_async(dispatch_get_main_queue(), ^{
      if(self){
        QQNRFeedViewController *QQNRFVC=[[QQNRFeedViewController alloc]initWithUser:_user exUser:_nowUser];
        QQNRFVC.isMyFeedHome=FALSE;
        [self.navigationController pushViewController:QQNRFVC animated:YES];
      }
    });
  });
}

- (void)statusTap:(QQNRFeedTableCell *)cell{
  [MobClick event:@"2012111908"];
  [self showActionSheet:cell];
}
#pragma mark TimeScrollerDelegate Methods
- (UITableView *)tableViewForTimeScroller:(TimeScroller *)timeScroller {
  return self.tv;
}

- (NSDate *)dateForCell:(UITableViewCell *)cell {
  if (!cell) {
    return [NSDate date];
  }
  NSIndexPath *indexPath = [self.tv indexPathForCell:cell];
  Ridding *ridding = [_dataSource objectAtIndex:indexPath.row];
  return [ridding.createTimeStr pd_yyyyMMddDate];
}

#pragma mark - EGO

- (void)reloadTableViewDataSource {
  if(!_isTheEnd){
    _isLoadOld=TRUE;
    [self download];
  }
}

- (void)doneLoadingTableViewData{
	//  model should call this when its done loading
  if(!_isTheEnd){
    [_ego egoRefreshScrollViewDataSourceDidFinishedLoading:self.tv];
  }
	
}


- (void)egoRefreshTableHeaderDidTriggerRefresh:(UP_EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(UP_EGORefreshTableHeaderView*)view{
	
	return _isLoading; // should return if data source model is reloading
}





-(IBAction)initBtnPress:(id)sender{
  TutorialViewController *tutorialViewController = [[TutorialViewController alloc]initWithNibName:@"TutorialViewController" bundle:nil];
  [self presentModalViewController:tutorialViewController animated:YES];
}

#pragma mark - AwesomeView init and delegate
- (void)initAwesomeView{
  UIImage *storyMenuItemImage =UIIMAGE_FROMPNG(@"bg-menuitem");
  UIImage *storyMenuItemImagePressed = UIIMAGE_FROMPNG(@"bg-menuitem-highlighted");
  
  UIImage *mapCreateImg = UIIMAGE_FROMPNG(@"mapCreate_pen");
  
  UIImage *settingImg=UIIMAGE_FROMPNG(@"setting");
  UIImage *refreshImg=UIIMAGE_FROMPNG(@"feed_shuaxin");
  AwesomeMenuItem *starMenuItem1 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                         highlightedImage:storyMenuItemImagePressed
                                                             ContentImage:mapCreateImg
                                                  highlightedContentImage:nil];
  AwesomeMenuItem *starMenuItem2 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                         highlightedImage:storyMenuItemImagePressed
                                                             ContentImage:settingImg
                                                  highlightedContentImage:nil];
  AwesomeMenuItem *starMenuItem3 = [[AwesomeMenuItem alloc] initWithImage:storyMenuItemImage
                                                         highlightedImage:storyMenuItemImagePressed
                                                             ContentImage:refreshImg
                                                  highlightedContentImage:nil];
  
  
  NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2,starMenuItem3, nil];
  
  
  _menu = [[AwesomeMenu alloc] initWithFrame:CGRectMake(-130, 170, 38, 38) menus:menus];
  _menu.frame=CGRectMake(_menu.frame.origin.x, SCREEN_HEIGHT-(460-_menu.frame.origin.y), _menu.frame.size.width, _menu.frame.size.height);
	// customize menu
	_menu.rotateAngle = M_PI/5;
	_menu.menuWholeAngle = M_PI/2.5;
	_menu.timeOffset = 0.1f;
	_menu.farRadius = 200.0f;
	_menu.endRadius = 150.0f;
	_menu.nearRadius = 50.0f;
  _menu.delegate = self;
  [self.view addSubview:_menu];
  
}

- (void)AwesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx
{
  switch (idx) {
    case 0:
    {
      [MobClick event:@"2012111901"];
      MapCreateVCTL *mapCreate=[[MapCreateVCTL alloc]init];
      mapCreate.delegate=self;
      [self presentModalViewController:mapCreate animated:YES];
    }
      break;
    case 1:
    {
      UserSettingViewController *settingController=[[UserSettingViewController alloc]init];
      [self.navigationController pushViewController:settingController animated:YES];
    }
      break;
    case 2:
    {
      _isLoadOld=FALSE;
      [self download];
    }
      break;
    default:
      DLog(@"error!");
      break;
  }
}

#pragma mark - MapCreateVCTL delegate
- (void)finishCreate:(MapCreateVCTL*)controller info:(Map*)info{
  [controller dismissModalViewControllerAnimated:NO];
  MapCreateDescVCTL *descVCTL=[[MapCreateDescVCTL alloc]initWithNibName:@"MapCreateDescVCTL" bundle:nil info:info];
  descVCTL.delegate=self;
  [self presentModalViewController:descVCTL animated:YES];
}
#pragma mark - MapCreateDescVCTL delegate
- (void)finishCreate:(MapCreateDescVCTL*)controller{
  [controller dismissModalViewControllerAnimated:YES];
  _isLoadOld=FALSE;
  [self download];

}




@end
