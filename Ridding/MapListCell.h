//
//  MapListCell.h
//  Ridding
//
//  Created by zys on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface MapListCell : UITableViewCell {
}

@property (nonatomic, retain) UILabel *titleLab;
@property (nonatomic, retain) UILabel *distanceLab;
@property (nonatomic, retain) UITextField *editTitleField;
@property (nonatomic, retain) UIButton *reTitleBtn;
@property (nonatomic, retain) UIButton *finishBtn;
@property (nonatomic, retain) UIButton *quitBtn;
@property (nonatomic, retain) UIView *cellView;
@property (nonatomic) long long id;
@property (nonatomic) long long createTime;
@property (nonatomic) int status;
@property (nonatomic) int distance;
@property (nonatomic, retain) NSString *name;

- (void)reload;

- (void)showHidden:(BOOL)isShow;
@end
