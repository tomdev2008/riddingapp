//
//  ImageSwipeViewController.m
//  Ridding
//
//  Created by Wu Chenhao on 5/8/12.
//  Copyright (c) 2012 MicroStrategy. All rights reserved.
//

#import "ImageSwipeViewController.h"

@implementation ImageSwipeViewController
@synthesize scrollView;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];

  // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle


- (void)viewDidUnload {

  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown);
}

- (id)initWithFrameRect:(CGRect)rect ImageArray:(NSArray *)array {

  if ((self = [super init])) {
    imageArray = array;
    viewSize = rect;
  }
  return self;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {

  [super viewDidLoad];
  [self.view setFrame:viewSize];
  NSUInteger pageCount = [imageArray count];
  scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewSize.size.width, viewSize.size.height)];
  scrollView.pagingEnabled = YES;
  scrollView.contentSize = CGSizeMake(viewSize.size.width * pageCount, viewSize.size.height);
  scrollView.showsHorizontalScrollIndicator = NO;
  scrollView.bounces=NO;
  scrollView.showsVerticalScrollIndicator = NO;
  scrollView.scrollsToTop = NO;
  scrollView.delegate = self;
  for (int i = 0; i < pageCount; i++) {
    UIImage *img = [imageArray objectAtIndex:i];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    [imgView setFrame:CGRectMake(viewSize.size.width * i, 0, viewSize.size.width, viewSize.size.height)];
    imgView.tag = i;
    UITapGestureRecognizer *Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
    [Tap setNumberOfTapsRequired:1];
    [Tap setNumberOfTouchesRequired:1];
    imgView.userInteractionEnabled = YES;
    [imgView addGestureRecognizer:Tap];
    [scrollView addSubview:imgView];
  }
  [self.view addSubview:scrollView];
  
  _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  
  _startBtn.frame=CGRectMake(100, SCREEN_HEIGHT-60, 122, 32);
  [_startBtn setImage:UIIMAGE_FROMPNG(@"screenshot_button_start") forState:UIControlStateNormal];
  
  [_startBtn addTarget:self action:@selector(startApp) forControlEvents:UIControlEventTouchUpInside];
  _startBtn.hidden=YES;
  _startBtn.alpha=0.0;
  [self.view addSubview:_startBtn];


}

- (void)scrollViewDidScroll:(UIScrollView *)sender {

  CGFloat pageWidth = scrollView.frame.size.width;
  int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
  if(page==4&&_startBtn.hidden==YES){
    
    _startBtn.hidden=NO;
    [UIView animateWithDuration:1.0 animations:^{
      _startBtn.alpha=1.0;
    }];
  }
  if(page!=4){
    
    _startBtn.hidden=YES;
    _startBtn.alpha=0.0;
  }
  
}

- (void)startApp{
  if (self.delegate) {
    [self.delegate startApp];
  }
}

- (void)imagePressed:(UITapGestureRecognizer *)sender {
}

@end
