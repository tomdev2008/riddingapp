//
//  UserScrollView.m
//  Ridding
//
//  Created by zys on 12-3-26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "UserView.h"
#import <QuartzCore/QuartzCore.h>
#import "StaticInfo.h"
@implementation UserView
@synthesize userViewDelegate=_userViewDelegate;
@synthesize user=_user;
@synthesize avatorView;
@synthesize label;
@synthesize deleteView;
@synthesize brandView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	if (self) {
      
	}
	return self;
}
-(UserView*)init{
    //添加长按操作
    self.userInteractionEnabled=YES;
    //添加头像
    avatorView = [[UIImageView alloc]initWithFrame:CGRectMake(5,0,60,60)];
    CALayer *l = [avatorView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:6.0];
    UIImage *aimage=[self.user getBavator];
    avatorView.image=aimage;
    avatorView.userInteractionEnabled=YES;
    UITapGestureRecognizer *viewTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avatorViewClick:)];
    [avatorView addGestureRecognizer:viewTap]; 
    [self addSubview:avatorView];
    
    //添加名牌
    brandView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 63, self.frame.size.width, 21)];
    if([[StaticInfo getSinglton].user.userId longLongValue]== [self.user.userId longLongValue]){
        brandView.image = [UIImage imageNamed:@"userBrand.png"];
    }else if(self.user.status==1){
        brandView.image = [UIImage imageNamed:@"userBrand.png"];
    }else{
        brandView.image = [UIImage imageNamed:@"userBrandOffline.png"];
    }
    l = [brandView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:3.0];
    [self addSubview:brandView];

    //添加标签
    label=[[UILabel alloc]initWithFrame:CGRectMake(1, 66, self.frame.size.width-1, 15)];
    label.text=self.user.name;
    label.textAlignment=UITextAlignmentCenter;
    [label setBackgroundColor:[UIColor clearColor]];
    label.textColor=[UIColor whiteColor];
    label.font = [UIFont fontWithName:@"Arial" size:12];

    [self addSubview:label];
    
    //添加删除按钮，初始隐藏
    if([StaticInfo getSinglton].user.isLeader&&[self.user.userId longLongValue]!=[[StaticInfo getSinglton].user.userId longLongValue]){
        deleteView=[[UIImageView alloc]initWithFrame:CGRectMake(50, 0, 15, 15)];
        UIImage *deleteImage=[UIImage imageNamed:@"icon-delete.png"];
        deleteView.image=deleteImage;
        deleteView.userInteractionEnabled=YES;
        UITapGestureRecognizer *deleteTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(deleteViewClick:)];
        [deleteView addGestureRecognizer:deleteTap]; 
        deleteView.hidden=YES;
        [self addSubview:deleteView];
    }
    return self;
}

-(void)changeStatus:(int)status{
    self.user.status=status;
    if([[StaticInfo getSinglton].user.userId longLongValue]== [self.user.userId longLongValue]){
        brandView.image = [UIImage imageNamed:@"userBrand.png"];
    }else if(status==1){
        brandView.image = [UIImage imageNamed:@"userBrand.png"];
    }else{
        brandView.image = [UIImage imageNamed:@"userBrandOffline.png"];
    }
}



//点击头像view
-(void)avatorViewClick:(UITapGestureRecognizer*)gestureRecognize{
    if(self.user.status==1){
        if ([_userViewDelegate respondsToSelector:@selector(avatorViewClick:userId:)]) {
            [_userViewDelegate avatorViewClick:gestureRecognize userId:self.user.userId];
        }
    }
}
//点击删除
-(void)deleteViewClick:(UITapGestureRecognizer*)gestureRecognize{
    if(deleteView.hidden==TRUE){
        return;
    }
    if ([_userViewDelegate respondsToSelector:@selector(deleteViewClick:userView:)]) {
        [_userViewDelegate deleteViewClick:gestureRecognize userView:self];
    }
    
}



@end
