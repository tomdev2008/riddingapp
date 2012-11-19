//
//  ActivityView.m
//  Xmin
//
//  Created by zys on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ActivityView.h"

@implementation ActivityView
@synthesize nameLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)init:(NSString*)text lat:(CGFloat)lat log:(CGFloat)log
{
    CGFloat width=110;
    CGFloat height=110;
    self = [super initWithFrame:CGRectMake(lat-width/2, log-height/2, width, height)];
    if (self) {
        [self setBackgroundColor:[UIColor blackColor]];
        [self setAlpha:0.8];
        self.layer.cornerRadius=10;
        self.layer.masksToBounds=YES;
        UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(36, 15, 37, 37)];
        [activityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [activityView startAnimating];
        nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 75, 110, 20)];
        nameLabel.text=text;
        [nameLabel setTextColor:[UIColor whiteColor]];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setTextAlignment:UITextAlignmentCenter];
        [nameLabel setFont:[UIFont systemFontOfSize:14]];
        [self addSubview:activityView];
        [self addSubview:nameLabel];
    }
    return self;

}


-(void)setName:(NSString*)name{
    if(!self){
        return;
    }
    [nameLabel setText:name];
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
