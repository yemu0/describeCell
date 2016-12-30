//
//  YMPictureView.m
//  YMFastDrawCell
//
//  Created by 夜幕 on 16/12/20.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import "YMPictureView.h"
#import "YMPictureCell.h"
@interface YMPictureView ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic,weak) UICollectionView *collectView;

@property (nonatomic,weak) UIImageView *animImageView;

@end


@implementation YMPictureView
#pragma mark 初始化

-(UIImageView *)animImageView{
    
    if(_animImageView==nil){
        UIImageView *imgV = [[UIImageView alloc]init];
        _animImageView = imgV;
        [self addSubview:_animImageView];
    }
    return _animImageView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if(self = [super initWithFrame:frame]){
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click)];
        [self addGestureRecognizer:tap];
     
    }
    return self;
}
-(void)click{
    
//    self.animImageView.frame = self.selectImageFrame;
    
    //如果下标不变的话
    
    self.collectView.hidden = YES;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
        self.animImageView.frame = self.selectImageFrame;
      
    }completion:^(BOOL finished) {
        
        
        [self removeFromSuperview];
    }];

    
}

#pragma mark lazy load

-(UICollectionView *)collectView{
    
    if(_collectView==nil){
        
        UICollectionView *cView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) collectionViewLayout:[self setupFlowLayout]];
        
        cView.pagingEnabled = YES;
        [cView registerClass:[YMPictureCell class] forCellWithReuseIdentifier:@"cCell"];
        _collectView = cView;
        
        [self addSubview:cView];
    }
    return _collectView;
}
-(UICollectionViewFlowLayout *)setupFlowLayout{
    
    UICollectionViewFlowLayout *flow = [[UICollectionViewFlowLayout alloc]init];

    flow.minimumLineSpacing = 0;
    flow.minimumInteritemSpacing = 0;
    flow.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height);
    
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    return flow;
}

#pragma mark 设置内容
-(void)setShowImages:(NSArray *)showImages{
    
    _showImages = showImages;
    
    NSString *imgName = _showImages[self.selectIndex];
    
    self.animImageView.image = [UIImage imageNamed:imgName];
    
    self.animImageView.frame = self.selectImageFrame;
    
    //如果已经下载好图片 就直接变大图
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.animImageView sizeToFit];

        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];

        self.animImageView.ym_centerY = self.ym_height*0.5;
        self.animImageView.ym_centerX = self.ym_width*0.5;
    }completion:^(BOOL finished) {
        
        self.collectView.delegate = self;
        self.collectView.dataSource = self;
        self.collectView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width*self.selectIndex, 0);
        [self.collectView reloadData];
    }];
   
   
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
 
    return self.showImages.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return  1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"cCell";
    
    YMPictureCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.showImage = self.showImages[indexPath.row];
    cell.backgroundColor = [UIColor blackColor];
    return  cell;
}

#pragma delegate


@end
