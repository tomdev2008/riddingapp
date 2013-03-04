//
//  InvitationViewController.m
//  Ridding
//
//  Created by Wu Chenhao on 6/26/12.
//  Copyright (c) 2012 MicroStrategy. All rights reserved.
//

#import "InvitationViewController.h"
#import "SinaApiRequestUtil.h"
#import "SVProgressHUD.h"
#import "Utilities.h"
@implementation InvitationViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil riddingId:(long long)riddingId nowTeamers:(NSArray *)nowTeamers {

  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _riddingId = riddingId;
    _originUser = [[NSMutableDictionary alloc] init];
    for (User *user in nowTeamers) {
      if (user.sourceUserId > 0) {
        [_originUser setObject:user forKey:LONGLONG2NUM(user.sourceUserId)];
      }
    }
    _sinaUsers = [[NSMutableArray alloc] init];
    _nowUser = [[NSMutableArray alloc] init];
    _isSearching = FALSE;

  }
  return self;
}

- (void)didReceiveMemoryWarning {

  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

  self.view.backgroundColor = [UIColor colorWithPatternImage:UIIMAGE_FROMPNG(@"qqnr_bg")];
//  [self.barView.rightButton setImage:UIIMAGE_FROMPNG(@"qqnr_dl_navbar_icon_create") forState:UIControlStateNormal];
//  [self.barView.rightButton setImage:UIIMAGE_FROMPNG(@"qqnr_dl_navbar_icon_create") forState:UIControlStateHighlighted];
//  [self.barView.rightButton setHidden:YES];
  
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back") forState:UIControlStateNormal];
  [self.barView.leftButton setImage:UIIMAGE_FROMPNG(@"qqnr_back_hl") forState:UIControlStateHighlighted];
  [self.barView.leftButton setHidden:NO];

  [self.barView.titleLabel setText:@"添加队员"];

  [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {

  [super viewDidAppear:animated];
  if (!self.didAppearOnce) {
    [self download];
    self.didAppearOnce = YES;
  }

}

- (void)download {

  dispatch_async(dispatch_queue_create("download", NULL), ^{
    NSArray *array = [[SinaApiRequestUtil getSinglton] getBilateralUserList];
    if ([array count] > 0) {
      for (NSDictionary *dic in array) {
        SinaUserProfile *userProfile = [[SinaUserProfile alloc] initWithJSONDic:dic];
        if (![_originUser objectForKey:LONGLONG2NUM(userProfile.dbId)]) {
          if (_isSearching) {
            [_sinaUsers addObject:userProfile];
          } else {
            [_nowUser addObject:userProfile];
          }

        }
      }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.atableView reloadData];
    });
  });
}

- (void)leftBtnClicked:(id)sender{
  [SVProgressHUD showWithStatus:@"添加中，请稍候"];
  NSMutableArray *returnUsers = [[NSMutableArray alloc] init];
  for (User *user in _nowUser) {
    if (user.isSelected) {
      [returnUsers addObject:user];
    }
  }
  dispatch_queue_t q;
  q = dispatch_queue_create("textFieldShouldReturn", NULL);
  dispatch_async(q, ^{
    [self.requestUtil tryAddRiddingUser:_riddingId addUsers:returnUsers];
    dispatch_async(dispatch_get_main_queue(), ^{
      [SVProgressHUD dismiss];
      [self.navigationController popViewControllerAnimated:YES];
      [[NSNotificationCenter defaultCenter] postNotificationName:kSuccAddFriendsNotification object:nil];
    });
  });

}
- (void)rightBtnClicked:(id)sender{
  
  [super rightBtnClicked:sender];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

  [_sinaUsers removeAllObjects];
  [textField setEnabled:NO];
  [textField resignFirstResponder];
  [SVProgressHUD show];
  NSString *t = textField.text;
  dispatch_queue_t q;
  q = dispatch_queue_create("textFieldShouldReturn", NULL);
  dispatch_async(q, ^{
    [_sinaUsers removeAllObjects];
    NSArray *array = [[SinaApiRequestUtil getSinglton] getAtUserList:t type:0];
    if (array && [array count] > 0) {
      for (NSDictionary *dic in array) {
        SinaUserProfile *userProfile = [[SinaUserProfile alloc] initWithJSONDic:dic];
        if (![_originUser objectForKey:LONGLONG2NUM(userProfile.dbId)]) {
          [_sinaUsers addObject:userProfile];
        }
      }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
      [self.atableView reloadData];
      [textField setEnabled:YES];
      [SVProgressHUD dismiss];
    });
  });
  return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

  NSArray *tempArray = [_nowUser copy];
  for (User *user in tempArray) {
    if (!user.isSelected) {
      [_nowUser removeObject:user];
    }
  }
  _isSearching = TRUE;
  [self.barView.rightButton setHidden:NO];
  [textField setText:@""];
  [self.atableView reloadData];
  return YES;
}
//textfield代理-->

- (void)viewDidUnload {

  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

//table的委托实现
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

  return 56;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  if (_isSearching) {
    return [_sinaUsers count];
  }
  return [_nowUser count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  
  InvitationViewCell *cell = (InvitationViewCell *) [Utilities cellByClassName:@"InvitationViewCell" inNib:@"InvitationViewCell" forTableView:self.atableView];
  SinaUserProfile *userProfile;
  if (_isSearching) {
    userProfile = [_sinaUsers objectAtIndex:indexPath.row];
  } else {
    userProfile = [_nowUser objectAtIndex:indexPath.row];
  }
  cell.delegate=self;
  if (cell != nil) {
    [cell initWithSinaUser:userProfile index:indexPath.row];
  }
  return cell;
}

/**
 * 点击选择某用户时
 **/
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  
}

- (void)checkBtnClick:(InvitationViewCell*)cell{
  
  if (_isSearching) {
    if ([_sinaUsers count] >= cell.index) {
      SinaUserProfile *userProflie = [_sinaUsers objectAtIndex: cell.index];
      if (userProflie.isSelected) {
        [_nowUser removeObject:userProflie];
        userProflie.isSelected = FALSE;
      } else {
        userProflie.isSelected = TRUE;
        [_nowUser addObject:userProflie];
      }
    }
    _isSearching = FALSE;
    [self.searchField resignFirstResponder];
    self.searchField.text=@"";
  } else {
    if ([_nowUser count] >=  cell.index) {
      SinaUserProfile *userProflie = [_nowUser objectAtIndex: cell.index];
      if (userProflie.isSelected) {
        userProflie.isSelected = FALSE;
      } else {
        userProflie.isSelected = TRUE;
      }
    }
  }
  [self.atableView reloadData];
}


- (IBAction)cancelBtn:(id)sender{
  
  [self.searchField resignFirstResponder];
}

@end
