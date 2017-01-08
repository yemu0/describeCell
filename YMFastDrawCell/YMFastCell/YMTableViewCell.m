//
//  YMTableViewCell.m
//  YMCell封装测试
//
//  Created by 夜幕 on 16/12/2.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import "YMTableViewCell.h"
#import "UIView+YMFrameExtension.h"
#import "YMCellHeaderView.h"
#import "YMCellCenterView.h"
#import "YMCellFooterView.h"

@interface YMTableViewCell()

@property (nonatomic,assign) BOOL isLoadHeaderView;

/**属性*/
@property (nonatomic,assign) BOOL isLoadCenterView;

@property (nonatomic,assign) BOOL isLoadFooterView;

@property (nonatomic,assign) BOOL isRunSetAttribute;

@property (nonatomic,copy) void(^completionDescribe)();



@end

@implementation YMTableViewCell


#pragma mark 懒加载
-(YMCellHeaderView *)ym_headerView{

    if(_ym_headerView ==nil){
        _isLoadHeaderView = YES;
         YMCellHeaderView *headerV = [[YMCellHeaderView alloc]init];
        
        [self addSubview:headerV];
        
        
        _ym_headerView = headerV;
        
    }
    return _ym_headerView;
}


-(YMCellCenterView *)ym_centerView{
    
    if(_ym_centerView == nil){
        _isLoadCenterView = YES;
        YMCellCenterView *centerV = [[YMCellCenterView alloc]init];
        _ym_centerView = centerV;
        [self addSubview:centerV];
    }
    return _ym_centerView;

}
-(YMCellFooterView *)ym_footerView{
    
    if(_ym_footerView == nil){
        _isLoadFooterView = YES;
        YMCellFooterView *footerV = [[YMCellFooterView alloc]init];
        _ym_footerView = footerV;
        [self addSubview:footerV];

    }
    return _ym_footerView;
}


#pragma -mark 方法



-(void)ym_startDescribe{
    
    CGFloat maxButtom = 0;
    
    if(_isLoadHeaderView){
       [self.ym_headerView ym_startDraw];
        maxButtom = self.ym_headerView.ym_bottom;
    }
    if(_isLoadCenterView){
        
        if(_isLoadHeaderView)
            self.ym_centerView.ym_y = self.ym_headerView.ym_bottom;
        [self.ym_centerView ym_startDraw];
        maxButtom = self.ym_centerView.ym_bottom;
    }
    if(_isLoadFooterView)
    {
        if(_isLoadHeaderView)
            self.ym_footerView.ym_y =self.ym_headerView.ym_bottom;
        if(_isLoadCenterView)
            self.ym_footerView.ym_y =self.ym_centerView.ym_bottom;
        [self.ym_footerView ym_startDraw];
        maxButtom = self.ym_footerView.ym_bottom;
    }

    self.ym_height = maxButtom+self.ym_cellMargin*2;
    
    if(self.completionDescribe)
        self.completionDescribe();
}

-(void)ym_completionDescribe:(void (^)())completion{
    
    if(!self.completionDescribe)
        self.completionDescribe = completion;
}

-(void)ym_setupAttribute:(ym_setAttributeBlock)setBlock{
    
    if(self.isRunSetAttribute == NO){
        setBlock();
        self.isRunSetAttribute = YES;
    }
}

#pragma  -mark 重写
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        self.ym_width = [UIScreen mainScreen].bounds.size.width;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.ym_cellMargin = 10;
    }
    return self;
}
-(void)setFrame:(CGRect)frame{

    frame.size.height -= self.ym_cellMargin;
    [super setFrame:frame];
}

-(void)dealloc{
    
    NSLog(@"cell dealloc %p",self);
}


@end
