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

    UIView *frameView = [[UIView alloc] initWithFrame:CGRectMake(40, self.frame.size.height - 60, 40, 40)];
    [frameView setBackgroundColor:[UIColor clearColor]];
    frameView.layer.cornerRadius = [frameSize doubleValue] / 1.5;
    frameView.clipsToBounds = YES;
    [self addSubview:frameView];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectInset(frameView.frame, ([frameSize doubleValue] - [iconSize doubleValue]) / 2.0, ([frameSize doubleValue] - [iconSize doubleValue]) / 2.0)];
    imageView.layer.cornerRadius = [iconSize doubleValue] / 1.5;
    imageView.clipsToBounds = YES;
    NSURL *url = [NSURL URLWithString:user.savatorUrl];
    [imageView setImageWithURL:url placeholderImage:UIIMAGE_DEFAULT_USER_AVATOR];
    [self addSubview:imageView];


    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(90, self.frame.size.height - 60, 100, 20)];
    userName.textAlignment = UITextAlignmentLeft;
    userName.textColor = [UIColor whiteColor];
    userName.backgroundColor = [UIColor clearColor];
    userName.shadowColor = [UIColor blackColor];
    userName.shadowOffset = CGSizeMake(1.0, 0.0);
    userName.font = [UIFont boldSystemFontOfSize:18];
    userName.text = user.name;
    [self addSubview:userName];

    _mileStone = [[UILabel alloc] initWithFrame:CGRectMake(90, self.frame.size.height - 50, 100, 40)];
    _mileStone.textAlignment = UITextAlignmentLeft;
    _mileStone.textColor = [UIColor whiteColor];
    _mileStone.backgroundColor = [UIColor clearColor];
    _mileStone.shadowColor = [UIColor blackColor];
    _mileStone.shadowOffset = CGSizeMake(1.0, 0.0);
    _mileStone.font = [UIFont fontWithName:@"Arial" size:12];
    _mileStone.text = [NSString stringWithFormat:@"总距离: %@", [user getTotalDistanceToKm]];
    [self addSubview:_mileStone];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(90, 20, 140, 140)];
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
