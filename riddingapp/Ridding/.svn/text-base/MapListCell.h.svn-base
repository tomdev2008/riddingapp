//
//  MapListCell.h
//  Ridding
//
//  Created by zys on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@interface MapListCell : UITableViewCell{
    UILabel *titleLab;
    UILabel *distanceLab;
    UITextField *editTitleField;
    UIButton *reTitleBtn;
    UIButton *finishBtn;
    UIButton *quitBtn;
    NSString *Id;
    int status;
    NSString* name;
    int distance;
    UIView *cellView;
    NSString *createTime;
}

@property(nonatomic, retain) UILabel *titleLab; 
@property(nonatomic, retain) UILabel *distanceLab;
@property(nonatomic, retain) UITextField *editTitleField; 
@property(nonatomic, retain) UIButton *reTitleBtn;
@property(nonatomic, retain) UIButton *finishBtn;
@property(nonatomic, retain) UIButton *quitBtn;
@property(nonatomic, retain) UIView *cellView;
@property(nonatomic, retain) NSString *Id;
@property(nonatomic, retain) NSString *createTime;
@property(nonatomic) int status;
@property(nonatomic) int distance;
@property(nonatomic, retain) NSString* name;

-(void)reload;
-(void)showHidden:(BOOL)isShow;
@end
