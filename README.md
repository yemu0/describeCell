# describeCell
fast Describe tableView cell

# struct
![image](https://github.com/yemu0/describeCell/cell.png)

# Examples [示例]

### 百思示例
```objc

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    //获取模型
    YMTestModel *testM = self.testModelArray[indexPath.row];
    
    //根据 ymBaisi_Identifier 标识符获取描述的块
    YMDescribeCell *cell = [[YMCellManager defaultManager] ym_getCellDescribeWithTableView:tableView Identifier:ymBaisi_Identifier model:testM adjustment:nil];
    //开始绘制
    [cell ym_startDescribe];
    [tableView setRowHeight:cell.ym_height];
    
    return cell;
}
```

```objc

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
}
```

