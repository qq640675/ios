//
//  YLChoosePicture.h
//  beijing
//
//  Created by zhou last on 2018/6/25.
//  Copyright © 2018年 zhou last. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


typedef enum {
    YLPickImageTypeAlbum = 0, //相册
    YLPickImageTypeCamera, //拍照
} YLPickImageType;

@interface YLChoosePicture : NSObject

typedef void(^YLPickImageFinish)(UIImage *pickImage);

+ (id)shareInstance;

- (void)choosePicture:(UIViewController *)selfNav type:(YLPickImageType)type pickBlock:(YLPickImageFinish)pickBlock;
- (void)choosePicture:(UIViewController *)selfNav pickBlock:(YLPickImageFinish)pickBlock;

@end
