//
//  InvitationViewController.m
//  Ridding
//
//  Created by Wu Chenhao on 6/26/12.
//  Copyright (c) 2012 MicroStrategy. All rights reserved.
//

#import "InvitationViewController.h"
#import "UIColor+XMin.h"
@implementation InvitationViewController
@synthesize atableView;
@synthesize riddingId;
@synthesize sinaApiRequestUtil;
@synthesize searchField;
@synthesize careUsers;
@synthesize sinaUsers;
@synthesize isSearchIng;
@synthesize selectedDic;
@synthesize backButton;
@synthesize requestUtil;
@synthesize originalDic;
@synthesize searchButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        sinaApiRequestUtil=[SinaApiRequestUtil getSinglton];
        requestUtil=[RequestUtil getSinglton];
        self.careUsers=[[NSMutableArray alloc]init];
        self.sinaUsers=[[NSMutableArray alloc]init];
        self.selectedDic=[[NSMutableDictionary alloc]init];
        self.originalDic=[[NSMutableDictionary alloc]init];
        isSearchIng=FALSE;
       
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
    [self initView];
    [self.atableView reloadData];
    [super viewDidLoad];
    _loadCount=0;
    
}

-(void)initView{
    //动态添加点击操作
    [searchField addTarget:self action:@selector(textFieldDidChange:)forControlEvents:UIControlEventEditingChanged];
    [atableView setBackgroundColor:[UIColor getColor:@"5F5F5F"]];
    UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"I分割线.png"]];
    [self.atableView setSeparatorColor:color];
}

-(IBAction)searchButtonClicked:(id)sender{
    if(isSearchIng){
        isSearchIng=FALSE;
        [self.searchButton setImage:[UIImage imageNamed:@"search2.png"] forState:UIControlStateNormal];
        [self.searchButton setImage:[UIImage imageNamed:@"search1.png"] forState:UIControlStateHighlighted];
        [searchField resignFirstResponder];
        [self.atableView reloadData];
    }
}
//点击返回
-(IBAction)backButtonClicked:(id)sender{
    for(User *user in [selectedDic allValues]){
        [originalDic removeObjectForKey:user.accessUserId];
    }
    [requestUtil deleteRiddingUser:riddingId deleteUserIds:[originalDic allValues]];
    [requestUtil tryAddRiddingUser:riddingId addUsers:[selectedDic allValues]];
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)textFieldDidChange:(id)sender{
    NSString *t=[(UITextField*)sender text];
    _loadCount++;
    dispatch_queue_t q;
    q=dispatch_queue_create("textFieldDidChange", NULL);
    dispatch_async(q, ^{
        NSArray *array= [sinaApiRequestUtil getAtUserList:t type:[NSNumber numberWithInt:0]];
        [self.sinaUsers removeAllObjects];
        if (array&&[array count]>0) {
            for(NSDictionary *dic in array){
                User *user=[[User alloc]init];
                user.name=[dic objectForKey:@"nickname"];
                user.accessUserId=[[dic objectForKey:@"uid"]stringValue];
                [self.sinaUsers addObject:user];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            _loadCount--;
            if(_loadCount==0){
                [self.atableView reloadData];
            }
        });
    });
}
//<!--textfield代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    [textField resignFirstResponder];
    textField.text = @"";
    return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    isSearchIng=TRUE;
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
    if(isSearchIng){
        return [self.sinaUsers count];
    }
    return [self.selectedDic count]+[self.careUsers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{	
    static NSString *kCellID = @"cellID";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewStylePlain reuseIdentifier:kCellID];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}
  User *user=[self getTableCellUser:indexPath.row];
    
	cell.textLabel.text = user.name;
    if([self.selectedDic objectForKey:user.accessUserId]){
         cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
         cell.accessoryType = UITableViewCellAccessoryNone;
    }
	return cell;
}

-(User*)getTableCellUser:(NSInteger)rowCount{
    User *user;
    if (isSearchIng) {
        user = [self.sinaUsers objectAtIndex:rowCount];
    }else{
        if(rowCount>[selectedDic count]){
            user = [self.careUsers objectAtIndex:(rowCount-[selectedDic count]-1)];
        }else{
            user=[[selectedDic allValues] objectAtIndex:rowCount];
        }
    }
    return user;
}

/**
 * 点击选择某用户时
 **/
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    User *user=[self getTableCellUser:indexPath.row];
    if (user) {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:
                                    indexPath];
        if (newCell.accessoryType==UITableViewCellAccessoryCheckmark&&!user.isLeader) {
            [newCell setAccessoryType:UITableViewCellAccessoryNone];
            if([selectedDic objectForKey:user.accessUserId]){
                [selectedDic removeObjectForKey:user.accessUserId];
            }
        }else if(newCell.accessoryType==UITableViewCellAccessoryCheckmark&&user.isLeader){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出失败" 
                                                            message:@"你是队长，不能退出噢，只有大家都退出了，你才能删除活动" 
                                                           delegate:self cancelButtonTitle:@"好吧，我懂了"
                                                  otherButtonTitles:nil];
            [alert show];
        }else{
            [newCell setAccessoryType:UITableViewCellAccessoryCheckmark];
            [selectedDic setValue:user forKey:user.accessUserId];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.atableView reloadData];
}




@end
