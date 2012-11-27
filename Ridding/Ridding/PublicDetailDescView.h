//
//  PublicDetailDescView.h
//  Ridding
//
//  Created by zys on 12-11-11.
//
//

#import <UIKit/UIKit.h>

@interface PublicDetailDescView : UIView

@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSString *time;

-(CGFloat)heightForContent;
@end
