//
//  YMCollectionViewCell.m
//  YMFastDrawCell
//
//  Created by 夜幕 on 16/12/20.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import "YMPictureCell.h"

@interface YMPictureCell()

@property (nonatomic,weak) UIScrollView *scrollV;

@property (nonatomic,weak) UIImageView *showImageV;
@end

@implementation YMPictureCell

-(UIImageView *)showImageV{
    
    if(_showImageV==nil){
        UIImageView *imageV = [[UIImageView alloc]init];
        
        [self.scrollV addSubview:imageV];
        _showImageV = imageV;
        
    }
    return _showImageV;
}

-(UIScrollView *)scrollV{
    if (_scrollV==nil) {
        UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [self addSubview:sv];
        _scrollV.maximumZoomScale = 2.0;
        _scrollV = sv;
    }
    
    return _scrollV;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    
    return [super initWithFrame:frame];

}

-(void)setShowImage:(NSString *)showImage{
    
    _showImage = showImage;
    self.showImageV.image = [UIImage imageNamed:showImage];
    [self.showImageV sizeToFit];
    
    if(self.showImageV.image.size.height<self.scrollV.ym_height){
        
        self.showImageV.ym_centerX = self.scrollV.ym_width *0.5;
        self.showImageV.ym_centerY = self.scrollV.ym_height *0.5;
    }
   
}
@end
