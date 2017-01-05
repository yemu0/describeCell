//
//  YMCellCenterView.m
//  YMCell封装测试
//
//  Created by 夜幕 on 16/12/2.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import "YMCellCenterView.h"
#import "UIView+YMFrameExtension.h"
#import "YMSuduko.h"
#import "YMLabel.h"
@interface YMCellCenterView ()

@property (nonatomic,assign)BOOL isLoadImageView;

@property (nonatomic,assign)BOOL isLoadcontentLable;

@property (nonatomic,assign)BOOL isLoadSudukoView;

@property (nonatomic,assign)BOOL isSetupContentLabelMax;

@property (nonatomic,copy) sudukoView sudukoViewBlock;

@property (nonatomic,strong)YMSuduko *lastSuduko;

@property (nonatomic,strong) YMSuduko *sudukoData;

@property (nonatomic,copy) NSArray *(^modelsBlock)(UIView *);


@end


@implementation YMCellCenterView


#pragma -mark 懒加载==============
-(UIView *)sudukoView{
    
   
    if(_sudukoView==nil){
         _isLoadSudukoView = YES;
        UIView *view = [[UIView alloc]init];
        view.clipsToBounds = YES;
        [self addSubview:view];
        _sudukoView = view;
    }
    return _sudukoView;
}
-(YMSuduko *)lastSuduko{
    
    if(_lastSuduko==nil){
        _lastSuduko = [[YMSuduko alloc]init];
    }
    return _lastSuduko;
}
-(YMSuduko *)sudukoData{
    
    if(_sudukoData==nil){
        _sudukoData = [[YMSuduko alloc]init];
    }
    return _sudukoData;
    
}

-(UIImageView *)ym_imageView{
    
    
    if(_ym_imageView ==nil){
        _isLoadImageView = YES;
        UIImageView *imageV = [[UIImageView alloc]init];
        imageV.clipsToBounds = YES;
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        _ym_imageView = imageV;
        [self addSubview:imageV];
    }
    return _ym_imageView;
    
}

-(YMLabel *)ym_contentLable{
    
    
    if(_ym_contentLable ==nil){
        _isLoadcontentLable = YES;
        YMLabel *content = [[YMLabel alloc]init];
        content.numberOfLines = 0;
        _ym_contentLable = content;
        [self addSubview:content];

    }
    return _ym_contentLable;

}
#pragma -mark 重写

-(void)dealloc{
    
    NSLog(@"centerView dealloc");
}

-(CGSize)ym_maxImageSize{
    
    if(_ym_maxImageSize.height==0)
        return CGSizeMake(self.frame.size.width, [UIScreen mainScreen].bounds.size.height-self.ym_margin*2);
    
    return _ym_maxImageSize;

}
-(void)ym_judgmentLessMiniSize{
    
    //判断最小
    if(self.ym_miniImageSize.width>0||self.ym_miniImageSize.height>0){
        //判断图片是否小于最大宽度
        if(self.ym_imageSize.width < _ym_miniImageSize.width){
            self.ym_imageView.ym_width = _ym_miniImageSize.width;
            //计算图片高度
            if(_ym_imageSize.height!=0 && _ym_imageSize.width!=0)
                self.ym_imageView.ym_height = _ym_imageSize.height/_ym_imageSize.width *self.ym_imageView.ym_width;
        }

        if(_ym_imageSize.height <self.ym_miniImageSize.height){
            self.ym_imageView.ym_height = self.ym_miniImageSize.height;
        }
    }
   
}
-(void)ym_judgmentOverstepMaxSize{
    
    //判断图片是否超出最大宽度
    if(_ym_imageSize.width >self.ym_maxImageSize.width){
        self.ym_imageView.ym_width = self.ym_maxImageSize.width;
        //图片超出最大宽度 重新计算高度
        if(_ym_imageSize.height!=0 && _ym_imageSize.width!=0)
            self.ym_imageView.ym_height = _ym_imageSize.height/_ym_imageSize.width *self.ym_imageView.ym_width;
    }
    //判断图片是否超出最大高度
    if(_ym_imageSize.height >self.ym_maxImageSize.height)
        self.ym_imageView.ym_height = self.ym_maxImageSize.height;

}
-(void)setYm_imageSize:(CGSize)ym_imageSize{
    _ym_imageSize = ym_imageSize;
  
    self.ym_imageView.ym_width = _ym_imageSize.width;
    self.ym_imageView.ym_height = _ym_imageSize.height;
    //判断最小
    [self ym_judgmentLessMiniSize];
    //判断最大
    [self ym_judgmentOverstepMaxSize];
   
}

#pragma mark 设置自带控件

