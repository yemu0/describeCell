//
//  YMPictureView.h
//  YMFastDrawCell
//
//  Created by 夜幕 on 16/12/20.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMPictureView : UIView


@property (nonatomic,strong) NSArray *showImages;
@property (nonatomic,assign) NSInteger selectIndex;

@property (nonatomic,assign) CGRect selectImageFrame;
@end
