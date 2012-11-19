//
//  CreateAnnotationView.h
//  Ridding
//
//  Created by zys on 12-11-15.
//
//

#import <MapKit/MapKit.h>

@class CreateAnnotationView;
@protocol CreateAnnotationViewDelegate <NSObject>

-(void)imageViewDelete:(CreateAnnotationView*)view;

@end


@interface CreateAnnotationView : MKPinAnnotationView

@property (nonatomic,strong) UIView *calloutView;
@property (nonatomic,assign) id<CreateAnnotationViewDelegate> delegate;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;
- (void)animateCalloutAppearance;

@end
