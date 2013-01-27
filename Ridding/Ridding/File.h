//
//  File.h
//  Ridding
//
//  Created by zys on 12-12-23.
//
//

#import <Foundation/Foundation.h>
#import "BasicObject.h"

@interface File : BasicObject

@property (nonatomic, copy) NSString *fileKey;
@property (nonatomic, copy) NSString *filePath;
@property (nonatomic) int width;
@property (nonatomic) int height;
@property (nonatomic, retain) NSData *fileData;
@property (nonatomic, retain) UIImage *fileImage;
@end
