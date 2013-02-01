//
//  JsonCall.h
//  iEverBox
//
//  Created by tinyfool on 10-6-2.
//  Copyright 2010 SNDA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonCall : NSObject

+ (id)down:(NSString *)urlString withString:(NSString *)postString isForm:(BOOL)isForm;

+ (id)call:(NSString *)urlString withData:(id)data;

+ (id)uploadImageWithURL:(NSString *)urlString withDictinary:(NSDictionary *)dict;

+ (id)downloadImageWithURL:(NSString *)urlString withData:(id)data;
@end
