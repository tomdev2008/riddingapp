//
//  InvitationViewController.h
//  Ridding
//
//  Created by Wu Chenhao on 6/26/12.
//  Copyright (c) 2012 MicroStrategy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SinaApiRequestUtil.h"
#import "RequestUtil.h"
#import "UserMap.h"
@interface InvitationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>{
    NSString *riddingId;
    SinaApiRequestUtil *sinaApiRequestUtil;
    NSMutableArray *careUsers;
    NSMutableArray *sinaUsers;
    NSMutableDictionary *selectedDic;
    NSMutableDictionary *originalDic;
    bool isSearchIng;
    RequestUtil *requestUtil;
    int _loadCount;
}

@property (nonatomic, retain) IBOutlet UITableView *atableView;
@property (nonatomic, retain) IBOutlet UIButton *searchButton;
@property (nonatomic, retain) IBOutlet UITextField *searchField;
@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) NSString *riddingId;
@property (nonatomic, retain) SinaApiRequestUtil *sinaApiRequestUtil;
@property (nonatomic, retain) RequestUtil *requestUtil;
@property (nonatomic, retain) NSMutableArray *careUsers;
@property (nonatomic, retain) NSMutableArray *sinaUsers;
@property (nonatomic, retain) NSMutableDictionary *selectedDic;
@property (nonatomic, retain) NSMutableDictionary *originalDic;

@property (nonatomic) bool isSearchIng;

- (void) initView;
- (User*) getTableCellUser:(NSInteger)rowCount;

-(IBAction)textFieldDidChange:(id)sender;
-(IBAction)backButtonClicked:(id)sender;
-(IBAction)searchButtonClicked:(id)sender;

@end
