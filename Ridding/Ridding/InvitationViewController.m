//
//  InvitationViewController.m
//  Ridding
//
//  Created by Wu Chenhao on 6/26/12.
//  Copyright (c) 2012 MicroStrategy. All rights reserved.
//

#import "InvitationViewController.h"
#import "UIColor+XMin.h"
#import "SinaApiRequestUtil.h"
#import "SVProgressHUD.h"
@implementation InvitationViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil riddingId:(long long)riddingId nowTeamers:(NSArray*)nowTeamers
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    _riddingId=riddingId;
    _originUser=[[NSMutableDictionary alloc]init];
    for(User *user in nowTeamers){
      if(user.sourceUserId>0){
        [_originUser setObject:user forKey:LONGLONG2NUM(user.sourceUserId)];
      }
    }
    _sinaUsers=[[NSMutableArray alloc]init];
    _nowUser=[[NSMutableArray alloc]init];
    _isSearching=FALSE;
    
  }
  return self;
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [self.atableView setBackgroundColor:[UIColor getColor:@"5F5F5F"]];
  UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"I分割线.png"]];
  [self.atableView setSeparatorColor:color];
  [self.atableView reloadData];
  [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  if(!self.didAppearOnce){
    [self download];
    self.didAppearOnce=YES;
  }
  
}

- (void)download{
  dispatch_async(dispatch_queue_create("download", NULL), ^{
    NSArray *array= [[SinaApiRequestUtil getSinglton]getBilateralUserList];
    if([array count]>0){
      for(NSDictionary *dic in array){
        SinaUserProfile *userProfile=[[SinaUserProfile alloc]initWithJSONDic:dic];
        if(![_originUser objectForKey:LONGLONG2NUM(userProfile.dbId)]){
          if(_isSearching){
            [_sinaUsers addObject:userProfile];
          }else{
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

-(IBAction)searchButtonClicked:(id)sender{
  if(_isSearching){
    _isSearching=FALSE;
    [self.searchButton setImage:[UIImage imageNamed:@"search2.png"] forState:UIControlStateNormal];
    [self.searchButton setImage:[UIImage imageNamed:@"search1.png"] forState:UIControlStateHighlighted];
    [self.searchField resignFirstResponder];
    [self.atableView reloadData];
  }
}
//点击返回
-(IBAction)backButtonClicked:(id)sender{
  [SVProgressHUD showWithStatus:@"请稍候"];
  NSMutableArray *returnUsers=[[NSMutableArray alloc]init];
  for(User *user in _nowUser){
    if(user.isSelected){
      [returnUsers addObject:user];
    }
  }
  [self.requestUtil tryAddRiddingUser:_riddingId addUsers:returnUsers];
  [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
  [textField setEnabled:NO];
  [textField resignFirstResponder];
  [SVProgressHUD show];
  NSString *t=textField.text;
  dispatch_queue_t q;
  q=dispatch_queue_create("textFieldShouldReturn", NULL);
  dispatch_async(q, ^{
    [_sinaUsers removeAllObjects];
    NSArray *array= [[SinaApiRequestUtil getSinglton] getAtUserList:t type:0];
    if (array&&[array count]>0) {
      for(NSDictionary *dic in array){
        SinaUserProfile *userProfile=[[SinaUserProfile alloc]initWithJSONDic:dic];
        if(![_originUser objectForKey:LONGLONG2NUM(userProfile.dbId)]){
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
  [_sinaUsers removeAllObjects];
  NSArray *tempArray=[_nowUser copy];
  for(User *user in tempArray){
    if(!user.isSelected){
      [_nowUser removeObject:user];
    }
  }
  _isSearching=TRUE;
  [self.searchButton setImage:[UIImage imageNamed:@"searchFinish1.png"] forState:UIControlStateNormal];
  [self.searchButton setImage:[UIImage imageNamed:@"searchFinish2.png"] forState:UIControlStateHighlighted];
  [textField setText:@""];
  [self.atableView reloadData];
  return YES;
}
//textfield代理-->

- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait||interfaceOrientation ==UIInterfaceOrientationPortraitUpsideDown);
}

//table的委托实现
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return 44.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  if(_isSearching){
    return [_sinaUsers count];
  }
  return [_nowUser count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  static NSString *kCellID = @"cellID";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewStylePlain reuseIdentifier:kCellID];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
  SinaUserProfile *userProfile;
  if (_isSearching) {
    userProfile = [_sinaUsers objectAtIndex:indexPath.row];
  }else{
    userProfile=[_nowUser objectAtIndex:indexPath.row];
  }
  cell.textLabel.text = userProfile.screen_name;
  if(userProfile.isSelected){
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
  }else{
    cell.accessoryType = UITableViewCellAccessoryNone;
  }
	
	return cell;
}

/**
 * 点击选择某用户时
 **/
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if(_isSearching){
    if([_sinaUsers count]>=indexPath.row){
      SinaUserProfile *userProflie=[_sinaUsers objectAtIndex:indexPath.row];
      if(userProflie.isSelected){
        [_nowUser removeObject:userProflie];
        userProflie.isSelected=FALSE;
      }else{
        userProflie.isSelected=TRUE;
        [_nowUser addObject:userProflie];
      }
    }
  }else{
    if([_nowUser count]>=indexPath.row){
      SinaUserProfile *userProflie=[_nowUser objectAtIndex:indexPath.row];
      if(userProflie.isSelected){
        userProflie.isSelected=FALSE;
      }else{
        userProflie.isSelected=TRUE;
      }
    }
  }
  [self.atableView reloadData];
}




@end
