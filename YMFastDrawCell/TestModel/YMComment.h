//
//  YMComment.h
//  YMFastDrawCell
//
//  Created by 夜幕 on 16/12/27.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YMLabel.h"

@interface YMComment : NSObject

@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) NSString *content;

//是否展开
@property (nonatomic,assign) YMLabelShowType  labelShowType;
+(instancetype) commentCreate;
@end
