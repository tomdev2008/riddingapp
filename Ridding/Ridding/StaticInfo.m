//
//  StaticInfo.m
//  Ridding
//
//  Created by zys on 12-3-27.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "StaticInfo.h"
static StaticInfo *staticInfo=nil;
@implementation StaticInfo
@synthesize canConnect;
@synthesize user;
@synthesize logined;
@synthesize plistSavePath;
- (id)init
{
    self = [super init];
    if (self) {
        user=[[User alloc]init];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
        NSString *documentsDirectory = [paths objectAtIndex:0]; 
        plistSavePath=[documentsDirectory stringByAppendingPathComponent:@"staticInfo.plist"]; 
        logined=false;
    }
    
    return self;
}
+ (StaticInfo*)getSinglton
{
    @synchronized(self) {
        if (staticInfo == nil) {
            staticInfo=[[self alloc] init]; // assignment not done here
        }
    }
    return staticInfo;
}
//读取文件
-(NSMutableDictionary *)loadFromFile {
    NSString *error = nil;
    NSPropertyListFormat format;
    NSMutableDictionary *dict = nil;
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistSavePath]) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *defaultPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"staticInfo.plist"];
        Boolean success = [fileManager copyItemAtPath:defaultPath toPath:plistSavePath error:nil];
        if (!success) {
            NSLog(@"Failed to create staticInfo.plist where defaultPath = %@ and toPath =%@ ",defaultPath,plistSavePath);
        }
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistSavePath];
    dict = (NSMutableDictionary *)[NSPropertyListSerialization propertyListFromData:plistXML 
                                                                   mutabilityOption:NSPropertyListMutableContainersAndLeaves 
                                                                             format:&format 
                                                                   errorDescription:&error];
    return dict;
}
//保存文件
-(BOOL)saveToFile:(NSMutableDictionary *)withData {
    NSString *error = nil;
    NSData    *plistData = [NSPropertyListSerialization dataFromPropertyList:withData format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
    if(plistData) {
        return [plistData writeToFile:plistSavePath atomically:YES];
    } else {
        return FALSE;
    }
}


- (void)saveDistanceToUserDefault:(int)distance{
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  [prefs setObject:INT2NUM(user.totalDistance) forKey:kStaticInfo_totalDistance];
}



@end
