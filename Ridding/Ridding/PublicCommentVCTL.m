//
//  PublicCommentVCTL.m
//  Ridding
//
//  Created by zys on 12-12-9.
//
//

#import "PublicCommentVCTL.h"
#import "NSString+TomAddition.h"
#import "Utilities.h"
#import "SVProgressHUD.h"

#define pageSize 10

@interface PublicCommentVCTL ()

@end

@implementation PublicCommentVCTL

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil ridding:(Ridding *)ridding {

  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _ridding = ridding;
  }
  return self;
}

- (void)viewDidLoad {

  [super viewDidLoad];
  self.view.backgroundColor = [UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"qqnr_bg")];

  [self.barView.titleLabel removeFromSuperview];
  UIButton *imageTitlebtn=[UIButton buttonWithType:UIButtonTypeCustom];
  imageTitlebtn.frame=self.barView.titleLabel.frame;
  [imageTitlebtn setImage:UIIMAGE_FROMPNG(@"qqnr_pd_comment_title") forState:UIControlStateNormal];
  [imageTitlebtn setImage:UIIMAGE_FROMPNG(@"qqnr_pd_comment_title") forState:UIControlStateHighlighted];
  [self.barView addSubview:imageTitlebtn];
  
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back") forState:UIControlStateNormal];
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back") forState:UIControlStateHighlighted];
  [self.barView.leftButton setHidden:NO];
  
  _dataSource = [[NSMutableArray alloc] init];
  _endCreateTime = -1;
  _isTheEnd = FALSE;
  _isLoadOld = FALSE;
  _isLoading = FALSE;
  
  [self addTableHeader];
  [self addTableFooter];
  [self setupGrowingTextField];


  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];

}

- (void)viewDidAppear:(BOOL)animated {

  [super viewDidAppear:animated];
  if (!self.didAppearOnce) {
    self.didAppearOnce = TRUE;
    [self download];
  }
}

- (void)addCommentToServer:(NSString *)text {

  dispatch_async(dispatch_queue_create("download", NULL), ^{
    Comment *comment = [[Comment alloc] init];
    comment.replyId = _replyId;
    if (_replyId == 0) {
      comment.commentType = COMMENTTYPE_COMMENT;
    } else {
      comment.commentType = COMMENTTYPE_REPLY;
    }
    comment.text = text;
    comment.usePicUrl = @"";
    comment.riddingId = _ridding.riddingId;
    comment.userId = [StaticInfo getSinglton].user.userId;
    comment.toUserId = _toUserId;

    NSDictionary *dic = [self.requestUtil addRiddingComment:comment];
    dispatch_async(dispatch_get_main_queue(), ^{
      if (dic) {
        _textView.text = @"";
        _isTheEnd = FALSE;
        _endCreateTime = -1;
        [self download];
      }
      [SVProgressHUD dismiss];
    });
  });

}

//时间是用在进行中的列表，weight是用在推荐列表
- (void)download {

  if (_isLoading) {
    return;
  }
  _isLoading = TRUE;
  [SVProgressHUD showWithStatus:@"加载中"];
  dispatch_async(dispatch_queue_create("download", NULL), ^{
    NSArray *serverArray = [self.requestUtil getRiddingComment:_endCreateTime limit:pageSize isLarger:0 riddingId:_ridding.riddingId];
    if (!_isLoadOld) {
      [_dataSource removeAllObjects];
    }
    [self doUpdate:serverArray];
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.tv reloadData];
      if ([serverArray count] < pageSize) {
        _isTheEnd = TRUE;
        [_ego setHidden:YES];
      } else {
        [_ego setHidden:NO];
      }
      if (_isLoadOld) {
        [self doneLoadingTableViewData];
      } else {
        [self doneDOWNLoadingTableViewData];
      }
      _isLoading = FALSE;
      [SVProgressHUD dismiss];
    });
  });
}

- (void)doUpdate:(NSArray *)array {

  if (array && [array count] > 0) {
    for (NSDictionary *dic in array) {
      if ([dic objectForKey:keyComment]) {
        Comment *comment = [[Comment alloc] initWithJSONDic:[dic objectForKey:keyComment]];
        [_dataSource addObject:comment];

      }
    }
    Comment *comment = (Comment *) [_dataSource lastObject];
    _endCreateTime = comment.createTime;
  }

}

- (void)addTableHeader {

  _top_Ego = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0, SCREEN_WIDTH, 45)];
  _top_Ego.delegate = self;
  _top_Ego.backgroundColor=[UIColor clearColor];
  [self.tv setTableHeaderView:_top_Ego];
}

- (void)addTableFooter {

  _ego = [[UP_EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 10, SCREEN_WIDTH, 45) withBackgroundColor:[UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"feed_cbg")]];
  _ego.delegate = self;
  _ego.backgroundColor=[UIColor clearColor];
  [self.tv setTableFooterView:_ego];
}


