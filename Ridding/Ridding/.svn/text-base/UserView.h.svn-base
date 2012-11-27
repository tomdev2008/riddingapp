//
//  UserScrollView.h
//  Ridding
//
//  Created by zys on 12-3-26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "User.h"
@protocol UserViewDelegate; //代理协议的声明

@interface UserView : UIView {
    id<UserViewDelegate> userViewDelegate;
    UIImageView *avatorView;
    UILabel *label;
    UIImageView *deleteView;
    UIImageView *brandView;
}
@property(nonatomic, assign) id userViewDelegate; 
@property(nonatomic, retain) User *user;
@property(nonatomic, retain) UIImageView *avatorView;
@property(nonatomic, retain) UILabel *label;
@property(nonatomic, retain) UIImageView *deleteView;
@property(nonatomic, retain) UIImageView *brandView;

-(UserView*)init;
-(void)changeStatus:(int)status;
@end

//代理协议的实现
@protocol UserViewDelegate <NSObject>
-(void)avatorViewClick:(UITapGestureRecognizer*) gestureRecognize userId:(NSString*)userId; //声明协议方法
-(void)deleteViewClick:(UITapGestureRecognizer*) gestureRecognize userView:(UserView*)userView; //声明协议方法
@end

