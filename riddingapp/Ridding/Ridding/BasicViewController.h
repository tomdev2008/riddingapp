//
//  BasicViewController.h
//  Ridding
//
//  Created by zys on 12-9-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicBar.h"
#import "MBProgressHUD.h"
@interface BasicViewController : UIViewController<XMBarViewDelegate,MBProgressHUDDelegate>{
    MBProgressHUD *_HUD;
}

@property (nonatomic,retain) IBOutlet BasicBar *barView;
- (void)initHUD;
@end
