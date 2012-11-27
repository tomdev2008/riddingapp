//
//  PublicDetailViewController.m
//  Ridding
//
//  Created by zys on 12-11-11.
//
//

#import "PublicDetailViewController.h"
#import "UIColor+XMin.h"
#import "RiddingPictureDao.h"
#import "Photos.h"
@interface PublicDetailViewController ()

@end

@implementation PublicDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil info:(ActivityInfo*)info
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _info=info;
    
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.tv.backgroundColor=[UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"feed_cbg")];
  [self addTableHeader];
  _timeScroller=[[TimeScroller alloc]initWithDelegate:self];
  _contentViewCache=[[NSMutableDictionary alloc]init];
  _cellArray=[[NSMutableArray alloc]init];
  [self addTableFooter];
  [self initHUD];
  NSArray *array= [[RiddingPictureDao getSinglton]getRiddingPicture:_info.dbId userId:_info.leaderUserId];
  if(array){
    [_cellArray addObjectsFromArray:array];
    Photos *photo= [[Photos alloc] init];
    photo.riddingId=[_info.dbId stringValue];
    for(RiddingPicture *picture in _cellArray){
      picture.image = [photo getPhoto:picture.fileName];
    }
  }
  self.barView.titleLabel.text=@"相片描述";
  
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - QQNRFeedHeaderViewDelegate
- (void)addTableHeader{
  _headerView=[[PublicDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, 320, 180) info:_info];
  _headerView.delegate=self;
  [self.tv setTableHeaderView:_headerView];
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
  PublicDetailCell *cell=(PublicDetailCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
  return [cell getCellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_cellArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *kCellID = @"CellID";
	PublicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[PublicDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID info:[_cellArray objectAtIndex:indexPath.row]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.delegate=self;
  }else{
    while ([cell.contentView.subviews lastObject] != nil) {
      [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    UIView *contentView = [_contentViewCache objectForKey:indexPath];
    if(contentView!=nil){
      [cell.contentView addSubview:contentView];
    }else{
      cell.info=[_cellArray objectAtIndex:indexPath.row];
      UIView *contentView=[cell resetContentView];
      [_contentViewCache setObject:contentView forKey:indexPath];
    }
  }
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if(!_isLoading&&scrollView.contentOffset.y<-100){
    // _isLoadOld=FALSE;
    // [self download:_latestCreateTime isLarger:1];
  }
  
  [_timeScroller scrollViewDidScroll];
  if(!_isTheEnd){
    [_ego egoRefreshScrollViewDidScroll:scrollView];
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  [_timeScroller scrollViewDidEndDecelerating];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  [_timeScroller scrollViewWillBeginDragging];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  if (!decelerate) {
    [_timeScroller scrollViewDidEndDecelerating];
    //在滚动停止是加载图片
  }
  if(!_isTheEnd){
    [_ego egoRefreshScrollViewDidEndDragging:scrollView];
  }
}



#pragma mark TimeScrollerDelegate Methods
- (UITableView *)tableViewForTimeScroller:(TimeScroller *)timeScroller {
  return self.tv;
}

- (NSDate *)dateForCell:(UITableViewCell *)cell {
  //  if (!cell) {
  //    return [NSDate date];
  //  }
  //  NSIndexPath *indexPath = [self.tv indexPathForCell:cell];
  //  ActivityInfo *info = [_activities objectAtIndex:indexPath.row];
  //  NSDate *date=[NSDate dateWithTimeIntervalSince1970:[info.createTime longLongValue]];
  //  return [date pd_beijingToLocalDate];
  return [NSDate date];
}

#pragma mark - EGO

- (void)reloadTableViewDataSource {
  if(!_isTheEnd){
    _isEGOUpReloading = YES;
    // [self download:_endCreateTime isLarger:0];
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

-(void)rightBtnClicked:(id)sender{
  [super rightBtnClicked:sender];
  //  UserSettingViewController *settingController=[[UserSettingViewController alloc]init];
  //  [self.navigationController pushViewController:settingController animated:YES];
}



@end
