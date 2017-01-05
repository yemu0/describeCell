//
//  YMBaseCellsubView.m
//  YMCell封装测试
//
//  Created by 夜幕 on 16/12/3.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import "YMBaseCellsubView.h"
#import "UIView+YMFrameExtension.h"
@interface YMBaseCellsubView()


@property (nonatomic,strong) NSMutableDictionary *identifierDict;

@property (nonatomic,assign) BOOL isRunSetAttribute;

/** 自定义frame如需依赖样式窗口frame 在这里设置最好*/
@property (nonatomic,strong) ym_setupFrame setupFrameBlock ;

/** 存放手势激活块的数组*/
@property (nonatomic,strong) NSMutableDictionary *ym_gesturesDict;



@end
@implementation YMBaseCellsubView

#pragma -mark 懒加载
-(NSMutableDictionary *)ym_gesturesDict{
    
    if(_ym_gesturesDict==nil){
        _ym_gesturesDict = [NSMutableDictionary dictionary];
    }
    return _ym_gesturesDict;
}


-(NSMutableDictionary *)identifierDict{
    if(_identifierDict==nil){
        
        _identifierDict = [NSMutableDictionary dictionary];
    }
    return _identifierDict;
}

#pragma -mark 属性


/** 动态添加view*/
-(id)ym_addSubviewWithClass:(Class)objectClass identifier:(NSString *)identifier initializeView:(void (^)(UIView *))view{
    

    if([[self.identifierDict allKeys]containsObject:identifier]){
        return [self.identifierDict valueForKey:identifier];
    }
    id object = [[objectClass alloc]init];
    view(object);
    [self addSubview:object];
    [self.identifierDict setValue:object forKey:identifier];
    
    return object;
}

-(id)ym_addSubViewWithClass:(Class) objectClass
                 identifier:(NSString *) identifier
             initializeView:(void(^)(UIView *view)) view
                   isCreate:(BOOL) isCreate{

    if([[self.identifierDict allKeys]containsObject:identifier]){
        return [self.identifierDict valueForKey:identifier];
    }
    if(isCreate==NO)
        return nil;
    id object = [[objectClass alloc]init];
    [self addSubview:object];
    [self.identifierDict setValue:object forKey:identifier];
    view(object);
    return object;
}



-(id)ym_dequeueReusableViewWithidentifier:(NSString *)identifier{
    
    if([[self.identifierDict allKeys]containsObject:identifier]){
        return [self.identifierDict valueForKey:identifier];
    }
    return nil;
}

-(void)ym_addSubViewWithView:(UIView *)view identifier:(NSString *)identifier
{
    
      [self addSubview:view];
      [self.identifierDict setValue:view forKey:identifier];
      return;
}


-(void)ym_addGestureRecognizerTypeWithClass:(Class)gestureClass targetView:(UIView *)targetView activeBlock:(void(^)(UIView *view))active{
    
    //判断是否已经添加过相同手势
    for (UIGestureRecognizer *gesture in targetView.gestureRecognizers) {
        
        if( [gesture isKindOfClass:gestureClass]){
            return;
        }
    }
    
    UIGestureRecognizer *gesture = [[gestureClass alloc]init];
    [gesture addTarget:self action:@selector(gestureActive:)];
    
    [targetView addGestureRecognizer:gesture];
    targetView.userInteractionEnabled = YES;
    

    [self.ym_gesturesDict setValue:active forKey:[NSString stringWithFormat:@"%p",gesture]];
    
}
-(void)gestureActive:(UIGestureRecognizer *)gesture{
    
    //根据对应的view取出对应的激活块
    NSString *str = [NSString stringWithFormat:@"%p",gesture];
    
    ym_gestureActive avtive = self.ym_gesturesDict[str];
    
    avtive(gesture.view);

}


-(void)ym_startDraw{
    
}

#pragma -mark 动态计算自身frame

-(BOOL)ym_clearHideViewFrame:(NSMutableArray *)originalFrame{
    BOOL isViewHide = NO;
    for(UIView *view in self.subviews){
        if(view.hidden == YES)
        {
            NSValue *value = nil;
            value = [NSValue valueWithCGRect:view.frame];
            isViewHide = YES;
            [originalFrame addObject:value];
            view.frame = CGRectZero;
            
        }
    }
    return isViewHide;
}
-(void)ym_recoverHideViewFrame:(NSMutableArray *)originalFrame{
    
    if(originalFrame.count>0)
    {
        int n=0;
        for(UIView *view in self.subviews){
            if(view.hidden == YES){
                NSValue *value = originalFrame[n++];
                view.frame = value.CGRectValue;
            }
        }
    }
}
-(CGFloat)ym_CountMaxBottom{
    
    CGFloat maxBottom = 0;
   
    for (UIView* view in self.subviews) {
        
        CGFloat viewBottom = CGRectGetMaxY(view.frame);
        if( maxBottom <  viewBottom)
            maxBottom = viewBottom;
    }
    
    return maxBottom;
    
}
-(CGFloat)ym_GetSelfViewHeight{
    
    CGFloat maxBottom = 0;
    
    if(self.subviews.count == 0) return 0;
    
    NSMutableArray *originalFrame=  [NSMutableArray array];
    if([self ym_clearHideViewFrame:originalFrame])
    {
        self.ym_height = 0;
        if(self.setupFrameBlock){
            self.setupFrameBlock(self);
        }
        //计算当前view的最大高度
        maxBottom = [self ym_CountMaxBottom];
        //重新设置隐藏view的尺寸
        for (UIView* view in self.subviews) {
            if(view.hidden == YES)
            {
                view.ym_y = maxBottom;
            }
        }
        //防止view绑定超过self高度 
        self.ym_height = maxBottom;

    }
    //在重新绑定尺寸
    if(self.setupFrameBlock){
        self.setupFrameBlock();
    }
    //在求出真正的高度
    maxBottom = [self ym_CountMaxBottom];
    
    //还原隐藏的view的frame
    [self ym_recoverHideViewFrame:originalFrame];
    
    return maxBottom;
}

#pragma -mark 设置属性
-(void)ym_setupFrame:(ym_setupFrame)setupFrame{
    
    self.setupFrameBlock = setupFrame;
}

-(void)ym_setupAttribute:(ym_setAttributeBlock)setBlock{

    if(self.isRunSetAttribute == NO){
        setBlock();
        self.isRunSetAttribute = YES;
    }
}




#pragma -mark 重写

-(void)didMoveToSuperview{
    
    if(self.frame.size.width==0){
        self.ym_width = self.superview.bounds.size.width-self.ym_margin*2;
    }
    self.ym_margin = 10;
    
}

-(instancetype)initWithFrame:(CGRect)frame{

    if(self = [super initWithFrame:frame]){
        self.isUserNormalLayout = YES;
    
    }
    return self;
}

-(void)setYm_margin:(NSInteger)ym_margin{
    
    if(_ym_margin == ym_margin)return;
    
    // margin改变时候 修改宽度 先恢复原来的宽度在减去改变的margin
    //当自己设置坐标宽度时候 不会加入margin
    //保存之前的大小
    NSInteger last = _ym_margin;
    
    //赋值
    _ym_margin = ym_margin;
    if(self.ym_width ==  self.superview.frame.size.width-last*2){
        self.ym_width -= ym_margin*2-last*2;
    }
    if(self.frame.origin.x == 0 ||self.frame.origin.x == last){
       self.ym_x += ym_margin-last;
    }
    if(self.ym_y ==0 ||self.ym_y == last){
        self.ym_y += ym_margin-last;
    }

}

@end
