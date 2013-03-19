//
//  VipViewController.h
//  Ridding
//
//  Created by zys on 13-3-18.
//
//

#import "BasicViewController.h"
#import "UserPay.h"
@interface VipViewController : BasicViewController<UIScrollViewDelegate>{
  UserPay *_userPay;
}



@property (nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic,retain) IBOutlet UITextView *taobaoCodeView;
@property (nonatomic,retain) IBOutlet UILabel *descLabel;
@property (nonatomic,retain) IBOutlet UIButton *tryBtn;
@property (nonatomic,retain) IBOutlet UILabel *vipDescLabel;
@property (nonatomic,retain) IBOutlet UILabel *dayLongLabel;


- (id)initWithUserPay:(UserPay*)userPay;
@end
