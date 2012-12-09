//
//  MapListCell.m
//  Ridding
//
//  Created by zys on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MapListCell.h"

@implementation MapListCell
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
    self.titleLab=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 30)];
    self.titleLab.text=[NSString stringWithFormat:@"名称:%@",self.name];
    [self.titleLab setTextAlignment:UITextAlignmentCenter];
    [self addSubview:self.titleLab];
    self.distanceLab=[[UILabel alloc]initWithFrame:CGRectMake(120, 5, 100, 30)];
    self.distanceLab.text=[NSString stringWithFormat:@"%dkm",self.distance/1000];
    [self.distanceLab setFont:[UIFont fontWithName:@"123" size:0.8]];
    [self.distanceLab setTextAlignment:UITextAlignmentCenter];
    [self addSubview:self.distanceLab];
    
    self.reTitleBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.reTitleBtn setTitle:@"重命名" forState:UIControlStateNormal];
    [self.reTitleBtn setFrame:CGRectMake(80, 5+44, 55, 20)];
    [self.reTitleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.reTitleBtn setAdjustsImageWhenHighlighted:NO];
    self.reTitleBtn.hidden=YES;
    [self addSubview:self.reTitleBtn];
    
    self.finishBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.finishBtn setFrame:CGRectMake(145, 5+44, 55, 20)];
    [self.finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.finishBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.finishBtn setAdjustsImageWhenHighlighted:NO];
    self.finishBtn.hidden=YES;
    [self addSubview:self.finishBtn];
    
    self.quitBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.quitBtn setFrame:CGRectMake(210, 5+44, 55, 20)];
    [self.quitBtn setTitle:@"退出" forState:UIControlStateNormal];
    [self.quitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.quitBtn setAdjustsImageWhenHighlighted:NO];
    self.quitBtn.hidden=YES;
    [self addSubview:self.quitBtn];
}

-(void)showHidden:(BOOL)isShow{
    if(isShow){
        self.finishBtn.hidden=NO;
        self.quitBtn.hidden=NO;
        self.reTitleBtn.hidden=NO;
    }else{
        self.finishBtn.hidden=YES; 
        self.quitBtn.hidden=YES;
        self.reTitleBtn.hidden=YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
