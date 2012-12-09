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
#import "RequestUtil.h"
#import "PhotoUploadBlurView.h"
#import "RNBlurModalView.h"
#import "ImageUtil.h"
#import "PublicCommentVCTL.h"
#define pageSize 2
@interface PublicDetailViewController ()

@end

@implementation PublicDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
                 ridding:(Ridding*)ridding
             isMyHome:(BOOL)isMyHome
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _ridding=ridding;
    _isMyFeedHome=isMyHome;
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.tv.backgroundColor=[UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"feed_cbg")];
  [self addTableHeader];
  [self addTableFooter];
  _cellArray=[[NSMutableArray alloc]init];
  _cellPhotoDic=[[NSMutableDictionary alloc]init];
  if(self.isMyFeedHome){
    _photos= [[Photos alloc] init];
    _photos.riddingId=_ridding.riddingId;
    //显示同步按钮，更新按钮等
  }
  _extDateStr=nil;
  _lastUpdateTime=-1;
  [self downLoad];
}

- (void)downLoad{
  dispatch_async(dispatch_queue_create("downLoad", NULL), ^{
    NSArray *serverArray=[[RequestUtil getSinglton]getUploadedPhoto:_ridding.riddingId userId:[StaticInfo getSinglton].user.userId limit:pageSize lastUpdateTime:_lastUpdateTime];
    if([serverArray count]>0){
      NSMutableArray *mulArray=[[NSMutableArray alloc]init];
      for(NSDictionary *dic in serverArray){
        RiddingPicture *picture=[[RiddingPicture alloc]initWithJSONDic:[dic objectForKey:@"picture"]];
#warning 增加extdate
//        if(!_extDateStr||![_extDateStr isEqualToString:picture.takePicDate]){
//          picture.isFirstPic=TRUE;
//          _extDateStr=picture.take;
//        }else{
//          picture.isFirstPic=FALSE;
//        }
//        _extDateStr=picture.takePicDate;
        [mulArray addObject:picture];
      }
      if([mulArray count]<pageSize){
        _isTheEnd=TRUE;
        [_ego setHidden:YES];
      }else{
        [_ego setHidden:NO];
      }
      [_cellArray addObjectsFromArray:mulArray];
      RiddingPicture *picture=(RiddingPicture*)[_cellArray lastObject];
      _lastUpdateTime=picture.createTime;
    }
    [self checkMyPhotosToSync];
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.tv reloadData];
      [self doneLoadingTableViewData];
    });
  });
}


- (void)checkMyPhotosToSync{
  if(self.isMyFeedHome){
    _localPhotos= [[RiddingPictureDao getSinglton]getRiddingPicture:_ridding.riddingId userId:[StaticInfo getSinglton].user.userId];
    if(_localPhotos){
      for(RiddingPicture *picture in _cellArray){
        [_cellPhotoDic setObject:picture forKey:picture.fileName];
      }
      int needUpdateCount=0;
      for(RiddingPicture *picture in _localPhotos){
        if(!_cellPhotoDic||![_cellPhotoDic objectForKey:picture.fileName]){
          needUpdateCount++;
        }
      }
      if(needUpdateCount>0){
        dispatch_async(dispatch_get_main_queue(), ^{
          if(self){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"小提示"
                                                            message:[NSString stringWithFormat:@"您还有%d张照片没有同步，是否现在同步，让更多骑友看到您的骑行轨迹。",needUpdateCount]
                                                           delegate:self cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"同步", nil];
            [alert show];
          }
        });
      }
    }
  }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if(buttonIndex==1){
    [self uploadPhoto];
  }else{
  }
}

