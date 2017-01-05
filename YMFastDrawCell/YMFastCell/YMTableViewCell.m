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

@property (nonatomic,assign) BOOL isLayoutSubViewOK;

@property (nonatomic,copy) void(^completionDescribe)();

/** 存放手势激活块的数组*/
@property (nonatomic,strong) NSMutableArray <ym_gestureActive>*ym_gestures;

/** 存放手势view的数组*/
@property (nonatomic,strong) NSMutableArray <UIView *>* ym_gestureViews;

@end

@implementation YMTableViewCell


#pragma mark 懒加载
-(NSMutableArray<UIView *> *)ym_gestureViews{
    
    if(_ym_gestureViews ==nil){
        
        _ym_gestureViews = [NSMutableArray array];
    }
    
    return _ym_gestureViews;

}
-(NSMutableArray<ym_gestureActive> *)ym_gestures{
    
    if(_ym_gestures ==nil){
        
        _ym_gestures = [NSMutableArray array];
    }
    
    return _ym_gestures;
}


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


-(void)ym_addGestureRecognizerTypeWithClass:(Class)gestureClass targetView:(UIView *)targetView activeBlock:(void(^)(UIView *view))active{
    
    //判断是否已经添加过相同手势
    for (UIGestureRecognizer *gesture in targetView.gestureRecognizers) {
        
        if( [gesture isKindOfClass:gestureClass]){
            //替换块
            int i = 0;
            for (UIView *view in self.ym_gestureViews) {
                if(view==targetView){
                 self.ym_gestures[i] = active;
                 break;
                }
            }
            return;
        }
    }

    UIGestureRecognizer *gesture = [[gestureClass alloc]init];
    [gesture addTarget:self action:@selector(gestureActive:)];

    [targetView addGestureRecognizer:gesture];
    targetView.userInteractionEnabled = YES;
    
    //保存块
    [self.ym_gestures addObject:active];
    //保存view
    [self.ym_gestureViews addObject:targetView];
}

-(void)gestureActive:(UIGestureRecognizer *)gesture{
    
    //根据对应的view取出对应的激活块
    int i=0;
    for (UIView *view in self.ym_gestureViews) {
        if(view == gesture.view){
          ym_gestureActive avtive = self.ym_gestures[i];
          avtive(view);
          return;
        }
        i++;
    }

}

-(void)drawCellHeaderView:(void (^)(YMCellHeaderView *))headerView{
    
    headerView(self.ym_headerView);
}

-(void)drawCellCenterContentView:(void (^)(YMCellCenterView *))centerView{
    
    centerView(self.ym_centerView);
}


-(void)ym_startDescribe{
    
    CGFloat maxButtom = 0;
    
    if(_isLoadHeaderView){
       [self.ym_headerView ym_startDraw];
        maxButtom = self.ym_headerView.ym_bottom;
    }
    if(_isLoadCenterView){
        
        if(_isLoadHeaderView)
            self.ym_centerView.ym_y = self.ym_headerView.ym_bottom+self.ym_centerView.ym_margin;
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
