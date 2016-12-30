//
//  UIView+YMFrameExtension.m
//  百思
//
//  Created by 夜幕 on 16/11/22.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import "UIView+YMFrameExtension.h"

@implementation UIView (YMFrameExtension)


-(CGFloat)ym_x{
    return self.frame.origin.x;
}
-(void)setYm_x:(CGFloat)ym_x{
    CGRect frame = self.frame;
    frame.origin.x = ym_x;
    self.frame = frame;
}

-(CGFloat)ym_y{
    return self.frame.origin.y;
}
-(void)setYm_y:(CGFloat)ym_y{
    CGRect frame = self.frame;
    frame.origin.y = ym_y;
    self.frame = frame;
}

-(CGFloat)ym_width{
    return self.frame.size.width;
}

-(void)setYm_width:(CGFloat)ym_width{
    CGRect frame = self.frame;
    frame.size.width = ym_width;
    self.frame = frame;
}

-(CGFloat)ym_height{
    return self.frame.size.height;
}
-(void)setYm_height:(CGFloat)ym_height{
    CGRect frame = self.frame;
    frame.size.height = ym_height;
    self.frame = frame;
}

-(CGFloat)ym_centerX{
    return self.center.x;
}
-(void)setYm_centerX:(CGFloat)ym_centerX{
    CGPoint center = self.center;
    center.x = ym_centerX;
    self.center = center;
}

-(CGFloat)ym_centerY{
    return self.center.y;
}
-(void)setYm_centerY:(CGFloat)ym_centerY{
    CGPoint center = self.center;
    center.y = ym_centerY;
    self.center = center;
}
-(CGFloat)ym_bottom{
    
    return CGRectGetMaxY(self.frame);
}
- (void)setYm_bottom:(CGFloat)ym_bottom
{
    self.ym_y = ym_bottom - self.ym_height;
}

-(CGRect)ym_statusFrame{
    
    return [UIApplication sharedApplication].statusBarFrame;
}
-(void)setYm_statusFrame:(CGRect)ym_statusFrame{
  
}
@end








