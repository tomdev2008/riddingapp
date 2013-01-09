//
//  BasicViewController.h
//  Ridding
//
//  Created by zys on 12-9-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicBar.h"
#import "TouchEnabledTableView.h"
#import "RequestUtil.h"

#define kServerSuccessCode 1

typedef enum _POSITION {
	POSITION_LEFT = 1,
	POSITION_MID = 2,
  POSITION_RIGHT =3,
}POSITION;
@interface BasicViewController : UIViewController<XMBarViewDelegate,TouchEnabledTableViewDelegate,RequestUtilDelegate>{
  CGPoint			touchBeganPoint;
  BOOL				rightViewControllerDisabled;		//	右边viewController是否要显示
	BOOL				leftViewControllerDisabled;			//	左边viewController是否要显示
  
}

@property (nonatomic,retain) IBOutlet BasicBar *barView;
@property (nonatomic) BOOL hasLeftView;
@property (nonatomic) POSITION position;
@property (nonatomic,retain) RequestUtil *requestUtil;
@property(nonatomic) BOOL didAppearOnce;


@end
