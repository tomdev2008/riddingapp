//
//  UIImage+Utilities.m
//  FoodFlow
//
//  Created by Kishikawa Katsumi on 11/09/05.
//  Copyright (c) 2011 Kishikawa Katsumi. All rights reserved.
//

#import "UIImage+Utilities.h"

@implementation UIImage(Utilities)

- (CGRect)convertCropRect:(CGRect)cropRect {
    UIImage *originalImage = self;
    
    CGSize size = originalImage.size;
    CGFloat x = cropRect.origin.x;
    CGFloat y = cropRect.origin.y;
    CGFloat width = cropRect.size.width;
    CGFloat height = cropRect.size.height;
    UIImageOrientation imageOrientation = originalImage.imageOrientation;
    if (imageOrientation == UIImageOrientationRight || imageOrientation == UIImageOrientationRightMirrored) {
        cropRect.origin.x = y;
        cropRect.origin.y = size.width - cropRect.size.width - x;
        cropRect.size.width = height;
        cropRect.size.height = width;
    } else if (imageOrientation == UIImageOrientationLeft || imageOrientation == UIImageOrientationLeftMirrored) {
        cropRect.origin.x = size.height - cropRect.size.height - y;
        cropRect.origin.y = x;
        cropRect.size.width = height;
        cropRect.size.height = width;
    } else if (imageOrientation == UIImageOrientationDown || imageOrientation == UIImageOrientationDownMirrored) {
        cropRect.origin.x = size.width - cropRect.size.width - x;;
        cropRect.origin.y = size.height - cropRect.size.height - y;
    }
    
    return cropRect;
}

- (UIImage *)croppedImage:(CGRect)cropRect {   
    CGImageRef croppedCGImage = CGImageCreateWithImageInRect(self.CGImage ,cropRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:croppedCGImage scale:1.0f orientation:self.imageOrientation];
    CGImageRelease(croppedCGImage);
    
    return croppedImage;
}

- (UIImage *)resizedImage:(CGSize)size imageOrientation:(UIImageOrientation)imageOrientation {    
    CGSize imageSize = self.size;
    CGFloat horizontalRatio = size.width / imageSize.width;
    CGFloat verticalRatio = size.height / imageSize.height;
    CGFloat ratio = MIN(horizontalRatio, verticalRatio);
    CGSize targetSize = CGSizeMake(imageSize.width * ratio, imageSize.height * ratio);
    
	UIGraphicsBeginImageContextWithOptions(size, YES, 1.0f);
	CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGContextTranslateCTM(context, 0.0f, -size.height);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    if (imageOrientation == UIImageOrientationRight || imageOrientation == UIImageOrientationRightMirrored) {
        transform = CGAffineTransformTranslate(transform, 0.0f, size.height);
        transform = CGAffineTransformRotate(transform, -M_PI_2);
    } else if (imageOrientation == UIImageOrientationLeft || imageOrientation == UIImageOrientationLeftMirrored) {
        transform = CGAffineTransformTranslate(transform, size.width, 0.0f);
        transform = CGAffineTransformRotate(transform, M_PI_2);
    } else if (imageOrientation == UIImageOrientationDown || imageOrientation == UIImageOrientationDownMirrored) {
        transform = CGAffineTransformTranslate(transform, size.width, size.height);
        transform = CGAffineTransformRotate(transform, M_PI);
    }
    CGContextConcatCTM(context, transform);
    
	CGContextDrawImage(context, CGRectMake((size.width - targetSize.width) / 2, (size.height - targetSize.height) / 2, targetSize.width, targetSize.height), self.CGImage);
    
	UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    return resizedImage;
}


- (CGFloat) getHeightByWidth:(UIImage*)image toWidth:(CGFloat)toWidth{
  CGFloat width= CGImageGetWidth([image CGImage]);
  CGFloat height= CGImageGetHeight([image CGImage]);
  return toWidth/width*height;
}
- (CGFloat) getWidthByHeight:(UIImage*)image toHeight:(CGFloat)toHeight{
  CGFloat width= CGImageGetWidth([image CGImage]);
  CGFloat height= CGImageGetHeight([image CGImage]);
  return toHeight/width*height;
}

-(UIImage *)rotateImage
{
  CGImageRef imgRef = self.CGImage;
  CGFloat width = CGImageGetWidth(imgRef);
  CGFloat height = CGImageGetHeight(imgRef);
  CGAffineTransform transform = CGAffineTransformIdentity;
  CGRect bounds = CGRectMake(0, 0, width, height);
  CGFloat scaleRatio = 1;
  CGFloat boundHeight;
  UIImageOrientation orient = self.imageOrientation;
  switch(orient)
  {
    case UIImageOrientationUp: //EXIF = 1
      transform = CGAffineTransformIdentity;
      break;
    case UIImageOrientationUpMirrored: //EXIF = 2
      transform = CGAffineTransformMakeTranslation(width, 0.0);
      transform = CGAffineTransformScale(transform, -1.0, 1.0);
      break;
    case UIImageOrientationDown: //EXIF = 3
      transform = CGAffineTransformMakeTranslation(width, height);
      transform = CGAffineTransformRotate(transform, M_PI);
      break;
    case UIImageOrientationDownMirrored: //EXIF = 4
      transform = CGAffineTransformMakeTranslation(0.0, height);
      transform = CGAffineTransformScale(transform, 1.0, -1.0);
      break;
    case UIImageOrientationLeftMirrored: //EXIF = 5
      boundHeight = bounds.size.height;
      bounds.size.height = bounds.size.width;
      bounds.size.width = boundHeight;
      transform = CGAffineTransformMakeTranslation(height, width);
      transform = CGAffineTransformScale(transform, -1.0, 1.0);
      transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
      break;
    case UIImageOrientationLeft: //EXIF = 6
      boundHeight = bounds.size.height;
      bounds.size.height = bounds.size.width;
      bounds.size.width = boundHeight;
      transform = CGAffineTransformMakeTranslation(0.0, width);
      transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
      break;
    case UIImageOrientationRightMirrored: //EXIF = 7
      boundHeight = bounds.size.height;
      bounds.size.height = bounds.size.width;
      bounds.size.width = boundHeight;
      transform = CGAffineTransformMakeScale(-1.0, 1.0);
      transform = CGAffineTransformRotate(transform, M_PI / 2.0);
      break;
    case UIImageOrientationRight: //EXIF = 8
      boundHeight = bounds.size.height;
      bounds.size.height = bounds.size.width;
      bounds.size.width = boundHeight;
      transform = CGAffineTransformMakeTranslation(height, 0.0);
      transform = CGAffineTransformRotate(transform, M_PI / 2.0);
      break;
    default:
      [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
  }
  UIGraphicsBeginImageContext(bounds.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
    CGContextScaleCTM(context, -scaleRatio, scaleRatio);
    CGContextTranslateCTM(context, -height, 0);
  }
  else {
    CGContextScaleCTM(context, scaleRatio, -scaleRatio);
    CGContextTranslateCTM(context, 0, -height);
  }
  CGContextConcatCTM(context, transform);
  CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
  UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return imageCopy;
}


@end
