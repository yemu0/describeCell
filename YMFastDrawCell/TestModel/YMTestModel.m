//
//  YMTestModel.m
//  YMFastDrawCell
//
//  Created by 夜幕 on 16/12/12.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import "YMTestModel.h"
#import "YMTestForwardModel.h"
#import "YMComment.h"
@implementation YMTestModel

+(instancetype)testModelFastCreate{
    

    YMTestModel *test = [[YMTestModel alloc]init];
    //内容的东西
    NSInteger number = arc4random_uniform(30)+20;
    NSMutableString *str_M = [NSMutableString string];
    for(int i=0;i<number;i++){
        [str_M appendString:@"哈"];
    }
    if(str_M<=0)
        test.content = @"ZZZZZZzzzz";
    else
        test.content = [NSString stringWithString:str_M];
     
    [str_M deleteCharactersInRange:NSMakeRange(0, str_M.length)];
    
     //子标题
    number = arc4random_uniform(20)+1;
    for(int i=0;i<number;i++){
        [str_M appendString:@"呵-"];
    }

    test.subContent = str_M;
    
    //图片名字
    static int i= 0;
    test.imageName = [NSString stringWithFormat:@"%zd",i];

    //图片数组
    test.imageNames = [NSMutableArray array];
    
    number = arc4random_uniform(8)+1;
    for(int n=0; n<number;n++){
        
         [test.imageNames addObject:[NSString stringWithFormat:@"%zd",i]];
    }

    if(i>=20)
        i=0;
    //用户名
    test.name =[NSString stringWithFormat:@"用户名00%zd",i++];
   
    //转发
    number = arc4random_uniform(2);
    if(number){
         test.forward = [YMTestForwardModel forwardFastCreate];
         [test.imageNames removeAllObjects];
    }
    
    //时间
    test.createTimer = [NSString stringWithFormat:@"%@",[NSDate date]];
    
    //图片大小
    test.imageSize = [UIImage imageNamed:test.imageName].size;
    
    //创建评论数据
    NSMutableArray *arrM = [NSMutableArray array];
    number = arc4random_uniform(3)+1;
    
    for (int i=0; i<number; i++) {
        
        [arrM addObject:[YMComment commentCreate]];
    }
    
    test.comments = arrM;
    return test;
    
}

+(instancetype)testModelFastCreateWangYiNews{
    
    
    YMTestModel *test = [[YMTestModel alloc]init];
    //内容的东西
    NSInteger number = arc4random_uniform(30)+20;
    NSMutableString *str_M = [NSMutableString string];
    for(int i=0;i<number;i++){
        [str_M appendString:@"哈"];
    }
    if(str_M<=0)
        test.content = @"ZZZZZZzzzz";
    else
        test.content = [NSString stringWithString:str_M];
    
    [str_M deleteCharactersInRange:NSMakeRange(0, str_M.length)];
    
   
    //图片名字
    static int i= 0;
  
    //图片数组
    NSArray *arr =@[@1,@3];
    number = arc4random_uniform(2);
    
    NSString *str = arr[number];
    
    NSMutableArray *arrayM = [NSMutableArray array];
    for(int n=0; n<str.intValue;n++){
        
        [arrayM addObject:[NSString stringWithFormat:@"%zd",i]];
//        NSLog(@"%zd  %zd",test.imageNames.count,str.intValue);
    }
    test.imageNames = arrayM;
    i++;
    if(i==20)
        i=0;
    return test;
    
}
@end
