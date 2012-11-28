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
#import "NSDate+TomAddition.h"
#import "UserSettingViewController.h"
#import "TutorialViewController.h"
#import "UIColor+XMin.h"
#import "MapCreateVCTL.h"
#import "MapCreateDescVCTL.h"
#import "SinaApiRequestUtil.h"
#define dataLimit @"2"
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
  [self addTableHeader];
  _timeScroller=[[TimeScroller alloc]initWithDelegate:self];
  [self addTableFooter];
  [self initHUD];
  _cellCache=[[NSMutableDictionary alloc]init];
  _latestCreateTime=@"-1";
  _endCreateTime=@"0";
  _isTheEnd=FALSE;
  _isEGOUpReloading=FALSE;
  if(self.isMyFeedHome){
    [self initAwesomeView];
  }
  [self download:_latestCreateTime isLarger:0];
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
  _HUD.delegate=self;
  if(self.isMyFeedHome){
    self.barView.leftButton=nil;
  }
}

- (void)viewWillDisappear:(BOOL)animated{
  _FHV.delegate=nil;
  _timeScroller.delegate=nil;
  _ego.delegate=nil;
  _HUD.delegate=nil;

}
- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

- (id)initWithUser:(User*)nowUser exUser:(User*)exUser{
  self=[super init];
  if(self){
    _activities = [[NSMutableArray alloc] init];
    _nowUser=nowUser;
    _exUser=exUser;
  }
  return self;
}

