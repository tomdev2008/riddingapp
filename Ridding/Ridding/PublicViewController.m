//
//  PublicViewController.m
//  Ridding
//
//  Created by zys on 12-12-2.
//
//

#import "PublicViewController.h"
#import "PublicViewCell.h"
#import "RequestUtil.h"
#import "Utilities.h"
#import "QiNiuUtils.h"
#import "UIImageView+WebCache.h"
#import "PublicDetailViewController.h"
#import "UIColor+XMin.h"
#import "ActivityInfo.h"
#import "RequestUtil.h"
#define dataLimit 10
@interface PublicViewController ()

@end

@implementation PublicViewController

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
  self.tv.backgroundColor=[UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"feed_cbg")];

  _dataSource=[[NSMutableArray alloc]init];
  _endUpdateTime=-1;
  _endWeight=-1;
  _isTheEnd=FALSE;
  _isLoadOld=FALSE;
  _isLoading=FALSE;
  _type=ActivityInfoType_Recom;
  
  self.hasLeftView=TRUE;
  [self.barView.leftButton setTitle:@"主页" forState:UIControlStateNormal];
  [self.barView.leftButton setTitle:@"主页" forState:UIControlStateHighlighted];
  [self.barView.leftButton setHidden:NO];

  [self addTableHeader];
  [self addTableFooter];
  [self download];
}

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//时间是用在进行中的列表，weight是用在推荐列表
- (void)download{
  if(_isLoading){
    return;
  }
  _isLoading=TRUE;
  dispatch_async(dispatch_queue_create("download", NULL), ^{
    NSArray *serverArray=nil;
    if(_isLoadOld){
      serverArray= [[RequestUtil getSinglton] getRiddingPublicList:_endUpdateTime limit:dataLimit isLarger:0 type:_type weight:_endWeight];
    }else{
      serverArray= [[RequestUtil getSinglton] getRiddingPublicList:-1 limit:dataLimit isLarger:0 type:_type weight:-1];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      if(!_isLoadOld){
        [_dataSource removeAllObjects];
        _isTheEnd=FALSE;
      }
      [self doUpdate:serverArray];
      if(_isLoadOld){
        [self doneLoadingTableViewData];
        if([serverArray count]<dataLimit){
          _isTheEnd=TRUE;
          [_ego setHidden:YES];
        }else {
          [_ego setHidden:NO];
        }
      }else{
        [self doneDOWNLoadingTableViewData];
      }
      _isLoading=FALSE;
      [self.tv reloadData];
    });
  });
}

- (void)doUpdate:(NSArray*)array{
  if(array&&[array count]>0){
    for (NSDictionary *dic in array) {
      if([dic objectForKey:@"activity"]){
        ActivityInfo *actInfo = [[ActivityInfo alloc] initWithJSONDic:[dic objectForKey:@"activity"]];
        [_dataSource addObject:actInfo];
      }
    }
    if(_type==ActivityInfoType_Recom){
      ActivityInfo *info=(ActivityInfo*)[_dataSource lastObject];
      _endWeight = info.weight;
    }else{
      ActivityInfo *info=(ActivityInfo*)[_dataSource lastObject];
      _endUpdateTime=info.ridding.createTime;
    }
  }

}
- (void)addTableHeader{
  _top_Ego=[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, -45, SCREEN_WIDTH, 45)];
  _top_Ego.delegate=self;
  [self.tv setTableHeaderView:_top_Ego];
}

- (void)addTableFooter{
  _ego = [[UP_EGORefreshTableHeaderView alloc] initWithFrame: CGRectMake(0.0f, 10, SCREEN_WIDTH, 45) withBackgroundColor:[UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"feed_cbg")]];
  _ego.delegate = self;
  [self.tv setTableFooterView:_ego];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  return 160;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   PublicViewCell *cell = (PublicViewCell*)[Utilities cellByClassName:@"PublicViewCell" inNib:@"PublicViewCell" forTableView:self.tv];
  
  ActivityInfo *info=[_dataSource objectAtIndex:indexPath.row];
  NSURL *url=[QiNiuUtils getUrlBySizeToUrl:cell.firstPicImageView.frame.size url:info.firstPicUrl type:QINIUMODE_DEDEFAULT];
  [cell.firstPicImageView setImageWithURL:url placeholderImage:nil];
  cell.nameLabel.text=info.ridding.riddingName;
  cell.dateLabel.text=info.ridding.createTimeStr;
  cell.layer.borderWidth=1;
  cell.layer.borderColor=[[UIColor whiteColor]CGColor];
  cell.distanceLabel.text=[NSString stringWithFormat:@"%0.2fKM",info.ridding.map.distance*1.0/1000];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  ActivityInfo *actInfo = [_dataSource objectAtIndex:indexPath.row];
  PublicDetailViewController *pdVCTL=[[PublicDetailViewController alloc]initWithNibName:@"PublicDetailViewController" bundle:nil ridding:actInfo.ridding isMyHome:FALSE];
  [self.navigationController pushViewController:pdVCTL animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  if(!_isTheEnd){
    [_ego egoRefreshScrollViewDidScroll:scrollView];
  }
  [_top_Ego egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  if(!_isTheEnd){
    [_ego egoRefreshScrollViewDidEndDragging:scrollView];
  }
  [_top_Ego egoRefreshScrollViewDidEndDragging:scrollView];
  if (!decelerate) {
    //在滚动停止是加载图片
  }

}

#pragma mark - EGO delegate
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

- (void)downLoadEnd{
  [_ego egoRefreshScrollViewDataSourceDidFinishedLoading:self.tv];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(UP_EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(UP_EGORefreshTableHeaderView*)view{
	
	return _isLoading; // should return if data source model is reloading
}

#pragma mark - DownEGO
- (void)doneDOWNLoadingTableViewData{
	//  model should call this when its done loading
	[_top_Ego egoRefreshScrollViewDataSourceDidFinishedLoading:self.tv];
}

- (void)downEGOReload {
  if(!_isLoading){
    _isLoadOld=FALSE;
    [self download];
  }
}

- (void)down_egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self downEGOReload];
}

- (BOOL)down_egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _isLoading; // should return if data source model is reloading
}

@end
