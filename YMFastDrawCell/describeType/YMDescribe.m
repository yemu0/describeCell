//
//  YMDescribe.m
//  YMFastDrawCell
//
//  Created by 夜幕 on 16/12/19.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import "YMDescribe.h"
#import "YMCellManager.h"
#import "YMTestModel.h"
#import "YMTestForwardModel.h"
#import "YMPictureView.h"
#import "YMComment.h"
@implementation YMDescribe

+(void)load{

 
    //===========百思描述  ymBaisi_Identifier====================
    [[YMCellManager defaultManager] ym_describeCellWithIdentifier:ymBaisi_Identifier describe:^(YMDescribeCell *cell, NSObject *model) {
        //模型为ym_getCellDescribeWithTableView 传进来的模型
        YMTestModel *testM = (YMTestModel *)model;
        //设置头部内容
        cell.ym_headerView.ym_titleLabel.text = testM.name;
        cell.ym_headerView.ym_subLabel.text = testM.createTimer;
        cell.ym_headerView.ym_imageView.image = [UIImage imageNamed:testM.imageName];
        
        //只会设置一次
        [cell.ym_headerView ym_setAttribute:^{
            cell.ym_headerView.ym_imageView.layer.cornerRadius = 22;
            cell.ym_centerView.ym_miniImageSize = CGSizeMake(cell.ym_centerView.ym_width, 0);
        }];

        //设置中间内容
        cell.ym_centerView.ym_imageSize = testM.imageSize;
        cell.ym_centerView.ym_imageView.image = [UIImage imageNamed:testM.imageName];
       
        //设置尾部内容
        __block int i=0;
        [cell.ym_footerView ym_addToolsViewWithNumber:4 margin:1 toolViewHeight:44 setupSubviews:^(UIButton *btn, UIView *toolsView) {
            [btn setTitleColor:[UIColor grayColor] forState: UIControlStateNormal];
            btn.backgroundColor = YMGlobalBGColor;
            [btn setTitle:[NSString stringWithFormat:@"赞%zd",i++] forState:UIControlStateNormal];
        }];
        [cell.ym_footerView ym_toolsSubviewsClick:^(UIButton *btn) {
            NSLog(@"%@被点击了",btn.titleLabel.text);
        }];
        //设置评论内容
        [cell.ym_footerView ym_addCommentViewWithNumber:testM.comments.count setupComment:^(YMCommentLabel *label, NSInteger index) {
           
            NSString *str = [NSString stringWithFormat:@"%@:%@",testM.comments[index].name,testM.comments[index].content];
            label.text = str;
        
            [label ym_setupAttributeColorWithTextArray:@[testM.comments[index].name,@"我是评论_我是"]];
            
            [label ym_clickActive:^(NSString *string) {
                NSLog(@" %@ 评论点击 点击",string);
            }];
        }];
    }];
     //===========微博描述====================
    //两个cell共有内容
    [[YMCellManager defaultManager] ym_describeCellWithIdentifier:ymWeiBoCenter_Identifier describe:^(YMDescribeCell *cell, id model) {
        
            YMTestModel *testM = (YMTestModel *)model;
            [cell.ym_centerView ym_setAttribute:^ {
                [cell.ym_centerView.ym_contentLable setTextColor:[UIColor grayColor]];
            }];
            [cell.ym_centerView.ym_contentLable setText:testM.content];

        [cell.ym_centerView ym_addSudokuLayoutWithClass:[UIImageView class] setSuduko:^(YMSuduko *suduko) {
                //设置九宫格内容
                suduko.column = 3;
                suduko.number = testM.imageNames.count;
                suduko.viewMargin = 1;
                suduko.subviewSize =CGSizeZero;
                switch (suduko.number) {
                    case 4:
                        suduko.column = 2;
                        break;
                    case 1:
                        suduko.subviewSize = CGSizeMake(100, 100);
                        break;
                    default:
                        break;
                }
            } setSudukoSubviews:^(UIImageView *sudukoSubview, UIView *sudukoView ,NSInteger index) {
      
                    sudukoSubview.image = [UIImage imageNamed:testM.imageNames[index]];
               
            }];
        [cell.ym_centerView ym_sudukoActiveHaveModels:^(UIView *view, NSInteger index, NSArray *models) {
            //点击显示照片
            YMPictureView *picView = [[YMPictureView alloc]init];
            picView.selectImageFrame = [view.superview convertRect:view.frame toView:nil];
            picView.selectIndex = index;
            picView.showImages = models;
            [[UIApplication sharedApplication].keyWindow addSubview:picView];
        }];
    }];

    //绘制转发原本cell
    [[YMCellManager defaultManager]ym_describeCellWithIdentifier:ymWeiBoCell_Identifier describe:^(YMDescribeCell *cell, id model) {
        
        YMTestModel *testM = (YMTestModel *)model;
        [cell.ym_headerView.ym_titleLabel setText:testM.name];
        cell.ym_headerView.ym_subLabel.text = testM.createTimer;
        
        [cell.ym_headerView ym_setAttribute:^{;
            cell.ym_headerView.ym_imageView.layer.cornerRadius = 22;
            [cell.ym_headerView.ym_subLabel setTextColor:[UIColor blackColor]];
        }];
    
        cell.ym_headerView.ym_imageView.image = [UIImage imageNamed:testM.imageName];
        
        [[YMCellManager defaultManager] ym_performBlockWithCell:cell Identifier:ymWeiBoCenter_Identifier model:model];
        
        __block int i = 1;
        cell.ym_footerView.ym_margin = 0;
        [cell.ym_footerView ym_addToolsViewWithNumber:3 margin:1 toolViewHeight:44 setupSubviews:^(UIButton *btn, UIView *toolsView) {
            [btn setTitleColor:[UIColor grayColor] forState: UIControlStateNormal];
            btn.backgroundColor = YMGlobalBGColor;
            [btn setTitle:[NSString stringWithFormat:@"赞%zd",i++] forState:UIControlStateNormal];
        }];
        
        [cell.ym_footerView ym_toolsSubviewsClick:^(UIButton *btn) {
            NSLog(@"点击了%@",[btn titleForState:UIControlStateNormal]);
        }];
    }];
    
    //绘制转发cell
    [[YMCellManager defaultManager] ym_describeCellWithIdentifier:ymWeiBoForwarFinish_Identifier describe:^(YMDescribeCell *cell, id model) {
        
        YMTestModel *testM = (YMTestModel *)model;
        [cell.ym_headerView.ym_titleLabel setText:testM.forward.name];
        [cell.ym_headerView ym_setAttribute:^{;
            [cell.ym_headerView.ym_titleLabel setTextColor:[UIColor blackColor]];
        }];
        
        //绘制中心内容
        if(testM.forward){
            [[YMCellManager defaultManager] ym_performBlockWithCell:cell Identifier:ymWeiBoCenter_Identifier model:testM.forward];
            cell.hidden = NO;
        }else
            cell.hidden = YES;
       
        [cell.ym_centerView.ym_contentLable setTextColor:[UIColor blueColor]];
        
        [cell ym_startDescribe];
        cell.ym_height -= 10;
    }];
    
}
@end