- (void)uploadPhoto{
  PhotoUploadBlurView *view=[[PhotoUploadBlurView alloc]initWithFrame:CGRectMake(0, 0, 260, 260)];
  RNBlurModalView *modal=[[RNBlurModalView alloc] initWithViewController:self view:view];
  [modal show];
  [view setValue:nil text:@"请稍候。。" value:0];
  dispatch_queue_t q;
  q=dispatch_queue_create("uploadPhoto", NULL);
  dispatch_async(q, ^{
    NSString *prefixPath=[NSString stringWithFormat:@"ridding/%lld/userId/%lld",_ridding.riddingId,[StaticInfo getSinglton].user.userId];
    [NSThread sleepForTimeInterval:1];
    int index=0;
    for(RiddingPicture *picture in _localPhotos){
      UIImage *image=[_photos getPhoto:picture.fileName];
      if(![_cellPhotoDic objectForKey:picture.fileName]){
        NSString *photoKey=[ImageUtil uploadPhotoToServer:[_photos getPhotoPath:picture.fileName] prefixPath:prefixPath type:IMAGETYPE_PICTURE];
        if(photoKey){
          picture.photoKey=[NSString stringWithFormat:@"%@",photoKey];
          [[RequestUtil getSinglton]uploadRiddingPhoto:picture];
        }
      }
      index++;
      dispatch_async(dispatch_get_main_queue(), ^{
        if(modal.isVisible){
          [view setValue:image text:[NSString stringWithFormat:@"第%d张(共%d张)",index,[_localPhotos count]] value:index*1.0/[_localPhotos count]];
          if(index==[_localPhotos count]){
            [view setValue:image text:@"已完成" value:index*1.0/[_localPhotos count]];
          }
        }
      });
    }
  });
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}




#pragma mark - QQNRFeedHeaderViewDelegate
- (void)addTableHeader{
  _headerView=[[PublicDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 280) ridding:_ridding];
  _headerView.delegate=self;
  [self.tv setTableHeaderView:_headerView];
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
  RiddingPicture *picture=[_cellArray objectAtIndex:indexPath.row];
  CGFloat viewHeight=PublicDetailCellDefaultSpace;
//  if(picture.isFirstPic){
//    viewHeight+=20;
//    viewHeight+=5;
//  }
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
  viewHeight+=16;
  CGSize size=[picture.pictureDescription sizeWithFont:[UIFont fontWithName:@"Arial" size:14] constrainedToSize:CGSizeMake(215, 999) lineBreakMode:UILineBreakModeWordWrap];
  viewHeight+=size.height;
  viewHeight+=5; //间距
  size=[@"20123123" sizeWithFont:[UIFont fontWithName:@"Arial" size:14] constrainedToSize:CGSizeMake(215, 999) lineBreakMode:UILineBreakModeWordWrap];
  viewHeight+=size.height;
  viewHeight+=5; //间距
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
  }else{
    cell.info=picture;
    cell.index=indexPath.row;
  }
  [cell initContentView];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
    _isEGOUpReloading = YES;
    [self downLoad];
  }
}

- (void)doneLoadingTableViewData{
	//  model should call this when its done loading
	_isEGOUpReloading = NO;
  if(!_isTheEnd){
    [_ego egoRefreshScrollViewDataSourceDidFinishedLoading:self.tv];
  }
	
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
}

- (IBAction)likeClick:(id)sender{
  [[RequestUtil getSinglton]likeRidding:_ridding.riddingId];
}
- (IBAction)careClick:(id)sender{
  [[RequestUtil getSinglton]careRidding:_ridding.riddingId];
}
- (IBAction)useClick:(id)sender{
  [[RequestUtil getSinglton]useRidding:_ridding.riddingId];
}
- (IBAction)commentAdd:(id)sender{
  Comment *comment=[[Comment alloc]init];
  comment.replyId=1;
  comment.commentType=1;
  comment.text=@"123";
  comment.usePicUrl=@"133";
  comment.userId=[StaticInfo getSinglton].user.userId;
  comment.toUserId=2;
  [[RequestUtil getSinglton]addRiddingComment:comment];
  PublicCommentVCTL *commentVCTL=[[PublicCommentVCTL alloc]initWithNibName:@"PublicCommentVCTL" bundle:nil ridding:_ridding];
  [self.navigationController pushViewController:commentVCTL animated:YES];
  
  
}

@end
