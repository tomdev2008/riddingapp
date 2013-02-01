//
//  BasicNeedLoginViewController.h
//  Ridding
//
//  Created by zys on 12-12-23.
//
//

#import "BasicViewController.h"

@interface BasicNeedLoginViewController : BasicViewController <RiddingViewControllerDelegate, QQNRSourceLoginViewControllerDelegate>


- (void)showLoginAlertView;

- (void)presentLoginView;
@end
