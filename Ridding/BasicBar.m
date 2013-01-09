//
//  BasicBar.m
//  Ridding
//
//  Created by zys on 12-9-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BasicBar.h"
#import "UIColor+XMin.h"
#import <QuartzCore/QuartzCore.h>
@implementation BasicBar
@synthesize titleLabel = _titleLabel;
@synthesize leftButton = _leftButton;
@synthesize rightButton = _rightButton;
@synthesize delegate = _delegate;

- (void)setRightButton:(UIButton *)rightButton
{
    if (_rightButton != rightButton) {
        [_rightButton removeFromSuperview];
        _rightButton = rightButton;
        _rightButton.center =  CGPointMake(SCREEN_WIDTH-40, 20);
        [_rightButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_rightButton];
    }
}
- (void)setLeftButton:(UIButton *)leftButton
{
    if (_leftButton != leftButton) {
        [_leftButton removeFromSuperview];
        _leftButton = leftButton;
        _leftButton.center =  CGPointMake(40, 20);
        [_leftButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftButton];
        
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
  self=[super initWithCoder:aDecoder];
  if(self){
    // Initialization code
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(85,8,  142, 27)];
    _titleLabel.textColor =[UIColor getColor:barTextColor];
    _titleLabel.font =[UIFont boldSystemFontOfSize:17];
    _titleLabel.backgroundColor =[UIColor clearColor];
    _titleLabel.textAlignment =UITextAlignmentCenter;
    _titleLabel.text = @"标题";
    [self addSubview:_titleLabel];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(6,6, 64,31);
    _leftButton.layer.cornerRadius=5;
    _leftButton.layer.masksToBounds=YES;
    [_leftButton setTitleColor:[UIColor getColor:barTextColor] forState:UIControlStateNormal];
    [_leftButton setTitleColor:[UIColor getColor:barTextColor] forState:UIControlStateHighlighted];
    _leftButton.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    _leftButton.showsTouchWhenHighlighted = YES;
    [_leftButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_leftButton];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(245,6, 64,31);
    _rightButton.layer.cornerRadius=5;
    _rightButton.layer.masksToBounds=YES;
    _rightButton.titleLabel.font = [UIFont systemFontOfSize: 15.0];
    _rightButton.showsTouchWhenHighlighted = YES;
    [_rightButton setTitleColor:[UIColor getColor:barTextColor] forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor getColor:barTextColor] forState:UIControlStateHighlighted];
    [_rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [_rightButton setTitle:@"确定" forState:UIControlStateHighlighted];
    [_rightButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton setHidden:YES];
    [self addSubview:_rightButton];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame
{    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}
- (IBAction)btnClick:(id)sender
{
    if (sender == _leftButton) {
        [_delegate performSelector:@selector(leftBtnClicked:) withObject:sender];
    }else {
        [_delegate performSelector:@selector(rightBtnClicked:) withObject:sender];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
