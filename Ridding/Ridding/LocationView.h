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

#define viewWidth 50
#define viewHeight 50
typedef enum LOCATIONTYPE {
  LOCATIONTYPE_BEGIN = 1,
  LOCATIONTYPE_MID = 2,
  LOCATIONTYPE_END = 3,
} LOCATIONTYPE;

@interface LocationView : UIView {
}

@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longtitude;
@property (nonatomic, retain) NSString *totalLocation;
@property (nonatomic) LOCATIONTYPE type;
@property (nonatomic, retain) MyAnnotation *annotation;

- (id)initWithFrame:(CGRect)frame type:(LOCATIONTYPE)type;

- (void)setSubViews;
@end
