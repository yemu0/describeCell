//
//  YMCellHeaderView.m
//  YMCell封装测试
//
//  Created by 夜幕 on 16/12/2.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import "YMCellHeaderView.h"
#import "UIView+YMFrameExtension.h"
#import "YMLabel.h"
@interface YMCellHeaderView()

@end

@implementation YMCellHeaderView



#pragma -mark 懒加载
-(UILabel *)ym_titleLabel{
    
    if(_ym_titleLabel==nil){
        //添加标题子label
        UILabel *label = [[UILabel alloc]init];
        label.ym_height = label.font.pointSize;
    
        _ym_titleLabel=label;
        [self addSubview:label];
        
    }
    return _ym_titleLabel;
}
-(YMLabel *)ym_subLabel{

    if(_ym_subLabel==nil){
        //添加标题子label
        YMLabel *label = [[YMLabel alloc]init];
        label.numberOfLines = 0;
        _ym_subLabel=label;
        label.ym_y = self.ym_titleLabel.ym_bottom+5;
        label.font = [UIFont systemFontOfSize:self.ym_titleLabel.font.pointSize-1];
        [label setTextColor:[UIColor grayColor]];
        [self addSubview:label];
        
    }
    return _ym_subLabel;
    
}

-(UIImageView *)ym_imageView{
    
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

-(void)ym_startDraw{
    
    
    if(_ym_titleLabel){
        [self.ym_titleLabel sizeToFit];
        
        if(self.isUserNormalLayout)
            if(_ym_imageView)
                self.ym_titleLabel.ym_x = self.ym_imageView.ym_width+self.ym_imageView.ym_x +self.ym_margin;
    }
    if(_ym_subLabel){
        
        if(self.isUserNormalLayout)
        {
            self.ym_subLabel.ym_x = self.ym_titleLabel.ym_x;

        }
        self.ym_subLabel.ym_width = self.ym_width;
        [self.ym_subLabel ym_countSize];
    }
    
    [super ym_startDraw];
}




-(void)dealloc{
    NSLog(@"headerView dealloc");
}
@end
