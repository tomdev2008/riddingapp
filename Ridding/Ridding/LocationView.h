//
//  LocationView.h
//  Ridding
//
//  Created by zys on 12-11-16.
//
//

#import <UIKit/UIKit.h>
#import "MyAnnotation.h"
#import "CreateAnnotationView.h"

#define viewWidth 40
#define viewHeight 50


@interface LocationView : UIView {
}

@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longtitude;
@property (nonatomic, retain) NSString *totalLocation;
@property (nonatomic, retain) MyAnnotation *annotation;

- (id)initWithFrame:(CGRect)frame;

- (void)setSubViews;
@end