-(void)ym_setupImageView{
    
    //没有设置view 或者图片改变
    if((self.ym_imageSize.height ==0 &&self.ym_imageSize.width==0)){
        [self.ym_imageView sizeToFit];
        //判断图片是否超出view大小
        if(self.ym_imageView.ym_width >self.ym_width)
            self.ym_imageView.ym_width = self.ym_width;
    }

}

-(void)ym_leftLabelType{
    if(!_isLoadcontentLable){
        return;
    }
    self.ym_contentLable.ym_x = self.ym_margin;
    
    if(_isLoadImageView){
        self.ym_imageView.ym_y = self.ym_contentLable.ym_y;
        self.ym_imageView.ym_x = CGRectGetMaxX(self.ym_contentLable.frame)+self.ym_margin;
        return;
    }
    if(_isLoadSudukoView){
        self.sudukoView.ym_y = self.ym_contentLable.ym_y;
        self.sudukoView.ym_x = CGRectGetMaxX(self.ym_contentLable.frame)+self.ym_margin;
    }
    return;
}
-(void)ym_rightLabelType{
    if(!_isLoadcontentLable){
        return;
    }
    if(_isLoadImageView){
        self.ym_imageView.ym_y = 0;
        self.ym_contentLable.ym_x = CGRectGetMaxX(self.ym_imageView.frame)+self.ym_margin;
        return;
    }
    if(_isLoadSudukoView){
        self.sudukoView.ym_y = 0;
        self.ym_contentLable.ym_x = CGRectGetMaxX(self.sudukoView.frame)+self.ym_margin;
    }
    return;
}
-(void)ym_buttomLabelType{
    if(!_isLoadcontentLable)
        return;
    if(_isLoadImageView){
        self.ym_imageView.ym_y = self.ym_margin;
        self.ym_contentLable.ym_y = CGRectGetMaxY(self.ym_imageView.frame)+self.ym_margin;
        return;
    }
    if(_isLoadSudukoView){
        self.sudukoView.ym_y = self.ym_margin;
        self.ym_contentLable.ym_y = CGRectGetMaxY(self.sudukoView.frame)+self.ym_margin;
    }
    return;
}
-(void)ym_topLabelType{
    
    if(!_isLoadcontentLable)
        return;
    if(_isLoadImageView){
        self.ym_imageView.ym_y = CGRectGetMaxY(self.ym_contentLable.frame)+self.ym_margin;
        return;
    }
    if(_isLoadSudukoView)
        self.sudukoView.ym_y = CGRectGetMaxY(self.ym_contentLable.frame)+self.ym_margin;
    
    return;
}

-(void)ym_startDraw{
    [super ym_startDraw];
    
    if(_isLoadcontentLable){
        self.ym_contentLable.ym_width = self.ym_width;
        [self.ym_contentLable ym_countSize];
    }
    if(_isLoadImageView){
        [self ym_setupImageView];
    }
    
    if(_isLoadSudukoView){
        self.sudukoView.ym_y = self.ym_contentLable.ym_bottom;
        [self ym_setupSudukoSubviews];
    }
    
    switch (self.ym_describeType) {
        case YMDescribeTypeLabelLeft:
            [self ym_leftLabelType];
            break;
        case YMDescribeTypeLabelRight:
            [self ym_rightLabelType];
            break;
        case YMDescribeTypeLabelButtom:
            [self ym_buttomLabelType];
            break;
        case YMDescribeTypeLabelTop:
            [self ym_topLabelType];
            break;
        case YMDescribeTypeLabelNone:
            break;
        default:
            break;
    }
    //根据子控件获取自身大小
    self.ym_height = [self ym_GetSelfViewHeight];
    if(self.isUserNormalLayout){
        self.ym_height += self.ym_margin;
    }
 
}


#pragma -mark 九宫格布局

