//
//  YMTestModel.h
//  YMFastDrawCell
//
//  Created by 夜幕 on 16/12/12.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMTestForwardModel,YMComment;
@interface YMTestModel : NSObject

@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) NSString *imageName;

@property (nonatomic,strong) NSMutableArray *imageNames;

@property (nonatomic,strong) NSString *imageName2;

@property (nonatomic,strong) NSString *content;

@property (nonatomic,strong) NSString *subContent;

@property (nonatomic,assign) NSInteger imageNumber;

@property (nonatomic,strong) NSString *createTimer;

@property (nonatomic,assign) CGSize imageSize;

@property (nonatomic,strong) YMTestForwardModel *forward;

@property (nonatomic,strong) NSArray <YMComment *>*comments;
+(instancetype) testModelFastCreate;
+(instancetype)testModelFastCreateWangYiNews;
@end
