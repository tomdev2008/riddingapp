//
//  NSIndexPath+RG_Utilities.m
//  MyBabyCare
//
//  Created by Tom on 1/18/12.
//  Copyright (c) 2012 儒果网络. All rights reserved.
//

#import "NSIndexPath+RG_Utilities.h"

@implementation NSIndexPath (RG_Utilities)

- (BOOL)isSameOfIndexPath:(NSIndexPath *)indexPath {
	
  if (!indexPath) {
    return NO;
  }

	return ([indexPath row]==[self row]) && ([indexPath section] == [self section]);
}

@end
