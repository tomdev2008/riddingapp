//
//  ActivityView.h
//  Xmin
//
//  Created by zys on 12-7-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface ActivityView : UIView{
    
}

@property (nonatomic,retain) UILabel *nameLabel;

-(id)init:(NSString*)text lat:(CGFloat)lat log:(CGFloat)log;

-(void)setName:(NSString*)name;

@end
