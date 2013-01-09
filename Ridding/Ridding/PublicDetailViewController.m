//
//  PublicDetailViewController.m
//  Ridding
//
//  Created by zys on 12-11-11.
//
//

#import "PublicDetailViewController.h"
#import "UIColor+XMin.h"
#import "RequestUtil.h"
#import "PhotoUploadBlurView.h"
#import "RNBlurModalView.h"
#import "PublicCommentVCTL.h"
#import "QiNiuUtils.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "UserMap.h"
#import "User.h"
#import "QQNRImagesScrollVCTL.h"
#import "SVProgressHUD.h"
#import "QQNRFeedViewController.h"
#define pageSize 10
@interface PublicDetailViewController ()

@end

@implementation PublicDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
                 ridding:(Ridding*)ridding
             isMyHome:(BOOL)isMyHome
             toUser:(User*)toUser
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _ridding=ridding;
    _isMyFeedHome=isMyHome;
    _toUser=toUser;
    if([RiddingAppDelegate isMyFeedHome:_toUser]){
      self.isMyFeedHome=TRUE;
    }
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  UIImageView *bgImageView=[[UIImageView alloc]initWithImage:[UIIMAGE_FROMPNG(@"PublicDetail_BG") stretchableImageWithLeftCapWidth:0 topCapHeight:55]];
  [self.tv setBackgroundView:bgImageView];
  
  [self.barView.leftButton setTitle:@"返回" forState:UIControlStateNormal];
  [self.barView.leftButton setTitle:@"返回" forState:UIControlStateHighlighted];
  
  if(!self.isMyFeedHome){
    _likeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _likeBtn.frame=CGRectMake(90, 6, 31, 31);
    [_likeBtn addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
    _likeBtn.showsTouchWhenHighlighted=YES;
    [self.barView addSubview:_likeBtn];
    
    _careBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_careBtn addTarget:self action:@selector(careClick:) forControlEvents:UIControlEventTouchUpInside];
    _careBtn.frame=CGRectMake(150, 6, 31, 31);
    _careBtn.showsTouchWhenHighlighted=YES;
    [self.barView addSubview:_careBtn];
    
    _commentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _commentBtn.frame=CGRectMake(210, 6, 31, 31);
    [_commentBtn addTarget:self action:@selector(commentAdd:) forControlEvents:UIControlEventTouchUpInside];
    _commentBtn.showsTouchWhenHighlighted=YES;
    [self.barView addSubview:_commentBtn];
    [self.barView.titleLabel removeFromSuperview];
  }else{
    [self.barView.titleLabel setText:_ridding.riddingName];
    [self.barView.rightButton setTitle:@"设置" forState:UIControlStateNormal];
    [self.barView.rightButton setTitle:@"设置" forState:UIControlStateHighlighted];
    [self.barView.rightButton setHidden:NO];
  }
  
  [self addTableHeader];
  [self addTableFooter];
  _cellArray=[[NSMutableArray alloc]init];
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(succUploadPicture:)
                                               name:kSuccUploadPictureNotification
                                             object:nil];
  
}

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  if(!self.didAppearOnce){
    [_cellArray removeAllObjects];
    _isTheEnd=FALSE;
    _lastUpdateTime=-1;
    _extDateStr=nil;
    [self downLoad];
    if([[RiddingAppDelegate shareDelegate]canLogin]){
      [self downLoadRiddingAction];
    }else{
      [self resetActionBtn];
    }
    self.didAppearOnce=TRUE;
  }
}

- (void)downLoadRiddingAction{
  dispatch_async(dispatch_queue_create("downLoad", NULL), ^{
    NSDictionary *dic=[self.requestUtil getUserRiddingAction:_ridding.riddingId ];
    if(dic){
      Ridding *ridding=[[Ridding alloc]initWithJSONDic:[dic objectForKey:@"ridding"]];
      if(ridding){
        _ridding.nowUserCared=ridding.nowUserCared;
        _ridding.nowUserLiked=ridding.nowUserLiked;
        _ridding.nowUserUsed=ridding.nowUserUsed;
        _ridding.useCount=ridding.useCount;
        _ridding.careCount=ridding.careCount;
        _ridding.likeCount=ridding.likeCount;
        _ridding.commentCount=ridding.commentCount;
      }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      [self resetActionBtn];
    });
  });
}