- (void)didReceiveMemoryWarning {

  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
#pragma mark - PublicCommentCell delegate
- (void)callBackBtnClick:(PublicCommentCell *)cell {

  Comment *comment = [_dataSource objectAtIndex:cell.index];
  _toUserId = comment.user.userId;
  _replyId = comment.replyId;
  _beginStr = [NSString stringWithFormat:@"回复%@:", comment.user.name];
  [_textView setText:_beginStr];
  [_textView becomeFirstResponder];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

  return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

  Comment *comment = [_dataSource objectAtIndex:indexPath.row];
  return [PublicCommentCell cellHeightByCommentInfo:comment];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  static NSString *kCellID = @"CellID";
  PublicCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
  Comment *comment = [_dataSource objectAtIndex:indexPath.row];
  if (cell == nil) {
    cell = [[PublicCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID comment:comment];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
  }
  cell.comment = comment;
  cell.index = indexPath.row;
  [cell initContentView];

  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

  [_textView resignFirstResponder];
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

- (void)downLoadEnd {

  [_ego egoRefreshScrollViewDataSourceDidFinishedLoading:self.tv];
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
    _endCreateTime = -1;
    [self download];
  }
}

- (void)down_egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view {

  [self downEGOReload];
}

- (BOOL)down_egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view {

  return _isLoading; // should return if data source model is reloading
}


- (void)setupGrowingTextField {

  _tContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 50, SCREEN_WIDTH, 50)];
  
  _textBgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _tContainerView.frame.size.width, _tContainerView.frame.size.height)];
  _textBgView.image=[UIIMAGE_FROMPNG(@"qqnr_pd_comment_tabbar_bg") stretchableImageWithLeftCapWidth:10 topCapHeight:10];
  [_tContainerView addSubview:_textBgView];
  
  _textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(17, 10, 250, 31)];
  _textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
  
  _textView.minNumberOfLines = 1;
  _textView.maxNumberOfLines = 6;
  _textView.returnKeyType = UIReturnKeyDefault;
  _textView.font = [UIFont systemFontOfSize:14.0f];
  _textView.delegate = self;
  _textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
  _textView.textColor=[UIColor whiteColor];
  _textView.backgroundColor = [UIColor clearColor];

  [self.view addSubview:_tContainerView];

  UIImage *rawBackground = UIIMAGE_FROMPNG(@"qqnr_pd_comment_tabbar_ib");
  UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
  UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
  imageView.frame = _textView.frame;
  imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

  _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

  // view hierachy
  [_tContainerView addSubview:imageView];
  [_tContainerView addSubview:_textView];
  
  _tSendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  _tSendBtn.frame = CGRectMake(_tContainerView.frame.size.width - 45, 15, 24, 24);
  _tSendBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
  [_tSendBtn setImage:UIIMAGE_FROMPNG(@"qqnr_pd_comment_tabbar_sent") forState:UIControlStateNormal];
  [_tSendBtn setImage:UIIMAGE_FROMPNG(@"qqnr_pd_comment_tabbar_sent_hl") forState:UIControlStateHighlighted];
  _tSendBtn.showsTouchWhenHighlighted=YES;
  [_tSendBtn addTarget:self action:@selector(sendBtnPressed:) forControlEvents:UIControlEventTouchUpInside];

  
  [_tContainerView addSubview:_tSendBtn];
  _tContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

}

- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView {

  RiddingAppDelegate *delegate = [RiddingAppDelegate shareDelegate];
  if (![delegate canLogin]) {
    [self showLoginAlertView];
    return FALSE;
  }
  return TRUE;
}


- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height {

  float diff = (growingTextView.frame.size.height - height);
  CGRect r = _tContainerView.frame;
  r.size.height -= diff;
  r.origin.y += diff;
  _tContainerView.frame = r;

  _textBgView.frame=CGRectMake(0, 0, _tContainerView.frame.size.width, _tContainerView.frame.size.height);
  _textBgView.image=[UIIMAGE_FROMPNG(@"qqnr_pd_comment_tabbar_bg") stretchableImageWithLeftCapWidth:10 topCapHeight:10];
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView {

  if ([growingTextView.text pd_isNotEmptyString]) {

    [_tSendBtn setEnabled:YES];
  } else
    [_tSendBtn setEnabled:NO];
}

- (void)sendBtnPressed:(id)sender {

  NSString *commnetText = [_textView.text pd_trimWhiteSpace];

  if (![commnetText pd_isNotEmptyString]) {
    [Utilities alertInstant:@"没有评论噢~" isError:YES];
    return;
  }

  if ([commnetText length] > 100) {
    [Utilities alertInstant:@"评论字数太多了，50字以内吧" isError:YES];
    return;
  }


  if ([commnetText length] < 3) {
    [Utilities alertInstant:@"评论字数太少了，至少3个字吧" isError:YES];
    return;
  }
  [SVProgressHUD showWithStatus:@"添加评论中。。"];
  [_textView resignFirstResponder];

  if (!_beginStr || ![_textView.text hasPrefix:_beginStr]) {
    _toUserId = 0;
    _replyId = 0;
  }

  [self addCommentToServer:_textView.text];

}

- (void)keyboardWillShow:(NSNotification *)note {

  // CGRect tableViewFrame = [_tableView frame];

  // get keyboard size and loctaion
  CGRect keyboardBounds;
  [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
  NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
  NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];

  // Need to translate the bounds to account for rotation.
  keyboardBounds = [self.view convertRect:keyboardBounds toView:nil];

  // get a rect for the textView frame
  CGRect containerFrame = _tContainerView.frame;
  containerFrame.origin.y = self.view.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height);

  // animations settings
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationBeginsFromCurrentState:YES];
  [UIView setAnimationDuration:[duration doubleValue]];
  [UIView setAnimationCurve:[curve intValue]];

  // set views with new info
  _tContainerView.frame = containerFrame;

  // commit animations
  [UIView commitAnimations];

}

- (void)keyboardWillHide:(NSNotification *)note {

  NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
  NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];

  // get a rect for the textView frame
  CGRect containerFrame = _tContainerView.frame;
  containerFrame.origin.y = self.view.bounds.size.height - containerFrame.size.height;

  // animations settings
  [UIView beginAnimations:nil context:NULL];
  [UIView setAnimationBeginsFromCurrentState:YES];
  [UIView setAnimationDuration:[duration doubleValue]];
  [UIView setAnimationCurve:[curve intValue]];

  // set views with new info
  _tContainerView.frame = containerFrame;

  // commit animations
  [UIView commitAnimations];

}


@end
