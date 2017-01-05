# describeCell
fast Describe tableView cell

# struct
![image](https://github.com/yemu0/describeCell/blob/master/readmeImage/cellStruct.png)

![image](https://github.com/yemu0/describeCell/blob/master/readmeImage/show.gif)

#functionExplain
##addView 
```objc
/** 根据类名添加view 没有则创建 */
-(id)ym_addSubViewWithClass:(Class) objectClass identifier:(NSString *) identifier;

/** 
 * 根据标识符取出view
 * @param objectClass    view 的类型
 * @param identifier    取出这个view时候使用
 * @param view          初始化viewblock
 * @param isCreate      如果没有是否创建
 */
-(id)ym_addSubViewWithClass:(Class) objectClass identifier:(NSString *) identifier initializeView:(void(^)(UIView *view)) view isCreate:(BOOL) isCreate;

```
##addGestureRecognizer
```objc
/**添加手势
 参数1:手势类型
 参数2:给那个view
 参数3:手势激活后
 */
-(void)ym_addGestureRecognizerTypeWithClass:( Class) gestureClass targetView:( UIView *)targetView activeBlock:( void(^)(UIView *view))active;
```
# Examples [示例]

### 百思示例
```objc

    - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    //获取模型
    YMTestModel *testM = self.testModelArray[indexPath.row];

    //根据 ymBaisi_Identifier 标识符获取描述的块
    YMTableViewCell *cell = [[YMCellManager defaultManager] ym_getCellDescribeWithTableView:tableView Identifier:ymBaisi_Identifier model:testM adjustment:nil];

    cell.ym_cellMargin = 0;

    //开始绘制
    [cell ym_startDescribe];
    //缓存高度
    [tableView ym_cacheRowHeight:cell.ym_height indexPath:indexPath];

    return cell;
    }


    -(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return [tableView ym_getRowHeightWithIndexPath:indexPath];
    }

```

```objc

    [[YMCellManager defaultManager] ym_describeCellWithIdentifier:ymBaisi_Identifier describe:^(YMTableViewCell *cell, NSObject *model) {
        //模型为ym_getCellDescribeWithTableView 传进来的模型
        YMTestModel *testM = (YMTestModel *)model;
        //设置头部内容
        cell.ym_headerView.ym_titleLabel.text = testM.name;
        cell.ym_headerView.ym_subLabel.text = testM.createTimer;
        cell.ym_headerView.ym_imageView.image = [UIImage imageNamed:testM.imageName];

        //只会设置一次
        [cell.ym_headerView ym_setupAttribute:^{
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
        [cell.ym_footerView ym_addCommentViewWithNumber:testM.comments.count setupComment:^(YMLabel *label, NSInteger index) {

            NSString *str = [NSString stringWithFormat:@"%@:%@",testM.comments[index].name,testM.comments[index].content];
            label.text = str;

            //设置最大行数
            label.limitLine = 2;

            //设置那个字符串改变颜色
            [label ym_setupAttributeColorWithTextArray:@[testM.comments[index].name]];

            //赋值lable展示状态
            label.ym_showtype = testM.comments[index].labelShowType;


            __weak YMTableViewCell *weakcell = cell;

            //改变展开状态block
            [label ym_changeShowType:^(YMLabelShowType type) {
            //赋值模型的showType
            testM.comments[index].labelShowType = type;

            //如果为展开或者收起 刷新数据
            if(type==YMLabelShowTypePackup ||type == YMLabelShowTypeUnfold){

            UITableView *tb = (UITableView *)weakcell.superview.superview;

            NSIndexPath *ip = [[YMCellManager defaultManager] ym_getIndexPathWithView:label];
            [tb reloadRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationNone];
            }
            }];
            //当设置的ym_setupAttributeColorWithTextArray 被点击的block
            [label ym_clickActive:^(NSString *string) {

            }];

        }];
    }];
```

