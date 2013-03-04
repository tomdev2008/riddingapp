//
//  MapCreateAnnotationView.h
//  Ridding
//
//  Created by zys on 13-2-21.
//
//

#import <UIKit/UIKit.h>
@class MapCreateAnnotationView;
@protocol MapCreateAnnotationViewDelegate <NSObject>

- (void)beginBtnClick:(MapCreateAnnotationView*)view;

- (void)passBtnClick:(MapCreateAnnotationView*)view;

- (void)endBtnClick:(MapCreateAnnotationView*)view;

@end
@interface MapCreateAnnotationView : UIView 

@property (nonatomic,assign) id<MapCreateAnnotationViewDelegate> delegate;

//@property (nonatomic,retain) IBOutlet UIButton *beginBtn;
//@property (nonatomic,retain) IBOutlet UIButton *endBtn;
//@property (nonatomic,retain) IBOutlet UIButton *passBtn;
@end