- (void)downLoad{
  [SVProgressHUD showWithStatus:@"加载中"];
  dispatch_async(dispatch_queue_create("downLoad", NULL), ^{
    NSArray *serverArray=[self.requestUtil getUploadedPhoto:_ridding.riddingId limit:pageSize lastUpdateTime:_lastUpdateTime];
    if([serverArray count]>0){
      NSMutableArray *mulArray=[[NSMutableArray alloc]init];
      for(NSDictionary *dic in serverArray){
        RiddingPicture *picture=[[RiddingPicture alloc]initWithJSONDic:[dic objectForKey:@"picture"]];
        if(!_extDateStr||![_extDateStr isEqualToString:picture.takePicDateStr]){
          picture.isFirstPic=TRUE;
          _extDateStr=picture.takePicDateStr;
        }else{
          picture.isFirstPic=FALSE;
        }
        [mulArray addObject:picture];
      }
      [_cellArray addObjectsFromArray:mulArray];
    }
    RiddingPicture *picture=(RiddingPicture*)[_cellArray lastObject];
    _lastUpdateTime=picture.createTime;
    dispatch_async(dispatch_get_main_queue(), ^{
      if([serverArray count]<pageSize){
        _isTheEnd=TRUE;
        [_ego setHidden:YES];
      }else{
        [_ego setHidden:NO];
      }
      [self.tv reloadData];
      [self doneLoadingTableViewData];
      [SVProgressHUD dismiss];
    });
  });
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

-(void)rightBtnClicked:(id)sender{
  
}


#pragma mark - QQNRFeedHeaderViewDelegate
- (void)addTableHeader{
  _headerView=[[PublicDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 280) ridding:_ridding isMyHome:_isMyFeedHome];
  _headerView.delegate=self;
  [self.tv setTableHeaderView:_headerView];

}

- (void)addTableFooter{
  _ego = [[UP_EGORefreshTableHeaderView alloc] initWithFrame: CGRectMake(0.0f, 10, SCREEN_WIDTH, 45) withBackgroundColor:[UIColor whiteColor]];
  _ego.delegate = self;
  [_ego setHidden:YES];
  [self.tv setTableFooterView:_ego];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  RiddingPicture *picture=[_cellArray objectAtIndex:indexPath.row];
  CGFloat viewHeight=PublicDetailCellDefaultSpace;
  if(picture.isFirstPic){
    viewHeight+=20;  // datelabel
    viewHeight+=5;//间距
  }
  CGFloat width=PublicDetailCellWidth;
  CGFloat height;
  if(picture.width==0||picture.height==0){
    height=PublicDetailCellWidth;
  }else if(picture.width/picture.height>1){
    height=picture.height*1.0/picture.width*width;
  }else{
    height=picture.height*1.0/picture.width*width;
  }
  viewHeight+=height;
  viewHeight+=PublicDetailCellDefaultDownSpace;
  return viewHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [_cellArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *kCellID = @"CellID";
	PublicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
  RiddingPicture *picture=[_cellArray objectAtIndex:indexPath.row];
	if (cell == nil)
	{
		cell = [[PublicDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID info:picture];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.delegate=self;
  }
  cell.info=picture;
  cell.index=indexPath.row;

  [cell initContentView];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  
}

#pragma mark UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  
  if(!_isTheEnd){
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
  if(!_isTheEnd){
    [_ego egoRefreshScrollViewDidEndDragging:scrollView];
  }
}

#pragma mark - EGO

- (void)reloadTableViewDataSource {
  if(!_isTheEnd){
    _isLoading = YES;
    [self downLoad];
  }
}

- (void)doneLoadingTableViewData{
	//  model should call this when its done loading
	_isLoading = NO;
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

- (void)likeClick:(id)sender{
  RiddingAppDelegate *delegate=[RiddingAppDelegate shareDelegate];
  if(![delegate canLogin]){
    [self showLoginAlertView];
    return;
  }
  NSDictionary *dic=[self.requestUtil likeRidding:_ridding.riddingId];
  [self updateRidding:dic];
}
- (void)careClick:(id)sender{
  RiddingAppDelegate *delegate=[RiddingAppDelegate shareDelegate];
  if(![delegate canLogin]){
     [self showLoginAlertView];
    return;
  }
  NSDictionary *dic=[self.requestUtil careRidding:_ridding.riddingId];
  [self updateRidding:dic];
}
- (void)useClick:(id)sender{
  RiddingAppDelegate *delegate=[RiddingAppDelegate shareDelegate];
  if(![delegate canLogin]){
    [self showLoginAlertView];
    return;
  }
  NSDictionary *dic=[self.requestUtil useRidding:_ridding.riddingId];
  [self updateRidding:dic];
}

- (void)updateRidding:(NSDictionary*)dic{
  if(!dic){
    return;
  }
  Ridding *returnRidding=[[Ridding alloc]initWithJSONDic:[dic objectForKey:@"ridding"]];
  if(returnRidding){
    NSLog(@"%d",returnRidding.likeCount);
    _ridding.useCount=returnRidding.useCount;
    _ridding.likeCount=returnRidding.likeCount;
    _ridding.careCount=returnRidding.careCount;
    _ridding.commentCount=returnRidding.commentCount;
    _ridding.nowUserCared=returnRidding.nowUserCared;
    _ridding.nowUserLiked=returnRidding.nowUserLiked;
    _ridding.nowUserUsed=returnRidding.nowUserUsed;
    [self resetActionBtn];
  }
}

- (void)commentAdd:(id)sender{
  self.didAppearOnce=NO;
  PublicCommentVCTL *commentVCTL=[[PublicCommentVCTL alloc]initWithNibName:@"PublicCommentVCTL" bundle:nil ridding:_ridding];
  [self.navigationController pushViewController:commentVCTL animated:YES];
}

- (void)resetActionBtn{
  
  [_careBtn setTitle:[NSString stringWithFormat:@"%d",_ridding.careCount] forState:UIControlStateNormal];
  [_careBtn setTitle:[NSString stringWithFormat:@"%d",_ridding.careCount] forState:UIControlStateHighlighted];
  [_commentBtn setTitle:[NSString stringWithFormat:@"%d",_ridding.commentCount] forState:UIControlStateNormal];
  [_commentBtn setTitle:[NSString stringWithFormat:@"%d",_ridding.commentCount] forState:UIControlStateHighlighted];
  [_likeBtn setTitle:[NSString stringWithFormat:@"%d",_ridding.likeCount] forState:UIControlStateNormal];
  [_likeBtn setTitle:[NSString stringWithFormat:@"%d",_ridding.likeCount] forState:UIControlStateHighlighted];

  if(_ridding.nowUserUsed){
    
  }else{
    
  }
  if(_ridding.nowUserLiked){
    [_likeBtn setBackgroundImage:UIIMAGE_FROMPNG(@"navbar_like_xz") forState:UIControlStateNormal];
    [_likeBtn setBackgroundImage:UIIMAGE_FROMPNG(@"navbar_like_xz") forState:UIControlStateHighlighted];
  }else{
    [_likeBtn setBackgroundImage:UIIMAGE_FROMPNG(@"navbar_like") forState:UIControlStateNormal];
    [_likeBtn setBackgroundImage:UIIMAGE_FROMPNG(@"navbar_like") forState:UIControlStateHighlighted];
  }
  if(_ridding.nowUserCared){
    [_careBtn setBackgroundImage:UIIMAGE_FROMPNG(@"navbar_care_xz") forState:UIControlStateNormal];
    [_careBtn setBackgroundImage:UIIMAGE_FROMPNG(@"navbar_care_xz") forState:UIControlStateHighlighted];
  }else{
    [_careBtn setBackgroundImage:UIIMAGE_FROMPNG(@"navbar_care") forState:UIControlStateNormal];
    [_careBtn setBackgroundImage:UIIMAGE_FROMPNG(@"navbar_care") forState:UIControlStateHighlighted];
  }
  [_commentBtn setBackgroundImage:UIIMAGE_FROMPNG(@"navbar_comment") forState:UIControlStateNormal];
  [_commentBtn setBackgroundImage:UIIMAGE_FROMPNG(@"navbar_comment") forState:UIControlStateHighlighted];

}
#pragma mark - RiddingViewController delegate
- (void)didFinishLogined:(QQNRSourceLoginViewController*)controller{
  [super didFinishLogined:controller];
  [self downLoadRiddingAction];
}

#pragma mark - PublicDetailCell delegate
- (void) imageViewClick:(PublicDetailCell*)view picture:(RiddingPicture*)picture imageView:(UIView *)imageView{
  QQNRImagesScrollVCTL *vctl = [[QQNRImagesScrollVCTL alloc] initWithNibName:@"QQNRImagesScrollVCTL" bundle:nil startPageIndex:view.index];
	vctl.photoArray = _cellArray;
	[self.navigationController pushViewController:vctl animated:YES];
}

#pragma mark - PublicDetailHeaderView delegate
- (void)mapViewTap:(PublicDetailHeaderView*)view{
  if(self.isMyFeedHome){
    UserMap *map=[[UserMap alloc]initWithUser:_toUser ridding:_ridding];
    [self.navigationController pushViewController:map animated:YES];
  }
}

- (void)avatorClick:(PublicDetailHeaderView*)view{
  QQNRFeedViewController *qqnrFeedVCTL=[[QQNRFeedViewController alloc]initWithUser:_toUser isFromLeft:FALSE];
  [self.navigationController pushViewController:qqnrFeedVCTL animated:YES];
}


#pragma mark - MapCreateDescVCTL delegate
- (void)succUploadPicture:(NSNotification *)note{
  [_cellArray removeAllObjects];
  _lastUpdateTime=-1;
  [self downLoad];
}

@end
