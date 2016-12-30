//
//  YMComment.m
//  YMFastDrawCell
//
//  Created by 夜幕 on 16/12/27.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import "YMComment.h"

@implementation YMComment


+(instancetype)commentCreate{
    
    YMComment *cmt = [[YMComment alloc]init];
    
    static int i = 0;
    cmt.name = [NSString stringWithFormat:@"评论人%03zd",i++];
    
    
    NSInteger number = arc4random_uniform(10)+2;
    NSMutableString *strM = [NSMutableString string];
    
    for (int n=0; n<number; n++) {
        
        [strM appendString:@"我是评论_"];
    }
    cmt.content = strM;
    return cmt;
}
@end
