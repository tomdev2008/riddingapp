//
//  TouchedScrollView.h
//  MyBabyCare
//
//  Created by Tom CHEN on 10/29/11.
//  Copyright (c) 2011 儒果科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TouchedScrollViewDelegate <NSObject>

- (void)scrollViewTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)scrollViewTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;

- (void)scrollViewTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end

@interface TouchedScrollView : UIScrollView {

}

@property (nonatomic, assign) id <TouchedScrollViewDelegate> touchDelegate;

@end
