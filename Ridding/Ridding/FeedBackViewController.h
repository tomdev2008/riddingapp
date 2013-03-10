//
//  FeedBackViewController.h
//  Ridding
//
//  Created by zys on 13-3-7.
//
//

#import <UIKit/UIKit.h>
#import "BasicViewController.h"

@interface FeedBackViewController : BasicViewController <UITextViewDelegate,UITextFieldDelegate>{
  
  BOOL _isFromLeft;
}


@property (nonatomic,retain) IBOutlet UITextView *textView;
@property (nonatomic,retain) IBOutlet UITextField *qqField;
@property (nonatomic,retain) IBOutlet UITextField *emailField;
@property (nonatomic,retain) IBOutlet UIButton *sendBtn;

- (id)init:(BOOL)fromLeft;
@end
