//
//  JingDianMapCell.h
//  IYLM
//
//  Created by Jian-Ye on 12-11-8.
//  Copyright (c) 2012年 Jian-Ye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RiddingPicture.h"

@class AnnotationPhotoView;
@protocol AnnotationPhotoViewDelegate <NSObject>

- (void)photoClick:(AnnotationPhotoView*)view;

@end
@interface AnnotationPhotoView : UIView


@property (nonatomic,retain) IBOutlet UIButton *photoView;
@property (nonatomic,retain) IBOutlet UIButton *avatorView;
@property (nonatomic,retain) IBOutlet UILabel *nameLabel;
@property (nonatomic,retain) IBOutlet UILabel *locationLabel;
@property (nonatomic) int index;
@property (nonatomic,assign) id<AnnotationPhotoViewDelegate> delegate;

- (void)initViewWithPhoto:(RiddingPicture*)riddingPicture;
@end
