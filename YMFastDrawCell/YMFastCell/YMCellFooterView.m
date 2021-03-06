//
//  YMCellFooterView.m
//  YMFastDrawCell
//
//  Created by 夜幕 on 16/12/18.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import "YMCellFooterView.h"
#import "UIView+YMFrameExtension.h"
#import "YMLabel.h"
@interface YMCellFooterView()

@property (nonatomic,strong) void(^btnClick)(UIButton *btn) ;

@end

@implementation YMCellFooterView

#pragma mark 懒加载
-(UIView *)toolsView{
    if(_toolsView ==nil){
        UIView *view = [[UIView alloc]init];
        _toolsView = view;
        [self addSubview:view];
    }
    
    return _toolsView;
}
-(UIView *)commentsView{
    
    if(_commentsView ==nil){
        UIView *view = [[UIView alloc]init];
        _commentsView = view;
        _commentsView.ym_width = self.ym_width;
        _commentsView.backgroundColor = [UIColor colorWithRed:(241)/255.0 green:(241)/255.0 blue:(241)/255.0 alpha:(1)];
        [self addSubview:view];
    }
    return _commentsView;
}
#pragma mark 重写
-(void)dealloc{
    NSLog(@"footerView dealloc");
    
}
-(void)ym_startDraw{
    
    
    if(_commentsView){
        if(_toolsView)
            self.commentsView.ym_y = self.toolsView.ym_bottom + self.ym_margin;
    }
 
    //设置自身宽高
    [super ym_startDraw];
}
#pragma -mark 工具条
-(void)ym_addToolsViewWithClass:(Class)viewClass
                         Number:(NSInteger)number
                         margin:(NSInteger)margin
                 toolViewHeight:(CGFloat)toolViewHeight
                  setupSubviews:(void(^)(id view,UIView *toolsView)) viewBlock{
    
    
    if(self.toolsView.subviews.count ==number){
        return;
    }
    self.toolsView.ym_height = toolViewHeight;
    self.toolsView.ym_width = self.ym_width;
    
    CGFloat btnX = 0;
    CGFloat btnW = (self.toolsView.ym_width - (number-1)*margin)/number;
    NSInteger i = self.toolsView.subviews.count;
    for(;i<number;i++){
        btnX = i*btnW+i*margin;
        UIButton *btn = [[viewClass alloc]initWithFrame:CGRectMake(btnX, 0, btnW, toolViewHeight)];
        [self.toolsView addSubview:btn];
        viewBlock(btn,self.toolsView);
    }
 
}

-(void)ym_addToolsViewWithNumber:(NSInteger)number
                          margin:(NSInteger)margin
                  toolViewHeight:(CGFloat)toolViewHeight
                   setupSubviews:(void (^)(UIButton *, UIView *))btnBlock{
    
    [self ym_addToolsViewWithClass:[UIButton class] Number:number margin:margin toolViewHeight:toolViewHeight setupSubviews:btnBlock];
}


-(void)ym_toolsSubviewsClick:(void (^)(UIButton *))btnClick{

    if(btnClick)
        self.btnClick = btnClick;
    
    UIButton *button = self.toolsView.subviews.lastObject;
    
    if([button actionsForTarget:self forControlEvent:UIControlEventTouchUpInside].count >0)
        return;
    
    for (UIButton *btn in self.toolsView.subviews) {
        NSArray *arr = [btn actionsForTarget:self forControlEvent:UIControlEventTouchUpInside];
        if(arr.count>0)
            continue;
        [btn addTarget:self action:@selector(btnActive:) forControlEvents:UIControlEventTouchUpInside];
    }

}
-(void)btnActive:(UIButton *)btn{
    if(self.btnClick)
        self.btnClick(btn);
}

#pragma -mark 评论view
-(void)ym_addCommentViewWithNumber:(NSInteger)number
                      setupComment:(commentBlock)comment{
    
    NSInteger count = self.commentsView.subviews.count;
    //少于创建 显示
    for (NSInteger i=0; i<number; i++) {
        YMLabel *view;
        if(count<=i){
            view = [[YMLabel alloc]init];
            [self.commentsView addSubview:view];
        }
        view = self.commentsView.subviews[i];
        view.hidden = NO;
    }
    //多余隐藏
    if(count>number){
        for (NSInteger i=number; i<count; i++) {
            YMLabel *view = self.commentsView.subviews[i];
            view.hidden = YES;
        }
    }
 
    //执行block
    NSInteger index = 0;
    //计算评论view的大小
    self.commentsView.ym_height = 0;
    
    for (YMLabel *commentView in self.commentsView.subviews) {
        
        if(commentView.hidden == YES)
            continue;
        comment(commentView,index);
        commentView.ym_y = self.commentsView.ym_height;
        commentView.ym_width = self.commentsView.ym_width;

        [commentView ym_countSize];
        self.commentsView.ym_height += commentView.ym_height;
        index++;
    }
   
}

@end


