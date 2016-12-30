//
//  YMSudoko.m
//  YMCell封装测试
//
//  Created by 夜幕 on 16/12/10.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import "YMSuduko.h"

@implementation YMSuduko


-(void)sudukoWithSuduko:(YMSuduko *)suduko{
    self.subviewSize = suduko.subviewSize;
    self.viewWidth = suduko.viewWidth;
    self.viewMargin = suduko.viewMargin;
    self.number = suduko.number;
    self.column = suduko.column;
}

-(CGSize)subviewSize{
    
    CGSize size = _subviewSize;
    
    if(size.width == 0)
        size.width = [self sudukoSubviewWidth:self.viewWidth];
    
    if(size.height == 0)
        size.height = size.width;
    
    return size;
}
-(CGFloat)sudukoSubviewWidth:(CGFloat)sudukoWidth
{
    NSInteger column = self.column;
    if(self.number <column)
        column = self.number;
    return  (sudukoWidth - self.viewMargin*(column-1))/column;
}
@end
