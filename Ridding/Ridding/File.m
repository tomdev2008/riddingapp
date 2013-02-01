//
//  File.m
//  Ridding
//
//  Created by zys on 12-12-23.
//
//

@implementation File


- (void)saveImageToLocal:(UIImage*)image{
  int count = arc4random()%10000;
  NSString *fileName=[NSString stringWithFormat:@"tmp_%d.jpg",count];
  self.filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
  NSData *fileData=UIImageJPEGRepresentation(image, 1.0);
  [fileData writeToFile:self.filePath atomically:YES];
}

- (UIImage*)imageFromLocal{
  NSData *data=[NSData dataWithContentsOfFile:self.filePath];
  return [UIImage imageWithData:data];
}
@end