- (void)download:(NSString*)time isLarger:(int)isLarger{
  if(_isLoading){
    return;
  }
  _isLoading=TRUE;
  [_HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSArray *array = [[RequestUtil getSinglton] getUserMaps:dataLimit createTime:time userId:_nowUser.userId isLarger:isLarger];
    [self doUpdate:array];
    dispatch_async(dispatch_get_main_queue(), ^{
      if([_activities count]==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"开始骑行之旅"
                                                        message:@"您的骑行之旅还没有骑行活动吗?^_^"
                                                       delegate:self cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"去创建一个", nil];
        [alert show];
        
      }
      if(self&&self.tv){
        UILabel *label=[_ego getStatusLabel];
        label.hidden=NO;
        [self.tv reloadData];
        [self loadImagesForOnscreenRows];
        [self doneLoadingTableViewData];
      }
      [_HUD hide:YES];
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
      ActivityInfo *actInfo = [[ActivityInfo alloc] init];
      [actInfo setProperties:dic];
      [_activities addObject:actInfo];
    }
    if(_isLoadOld){
      if([array count]<[dataLimit intValue]){
        _isTheEnd=TRUE;
        [self downLoadEnd];
      }
    }else{
      [self sortActivities];
    }
    ActivityInfo *info=(ActivityInfo*)[_activities objectAtIndex:0];
    _latestCreateTime = info.serverCreateTime;
   
    info=(ActivityInfo*)[_activities objectAtIndex:([_activities count]-1)];
    _endCreateTime=info.serverCreateTime;
  }
}
- (void) sortActivities{
  NSArray *sortDescriptors = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"createTime" ascending:NO], nil];
  [_activities sortUsingDescriptors:sortDescriptors];
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
  UILabel *label=[_ego getStatusLabel];
  label.textColor=[UIColor getColor:ColorBlue];
  [self.tv setTableFooterView:_ego];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  //QQNRFeedTableCell *cell=(QQNRFeedTableCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
  return 360;// [cell getCellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_activities count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *kCellID = @"CellID";
	QQNRFeedTableCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
  ActivityInfo *info=[_activities objectAtIndex:indexPath.row];

	if (cell == nil)
	{
		cell = [[QQNRFeedTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID info:info];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.delegate=self;
    cell.userInteractionEnabled=YES;
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressOnCell:)];
    [cell addGestureRecognizer:longPressRecognizer];
	}
  while ([cell.contentView.subviews lastObject] != nil) {
    [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
  }
  cell.info=info;
  UIView *contentView = [_cellCache objectForKey:[NSNumber numberWithInt:indexPath.row]];
  if(contentView){
    [cell.contentView addSubview:contentView];
  }else{
    UIView *contentView=[cell resetContentView:YES];
    [cell.contentView addSubview:contentView];
    [_cellCache setObject:contentView forKey:[NSNumber numberWithInt:indexPath.row]];
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityInfo *actInfo = [_activities objectAtIndex:indexPath.row];
    UserMap *userMap = [[UserMap alloc]initWithUser:_nowUser info:actInfo riddingStatus:actInfo.status];
    [self.navigationController pushViewController:userMap animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if(!_isLoading&&scrollView.contentOffset.y<-70){
    _isLoadOld=FALSE;
    [self download:_latestCreateTime isLarger:1];
  }
  
  [_timeScroller scrollViewDidScroll];
  if(!_isTheEnd){
    [_ego egoRefreshScrollViewDidScroll:scrollView];
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  [_timeScroller scrollViewDidEndDecelerating];
  [self loadImagesForOnscreenRows];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  [_timeScroller scrollViewWillBeginDragging];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  if (!decelerate) {
    [_timeScroller scrollViewDidEndDecelerating];
    //在滚动停止是加载图片
    [self loadImagesForOnscreenRows];
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
  ActivityInfo *info=_selectedCell.info;
  if ([str isEqualToString:@"完成活动"]) {
    [MobClick event:@"2012070206"];
    [[RequestUtil getSinglton] finishActivity:[info.dbId stringValue]];
    double totalDistance=[[StaticInfo getSinglton].user.totalDistance doubleValue]/1000;
    double distance=info.distance+totalDistance;
    NSDictionary *dic=[[NSDictionary alloc]initWithObjectsAndKeys:[NSString stringWithFormat:@"%0.2lf KM",distance],@"distance", nil];
    [info setEnd];
    [_cellCache removeAllObjects];
    [[NSNotificationCenter defaultCenter] postNotificationName:kFinishNotification object:self userInfo:dic];
    [self.tv reloadData];
    //tag 修改状态
    //info.status
  }else if([str isEqualToString:@"退出"]){
    [MobClick event:@"2012070207"];
    int statusCode = [[RequestUtil getSinglton] quitActivity:[info.dbId stringValue]];
    if (statusCode ==-300) {
      _HUD.mode = MBProgressHUDModeText;
      _HUD.labelText = @"请确认其他队员已退出";
      _HUD.margin = 5.f;
      _HUD.yOffset = 150.f;
      [_HUD hide:YES afterDelay:2];
    }else if(statusCode<0){
      _HUD.mode = MBProgressHUDModeText;
      _HUD.labelText = @"退出失败";
      _HUD.margin = 5.f;
      _HUD.yOffset = 150.f;
      [_HUD hide:YES afterDelay:2];
    }else{
      _HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
      _HUD.mode = MBProgressHUDModeCustomView;
      _HUD.labelText = @"操作成功";
      [_HUD hide:YES afterDelay:2];
      [_activities removeObject:info];
      [_cellCache removeAllObjects];
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
    if(cell.info.isLeader&&![cell.info isEnd]){
      showSheet = [[UIActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"完成活动" otherButtonTitles:@"退出",nil];
    }else if(![cell.info isEnd]){
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
  if ([_activities count] > 0)
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
    NSDictionary *dic= [[RequestUtil getSinglton]getUserProfile:info.leaderUserId sourceType:SOURCE_SINA];
    User *_user=[[User alloc]init];
    [_user setProperties:dic];
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
  ActivityInfo *info = [_activities objectAtIndex:indexPath.row];
  NSDate *date=[NSDate dateWithTimeIntervalSince1970:[info.createTime longLongValue]];
  return [date pd_beijingToLocalDate];
}

#pragma mark - EGO

- (void)reloadTableViewDataSource {
  if(!_isTheEnd){
    _isEGOUpReloading = YES;
    _isLoadOld=TRUE;
    [self download:_endCreateTime isLarger:0];
  }
}

- (void)doneLoadingTableViewData{
	//  model should call this when its done loading
	_isEGOUpReloading = NO;
  if(!_isTheEnd){
    [_ego egoRefreshScrollViewDataSourceDidFinishedLoading:self.tv];
  }
	
}

- (void)downLoadEnd{
      [_ego egoRefreshScrollViewDataSourceDidEnd:self.tv];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(UP_EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(UP_EGORefreshTableHeaderView*)view{
	
	return _isEGOUpReloading; // should return if data source model is reloading
}

#pragma mark - topbar UI
-(void)leftBtnClicked:(id)sender{
  [super leftBtnClicked:sender];

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
          [self download:_latestCreateTime isLarger:1];
    }
      break;
    default:
      DLog(@"error!");
      break;
  }
}

#pragma mark - MapCreateVCTL delegate
- (void)finishCreate:(MapCreateVCTL*)controller info:(MapCreateInfo*)info{
  [controller dismissModalViewControllerAnimated:NO];
  MapCreateDescVCTL *descVCTL=[[MapCreateDescVCTL alloc]initWithNibName:@"MapCreateDescVCTL" bundle:nil info:info];
  descVCTL.delegate=self;
  [self presentModalViewController:descVCTL animated:YES];
}
#pragma mark - MapCreateDescVCTL delegate
- (void)finishCreate:(MapCreateDescVCTL*)controller{
  [controller dismissModalViewControllerAnimated:YES];
  [_cellCache removeAllObjects];
  _isLoadOld=FALSE;
  [self download:_latestCreateTime isLarger:1];

}


@end
