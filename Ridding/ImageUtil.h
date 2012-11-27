//
//  ImageUtil.h
//  Ridding
//
//  Created by zys on 12-9-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum IMAGETYPE {
	IMAGETYPE_MAP = 1,
	IMAGETYPE_PICTURE = 2,
}IMAGETYPE;
@interface ImageUtil : NSObject


+ (NSString*)uploadPhotoToServer:(NSString*)localPath prefixPath:(NSString*)prefixPath type:(IMAGETYPE)type;
+ (NSString*)uploadPhotoToServerByImage:(UIImage*)image prefixPath:(NSString*)prefixPath type:(IMAGETYPE)type;
@end
