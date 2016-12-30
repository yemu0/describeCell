//
//  YMTestForwardModel.h
//  YMFastDrawCell
//
//  Created by 夜幕 on 16/12/19.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMTestForwardModel : NSObject



@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) NSString *imageName;

@property (nonatomic,strong) NSString *content;

@property (nonatomic,strong) NSMutableArray *imageNames;

@property (nonatomic,assign) NSInteger imageNumber;


+(instancetype) forwardFastCreate;
@end
