//
//  MapListCell.m
//  Ridding
//
//  Created by zys on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MapListCell.h"

@implementation MapListCell
@synthesize titleLab;
@synthesize reTitleBtn;
@synthesize distanceLab;
@synthesize quitBtn;
@synthesize finishBtn;
@synthesize editTitleField;
@synthesize Id;
@synthesize status;
@synthesize distance;
@synthesize name;
@synthesize cellView;
@synthesize createTime;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        [self setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
        
    }
    return self;
}

-(void)reload{
    titleLab=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 30)];
    titleLab.text=[NSString stringWithFormat:@"名称:%@",name];
    [titleLab setTextAlignment:UITextAlignmentCenter];
    [self addSubview:titleLab];
    distanceLab=[[UILabel alloc]initWithFrame:CGRectMake(120, 5, 100, 30)];
    distanceLab.text=[NSString stringWithFormat:@"%dkm",distance/1000];
    [distanceLab setFont:[UIFont fontWithName:@"123" size:0.8]];
    [distanceLab setTextAlignment:UITextAlignmentCenter];
    [self addSubview:distanceLab];
    
    reTitleBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [reTitleBtn setTitle:@"重命名" forState:UIControlStateNormal];
    [reTitleBtn setFrame:CGRectMake(80, 5+44, 55, 20)];
    [reTitleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [reTitleBtn setAdjustsImageWhenHighlighted:NO];
    reTitleBtn.hidden=YES;
    [self addSubview:reTitleBtn];
    
    finishBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [finishBtn setFrame:CGRectMake(145, 5+44, 55, 20)];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [finishBtn setAdjustsImageWhenHighlighted:NO];
    finishBtn.hidden=YES;
    [self addSubview:finishBtn];
    
    quitBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [quitBtn setFrame:CGRectMake(210, 5+44, 55, 20)];
    [quitBtn setTitle:@"退出" forState:UIControlStateNormal];
    [quitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [quitBtn setAdjustsImageWhenHighlighted:NO];
    quitBtn.hidden=YES;
    [self addSubview:quitBtn];
}

-(void)showHidden:(BOOL)isShow{
    if(isShow){
        finishBtn.hidden=NO; 
        quitBtn.hidden=NO;
        reTitleBtn.hidden=NO;
    }else{
        finishBtn.hidden=YES; 
        quitBtn.hidden=YES;
        reTitleBtn.hidden=YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
