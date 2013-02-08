//
//  QQNRServerTaskQueue.m
//  Ridding
//
//  Created by zys on 12-12-22.
//
//

#import "QQNRServerTaskQueue.h"

static QQNRServerTaskQueue *sharedQueue = nil;

@implementation QQNRServerTaskQueue


- (id)init {

  self = [super init];
  if (self) {
    _queue = [[NSOperationQueue alloc] init];
    [_queue setMaxConcurrentOperationCount:1];
  }

  return self;
}

+ (QQNRServerTaskQueue *)sharedQueue {

  @synchronized (self) {
    if (sharedQueue == nil) {
      sharedQueue = [[self alloc] init];
    }
  }
  return sharedQueue;
}

- (void)addTask:(QQNRServerTask *)task withDependency:(BOOL)dependsOnLastOperation {

  if (dependsOnLastOperation &&[[_queue operations]count]>0) {
    [task addDependency:[[_queue operations] lastObject]];
  }
  task.queueDelegate = self;

  [_queue addOperation:task];

}


#pragma mark - MPServerTaskQueueDelegate
- (void)setServerResponseJSON:(NSDictionary *)serverJSON {
  self.lastTaskServerResponseJSON = serverJSON;
}

- (NSInteger)countOfTasksRemainsInQueue {

  return [_queue operationCount];
}

@end
