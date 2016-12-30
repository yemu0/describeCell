//
//  YMComment.h
//  YMFastDrawCell
//
//  Created by 夜幕 on 16/12/27.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMComment : NSObject

@property (nonatomic,strong) NSString *name;

@property (nonatomic,strong) NSString *content;

+(instancetype) commentCreate;
@end
