//
//  QQNRFeedHeaderView.m
//  Ridding
//
//  Created by zys on 12-9-27.
//
//

#import "QQNRFeedHeaderView.h"
#import "UIImageView+WebCache.h"

#define iconSize @"24"
#define frameSize @"28"

@implementation QQNRFeedHeaderView
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame user:(User *)user {

  self = [super initWithFrame:frame];
  if (self) {

    CGRect frameViewFrame=CGRectMake(self.frame.size.width/2-33, self.frame.size.height*0.4-33, 66, 66);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frameViewFrame.origin.x+6, frameViewFrame.origin.y+4, 54, 54)];
    NSURL *url = [NSURL URLWithString:user.bavatorUrl];
    [imageView setImageWithURL:url placeholderImage:UIIMAGE_DEFAULT_USER_AVATOR];
    [self addSubview:imageView];
    
    UIImageView *frameView = [[UIImageView alloc] initWithFrame:frameViewFrame];
    frameView.image=UIIMAGE_FROMPNG(@"qqnr_photo_bg");
    [self addSubview:frameView];

    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-100, self.frame.size.height*0.6 , 200, 30)];
    userName.textAlignment = UITextAlignmentCenter;
    userName.textColor = [UIColor whiteColor];
    userName.backgroundColor = [UIColor clearColor];
    userName.shadowColor = [UIColor blackColor];
    userName.shadowOffset = CGSizeMake(0.0, 1.0);
    userName.font = [UIFont boldSystemFontOfSize:20];
    userName.text = user.name;
    [self addSubview:userName];

    _mileStone = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2-100, userName.frame.origin.y + 20, 200, 30)];
    _mileStone.textAlignment = UITextAlignmentCenter;
    _mileStone.textColor = [UIColor whiteColor];
    _mileStone.backgroundColor = [UIColor clearColor];
    _mileStone.shadowColor = [UIColor blackColor];
    _mileStone.shadowOffset = CGSizeMake(0.0, 1.0);
    _mileStone.font = [UIFont fontWithName:@"Arial" size:12];
    _mileStone.text = [NSString stringWithFormat:@"总行程:%@", [user getTotalDistanceToKm]];
    [self addSubview:_mileStone];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    view.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backGroundViewClick:)];
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:tapGesture];
    [self addSubview:view];


//    _relationBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    [_relationBtn setBackgroundColor:[UIColor blackColor]];
//    _relationBtn.frame=CGRectMake(90, 20, 240, 140);
//    [_relationBtn setTitle:@"加为好友" forState:UIControlStateNormal];
//    [_relationBtn setTitle:@"加为好友" forState:UIControlStateHighlighted];
//    [_relationBtn addTarget:self action:@selector(relationClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:_relationBtn];


  }
  return self;
}

- (void)backGroundViewClick:(UIGestureRecognizer *)gesture {

  if (self.delegate) {
    [self.delegate backGroupViewClick:self];
  }
}

- (void)relationClick:(id)selector {

}

- (void)finishRidding {

  _mileStone.text = [[StaticInfo getSinglton].user getTotalDistanceToKm];
}

- (void)drawRect:(CGRect)rect {


}

@end
