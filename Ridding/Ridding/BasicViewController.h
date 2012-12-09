//
//  BasicViewController.h
//  Ridding
//
//  Created by zys on 12-9-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicBar.h"
typedef enum _POSITION {
	POSITION_LEFT = 1,
	POSITION_MID = 2,
  POSITION_RIGHT =3,
}POSITION;
@interface BasicViewController : UIViewController<XMBarViewDelegate>{
  BOOL _didAppearOnce;
  
}

@property (nonatomic,retain) IBOutlet BasicBar *barView;
@property (nonatomic) BOOL hasLeftView;
@property (nonatomic) POSITION position;


@end
