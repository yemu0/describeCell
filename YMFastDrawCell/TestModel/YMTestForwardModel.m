//
//  YMTestForwardModel.m
//  YMFastDrawCell
//
//  Created by 夜幕 on 16/12/19.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import "YMTestForwardModel.h"

@implementation YMTestForwardModel

+(instancetype)forwardFastCreate{
    
    YMTestForwardModel *test = [[YMTestForwardModel alloc]init];

    
//    //内容的东西
    NSInteger number = arc4random_uniform(10)+1;
    NSMutableString *str_M = [NSMutableString string];
    for(int i=0;i<number;i++){
        [str_M appendString:@"这是转发内容"];
    }
  
    test.content = [NSString stringWithString:str_M];
    
    [str_M deleteCharactersInRange:NSMakeRange(0, str_M.length)];
    
    //图片名字
    number = arc4random_uniform(18)+1;
    test.imageName = [NSString stringWithFormat:@"%zd",number];
    
    //用户名
    static int i= 1;
    test.name =[NSString stringWithFormat:@"转发用户名00%zd",i++];
    //图片数量
    NSArray *arr = @[@1,@4,@7,@9];
    number = arc4random_uniform(3);
    
    NSString *str2 = (NSString *)arr[number];
    test.imageNumber = str2.integerValue;
    
    //图片数组
    test.imageNames = [NSMutableArray array];
    
    number = arc4random_uniform(8)+1;
    for(int n=0; n<number;n++){
        [test.imageNames addObject:[NSString stringWithFormat:@"%zd",n+arc4random_uniform(8)]];
    }

    return test;
    
}
@end
