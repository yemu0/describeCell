//
//  UIView+YMFrameExtension.h
//  百思
//
//  Created by 夜幕 on 16/11/22.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YMFrameExtension)

@property (nonatomic,assign) CGFloat ym_x;

@property (nonatomic,assign) CGFloat ym_y;

@property (nonatomic,assign) CGFloat ym_width;

@property (nonatomic,assign) CGFloat ym_height;

@property (nonatomic,assign) CGFloat ym_centerX;

@property (nonatomic,assign) CGFloat ym_centerY;

@property (nonatomic,assign) CGFloat ym_bottom;

@property (nonatomic,assign) CGRect ym_statusFrame;
@end
