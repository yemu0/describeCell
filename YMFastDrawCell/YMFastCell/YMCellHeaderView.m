//
//  YMCellHeaderView.m
//  YMCell封装测试
//
//  Created by 夜幕 on 16/12/2.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import "YMCellHeaderView.h"
#import "UIView+YMFrameExtension.h"
@interface YMCellHeaderView()


@property (nonatomic,assign)BOOL isLoadImageView;

@property (nonatomic,assign)BOOL isLoadTitleLabel;

@property (nonatomic,assign)BOOL isLoadSubLabel;

@end

@implementation YMCellHeaderView


-(BOOL)isCanCreate{
    
    /**使用manager调整时候 取消原本的属性的创建加载*/
    
    return NO;
}
#pragma -mark 懒加载
-(UILabel *)ym_titleLabel{
    
   
    
    if(_ym_titleLabel==nil){
        
        if([self isCanCreate])
            return nil;
        
        _isLoadTitleLabel = YES;
        //添加标题子label
        UILabel *label;
        if(_isLoadImageView==NO){
            label = [[UILabel alloc]init];
        }else{
            label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.ym_imageView.frame),_ym_imageView.ym_y, 0, 0)];
        }
        label.ym_height = label.font.pointSize;
    
        _ym_titleLabel=label;
        [self addSubview:label];
        
    }
    return _ym_titleLabel;
}
-(UILabel *)ym_subLabel{
    _isLoadSubLabel = YES;
    if(_ym_subLabel==nil){
        //添加标题子label
        UILabel *label = [[UILabel alloc]init];
        label.numberOfLines = 0;
        _ym_subLabel=label;
        label.ym_x = self.ym_titleLabel.ym_x;
        label.ym_y = self.ym_titleLabel.ym_bottom+5;
        [label setTextColor:[UIColor grayColor]];
        [self addSubview:label];
        
    }
    return _ym_subLabel;
    
}

-(UIImageView *)ym_imageView{
    
    _isLoadImageView = YES;
    
    if(_ym_imageView==nil){
        //添加标题子label
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        _ym_imageView=imageV;
        imageV.clipsToBounds = YES;
        [self addSubview:imageV];
    }
    return _ym_imageView;
}


#pragma -mark 重写

-(CGRect)frame{
    
    CGRect frame = [super frame];

    //view尺寸改变时候进入 外部自定义subLabelMaxSize宽高的时候不进入
    if(_isLoadSubLabel) {
        if(_ym_subLabelMaxSize.width!=(frame.size.width-self.ym_subLabel.ym_x)&&_ym_subLabelMaxSize.height==MAXFLOAT-998.12)
            self.ym_subLabelMaxSize = CGSizeMake(frame.size.width-self.ym_subLabel.ym_x, MAXFLOAT-998.12);
    }
    return frame;
}

-(CGSize)ym_subLabelMaxSize{
    if(_ym_subLabelMaxSize.width==0)
        _ym_subLabelMaxSize = CGSizeMake(self.frame.size.width-self.ym_subLabel.ym_x, MAXFLOAT-998.12);
    
    return _ym_subLabelMaxSize;
}


-(void)ym_startDraw{
    [super ym_startDraw];
    
    if(_isLoadTitleLabel){
        [self.ym_titleLabel sizeToFit];
        
        if(self.isUserNormalLayout)
            if(_isLoadImageView)
                self.ym_titleLabel.ym_x = self.ym_imageView.ym_width+self.ym_imageView.ym_x +self.ym_margin;
    }
    if(_isLoadSubLabel){
        
        if(self.isUserNormalLayout)
        {
            self.ym_subLabel.ym_y = self.ym_titleLabel.ym_bottom + self.ym_margin;
            self.ym_subLabel.ym_x = self.ym_titleLabel.ym_x;
        }
        CGSize expectSize = [self.ym_subLabel sizeThatFits:self.ym_subLabelMaxSize];
        self.ym_subLabel.ym_width = expectSize.width;
        self.ym_subLabel.ym_height = expectSize.height;
        
    }
  
    //根据内容设置自身的frame
    self.ym_height = [self ym_GetSelfViewHeight];

}




-(void)dealloc{
    NSLog(@"headerView dealloc");
}
@end
