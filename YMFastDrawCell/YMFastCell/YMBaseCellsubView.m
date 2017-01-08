//
//  YMBaseCellsubView.m
//  YMCell封装测试
//
//  Created by 夜幕 on 16/12/3.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import "YMBaseCellsubView.h"
#import "UIView+YMFrameExtension.h"
#import <objc/runtime.h>
@interface YMBaseCellsubView()


@property (nonatomic,strong) ym_setupFrame setupFrameBlock ;

/** 存放手势激活块的字典*/
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



#pragma -mark 属性

/** 动态添加view*/
-(id)ym_addSubviewWithClass:(Class)objectClass identifier:(NSString *)identifier initializeView:(void (^)(UIView *))view{
    
    return [self ym_addSubViewWithClass:objectClass identifier:identifier initializeView:view isCreate:YES];

}

-(id)ym_addSubViewWithClass:(Class) objectClass
                 identifier:(NSString *) identifier
             initializeView:(void(^)(UIView *view)) view
                   isCreate:(BOOL) isCreate{
    
    id obj = objc_getAssociatedObject(self,(__bridge const void *)(identifier));
    
    if(!obj && isCreate == YES){
        obj = [[objectClass alloc]init];
        [self addSubview:obj];
        view(obj);
        objc_setAssociatedObject(self, (__bridge const void *)(identifier), obj,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }

    return obj;
}

-(id)ym_addSubviewWithClass:(Class)objectClass
                 identifier:(NSString *)identifier
             initializeView:(void (^)(UIView *))view
                 tapGesture:(void (^)(UIView *))activate{
    
   UIView *object =  [self ym_addSubViewWithClass:objectClass identifier:identifier initializeView:view isCreate:YES];
 
   [self ym_addGestureRecognizerTypeWithClass:[UITapGestureRecognizer class] targetView:object activeBlock:activate];
   
    return object;
}

-(void)ym_addGestureRecognizerTypeWithClass:(Class)gestureClass targetView:(UIView *)targetView activeBlock:(void(^)(UIView *view))activate{
    
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

    [self.ym_gesturesDict setValue:activate forKey:[NSString stringWithFormat:@"%p",gesture]];
    
}
-(void)gestureActive:(UIGestureRecognizer *)gesture{
    
    //根据对应的view取出对应的激活块
    NSString *str = [NSString stringWithFormat:@"%p",gesture];
    
    ym_gestureActive avtive = self.ym_gesturesDict[str];
    
    avtive(gesture.view);

}

-(void)ym_startDraw{
    [self ym_calculationSelfViewHeight];
}


#pragma -mark 动态计算自身frame
-(void)ym_clearHideViewFrame:(NSMutableArray *)originalFrame{
 
    for(UIView *view in self.subviews){
        if(view.hidden == YES)
        {
            //获取绑定这个view 的views
            CGFloat bottom = view.ym_bottom;
            NSArray *views = [self ym_getViewsWithTargetView:view];
            CGFloat lowButtom = 0;
            if(views.count>0){
                //y坐标设定为 比这个还高位的view的 bottom
                lowButtom = [self nearButtomWithButtom:bottom views:views];
            }
            //存储原来的frame
            NSValue *value = nil;
            value = [NSValue valueWithCGRect:view.frame];
            [originalFrame addObject:value];
            view.frame = CGRectMake(0, lowButtom,0,0);
        }
    }
    return;
}
//获取依赖targetView的frame 的view数组
-(NSArray *)ym_getViewsWithTargetView:(UIView *)targetView{

    if(!self.setupFrameBlock)
        return nil;
    
    //获取所有view的origin
    NSMutableArray *arrM = [NSMutableArray array];
    //保存原来的所有origin 坐标
    for (UIView *_view in self.subviews) {
        if(targetView == _view||_view.hidden) continue;
        NSValue *value = nil;
        value = [NSValue valueWithCGPoint:_view.frame.origin];
        [arrM addObject:value];
    }
    
    //执行修改frameBlock 判断是否依赖于这个view
    targetView.frame = CGRectMake(-0.123, -0.123, 0, 0);
    self.setupFrameBlock();
    
    int i=0;
    NSMutableArray *views = [NSMutableArray array];
    //对比原来的坐标 发生坐标改变 代表依赖于这个view
    for (UIView *_view in self.subviews) {
        
        if(targetView == _view ||_view.hidden) continue;
        NSValue *value = arrM[i++];
        CGPoint point = value.CGPointValue;
        if(!CGPointEqualToPoint(point,_view.frame.origin)){
            [views addObject:_view];
        }
    }
    return views;
}
//获取离Y值最近的一个view的buttom;
-(CGFloat)nearButtomWithButtom:(CGFloat)buttom views:(NSArray *)views{
    
    CGFloat lowButtom = 0;//最低的y值
    CGFloat dValue = MAXFLOAT;//差值

    for (int i=0; i<self.subviews.count; i++) {
        UIView *view = self.subviews[i];
        if(view.hidden)continue;
        
        BOOL isView = false;
        //判断这个view 是否依赖于这个view
        for (UIView *v in views) {
            if(v==view){
                isView = true;
                break;
            }
        }
        if(view.ym_y >buttom||isView) continue;
        
        if(dValue >= buttom-view.ym_bottom){
             dValue = buttom - view.ym_bottom;
            if(lowButtom < view.ym_bottom)
                lowButtom = view.ym_bottom;
        }
    }
    return lowButtom;
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
-(void)ym_calculationSelfViewHeight{
    
    CGFloat maxBottom = 0;
    self.ym_height = 0;
    
    if(self.subviews.count == 0) return;
    
    NSMutableArray *originalFrame=  [NSMutableArray array];
    
    
    [self ym_clearHideViewFrame:originalFrame];

    if(self.setupFrameBlock){
        self.setupFrameBlock();
    }
    
    //在求出真正的高度
    maxBottom = [self ym_CountMaxBottom];
    //还原隐藏的view的frame
    [self ym_recoverHideViewFrame:originalFrame];
    
    self.ym_height = maxBottom;
    if(self.isUserNormalLayout){
        self.ym_height += self.ym_margin;
    }
    return;
}

#pragma -mark 设置属性
-(void)ym_setupFrame:(ym_setupFrame)setupFrame{
    
    if(!self.setupFrameBlock)
        self.setupFrameBlock = setupFrame;
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