//计算sudukoView的大小
-(void)ym_countSudukoViewSize{
    
    if(self.sudukoData.number<self.sudukoData.column){
        self.sudukoView.ym_width = CGRectGetMaxX(self.sudukoView.subviews[self.sudukoData.number-1].frame);
    }else if (self.sudukoData.viewWidth==self.ym_width){
        self.sudukoView.ym_width = self.ym_width;
    }

    self.sudukoView.ym_height = self.sudukoView.subviews[self.sudukoData.number-1].ym_bottom;
   
}
//返回值代表是否跳过设置subview frame
-(void)ym_countSudukoSubviewsFrame{
    
    //当数量只有一个时候 随着子控件大小而定
    if(self.sudukoData.number==1){
            UIView *v = self.sudukoView.subviews.firstObject;
            v.ym_width = self.sudukoData.subviewSize.width;
            v.ym_height = self.sudukoData.subviewSize.height;
            self.sudukoViewBlock(v,self.sudukoView,0);
            [self ym_countSudukoViewSize];
            return;
    }
    
    CGFloat margin=  self.sudukoData.viewMargin;
    NSInteger column =  self.sudukoData.column;
    CGFloat btn_W = self.sudukoData.subviewSize.width;
    CGFloat btn_H = self.sudukoData.subviewSize.height;
    CGFloat btn_X = 0;
    CGFloat btn_Y = 0;

    for(NSInteger i=0;i<self.sudukoData.number;i++){

        UIView *view = self.sudukoView.subviews[i];
        if(view.hidden)
            continue;
        btn_X = (i%column*btn_W)+(i%column*margin);
        btn_Y = (i/column*btn_H)+ (i/column*margin);
        view.frame = CGRectMake(btn_X, btn_Y, btn_W, btn_H);
        self.sudukoViewBlock(view,self.sudukoView,i);
    }
    
    [self ym_countSudukoViewSize];

}
//SudukoSubviews设置
-(void)ym_setupSudukoSubviews{
  
    if(!self.sudukoViewBlock)return;
    
    if(self.sudukoView.hidden) return;
    
    //没有改变属性,只要直接传递subView 不需要重新计算高宽
    if(![self isChangeSudukoSubviewSize:self.lastSuduko]){
        NSInteger i=0;
        for (UIView *view in self.sudukoView.subviews) {
            if(view.hidden == YES)
                continue;
            self.sudukoViewBlock(view,self.sudukoView,i);
            i++;
        }
        [self ym_countSudukoViewSize];
        return;
    }
    //计算尺寸
    [self ym_countSudukoSubviewsFrame];
}
-(BOOL)isChangeSudukoSubviewSize:(YMSuduko *)lastSuduko{
    
    if(lastSuduko.column != self.sudukoData.column)
        return YES;
    
    if(self.sudukoView.subviews[self.sudukoData.number-1].ym_height==0)
        return YES;
    
    if(!CGSizeEqualToSize(lastSuduko.subviewSize, self.sudukoData.subviewSize))
        return YES;
    
    return NO;
}
//九宫格布局
-(void)ym_addSudokuLayoutWithClass:(Class)viewClass
                      setupSuduko:(void (^)(YMSuduko *))sudoku
                    setupSubviews:(sudukoView)subView
{
    
    if(subView)
        self.sudukoViewBlock = subView;

    //获取上一个的设置
    [self.lastSuduko sudukoWithSuduko:self.sudukoData];
    
    sudoku(self.sudukoData);
    
    //数量为0时候自动隐藏
    if(self.sudukoData.number==0){
        self.sudukoView.hidden = YES;
    }
    //数字相等
    if(self.lastSuduko.number==self.sudukoData.number){
        return;
    }
    
    if(self.sudukoData.number>0&&self.sudukoView.hidden==YES){
        self.sudukoView.hidden = NO;
    }
    if(self.sudukoData.viewWidth==0)
        self.sudukoData.viewWidth = self.ym_width;
    //九宫格数字变小 吧其他的隐藏
    if(self.sudukoData.number<self.lastSuduko.number){

        for (NSInteger i=self.sudukoData.number; i<self.lastSuduko.number;i++) {
            UIView *view = self.sudukoView.subviews[i];
            view.hidden = YES;
  
        }
            return;
    }
   
    //数字变大 创建view
    for(NSInteger i=self.lastSuduko.number;i<self.sudukoData.number;i++){
        UIView *view;
        if(i>=self.sudukoView.subviews.count){
            view = [[viewClass alloc]init];
            [self.sudukoView addSubview:view];
        }
        view = self.sudukoView.subviews[i];
        view.hidden = NO;
    }
}


#pragma 九宫格激活相关
-(void)ym_sudukoActiveHaveModels:(void (^)(UIView *, NSInteger,NSArray *))active{
    
    UIView *subview = self.sudukoView.subviews.lastObject;
    
    for (UIGestureRecognizer *ges in subview.gestureRecognizers) {
        if([ges isKindOfClass:[UITapGestureRecognizer class]])
            return ;
    }
    __weak typeof(self) weakself = self;
    
    for (UIView *sudukoSubview in self.sudukoView.subviews) {
        
        [self ym_addGestureRecognizerTypeWithClass:[UITapGestureRecognizer class]
                                        targetView:sudukoSubview activeBlock:^(UIView *view)
        {
            NSArray *models = nil;
            if(weakself.modelsBlock)
                models = weakself.modelsBlock(view);
            active(view,[weakself ym_getSudukoIndexWithView:view],models);
        }];
    };
    return ;
}

-(void)ym_sudukoActiveModels:(NSArray *(^)(UIView *))models{
    
    if(!self.modelsBlock)
        self.modelsBlock = models;
}

-(NSInteger)ym_getSudukoIndexWithView:(UIView *)view{
    
    int n=0;
    
    for (UIView *subview in self.sudukoView.subviews) {
        if(subview == view)
            break;
        n++;
    }
    return n;
}
@end
