//
//  StaticInfo.m
//  Ridding
//
//  Created by zys on 12-3-27.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//
#define kRecomApp @"recomApp"
#define kMapCreateTips @"createTips"
static StaticInfo *staticInfo = nil;

@implementation StaticInfo
@synthesize canConnect;
@synthesize user;
@synthesize logined;
@synthesize plistSavePath;

- (id)init {

  self = [super init];
  if (self) {
    user = [[User alloc] init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    plistSavePath = [documentsDirectory stringByAppendingPathComponent:@"staticInfo.plist"];
    logined = false;
    [self initSqlDB];
    _routesDic=[[NSMutableDictionary alloc]init];
  }

  return self;
}

+ (StaticInfo *)getSinglton {

  @synchronized (self) {
    if (staticInfo == nil) {
      staticInfo = [[self alloc] init]; // assignment not done here
    }
  }
  return staticInfo;
}

//读取文件
- (NSMutableDictionary *)loadFromFile {

  NSString *error = nil;
  NSPropertyListFormat format;
  NSMutableDictionary *dict = nil;
  if (![[NSFileManager defaultManager] fileExistsAtPath:plistSavePath]) {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *defaultPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"staticInfo.plist"];
    Boolean success = [fileManager copyItemAtPath:defaultPath toPath:plistSavePath error:nil];
    if (!success) {
      NSLog(@"Failed to create staticInfo.plist where defaultPath = %@ and toPath =%@ ", defaultPath, plistSavePath);
    }
  }
  NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistSavePath];
  dict = (NSMutableDictionary *) [NSPropertyListSerialization propertyListFromData:plistXML
                                                                  mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                                                            format:&format
                                                                  errorDescription:&error];
  return dict;
}

//保存文件
- (BOOL)saveToFile:(NSMutableDictionary *)withData {

  NSString *error = nil;
  NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:withData format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
  if (plistData) {
    return [plistData writeToFile:plistSavePath atomically:YES];
  } else {
    return FALSE;
  }
}


- (void)saveDistanceToUserDefault:(int)distance {

  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  [prefs setObject:INT2NUM(user.totalDistance) forKey:kStaticInfo_totalDistance];
}

- (void)initSqlDB {
  @synchronized(self){
    //paths： ios下Document路径，Document为ios中可读写的文件夹
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"newRidding.sqlite"];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    //dbPath： 数据库路径，在Document中。
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"newRidding.sqlite"];
    if (![fileManager fileExistsAtPath:dbPath]) {
      NSError *error;
      BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
      if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        return;
      }
    }
    
    //创建数据库实例 db  这里说明下:如果路径中不存在"Test.db"的文件,sqlite会自动创建"Test.db"
    _sqlDB = [FMDatabase databaseWithPath:dbPath];
    if (![_sqlDB open]) {
      return;
    }
  }

}

+ (NSString*)routeDicKey:(long long)riddingId userId:(long long)userId{
  return [NSString stringWithFormat:@"%lld_%lld",riddingId,userId];
}


- (NSString*)kRecomAppKey{
  
  return kRecomApp;
}
- (NSString*)kMapCreateTipsKey{
  
  return [NSString stringWithFormat:@"%lld_%@",self.user.userId,kMapCreateTips];
}
@end
