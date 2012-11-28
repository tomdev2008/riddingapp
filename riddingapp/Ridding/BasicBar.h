//
//  BasicBar.h
//  Ridding
//
//  Created by zys on 12-9-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XMBarViewDelegate; 
@interface BasicBar : UIView

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) IBOutlet UIButton *leftButton;
@property (nonatomic,strong) IBOutlet UIButton *rightButton;
@property (nonatomic,unsafe_unretained) IBOutlet id<XMBarViewDelegate> delegate;

- (IBAction)btnClick:(id)sender;
@end
@protocol XMBarViewDelegate <NSObject>
- (void)leftBtnClicked:(id)sender;
- (void)rightBtnClicked:(id)sender;
@end