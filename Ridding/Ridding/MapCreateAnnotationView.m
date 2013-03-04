//
//  MapCreateAnnotationView.m
//  Ridding
//
//  Created by zys on 13-2-21.
//
//

#import "MapCreateAnnotationView.h"

@implementation MapCreateAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (IBAction)beginBtnClick:(id)sender{
  
  if(self.delegate){
    [self.delegate beginBtnClick:self];
  }
}

- (IBAction)passBtnClick:(id)sender{
  
  if(self.delegate){
    [self.delegate passBtnClick:self];
  }
}

- (IBAction)endBtnClick:(id)sender{
  
  if(self.delegate){
    [self.delegate endBtnClick:self];
  }
}

@end
