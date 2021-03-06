//
//  YMCellManager.h
//  YMFastDrawCell
//
//  Created by 夜幕 on 16/12/19.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMTableViewCell;

@interface YMCellManager : NSObject

+(instancetype)defaultManager;

/** model为getCellDescribe时候传入的模型*/
typedef void(^describeCell)(YMTableViewCell *cell,NSObject * model);


/**
 * 描述cell
 * @param identifier             标识符
 * @param describe             描述block
 */
-(void )ym_describeCellWithIdentifier:(NSString *)identifier
                                       describe:(describeCell)describe;
/** 
 * 根据标识符对cell执行某个描述,内部会自动注册cell
 * @param tableView              tableView
 * @param identifier             描述时候存放的标识符
 * @param model                  描述cell的模型
 * @param adjustment             调整block
 */
-(YMTableViewCell *)ym_getCellDescribeWithTableView:(UITableView *)tableView
                                        Identifier:(NSString *)identifier
                                             model:(NSObject *)model
                                        adjustment:(describeCell) adjustment;


/**根据标识符对传进来的cell执行某个描述 */
-(void)ym_performDescribeWithCell:(YMTableViewCell *)cell
                    Identifier:(NSString *)identfier
                         model:(NSObject *)model
                    adjustment:(describeCell) adjustment;



/**根据view获取indexPath,这个view必须是tableView和cellView的子视图*/
-(NSIndexPath*)ym_getIndexPathWithView:(UIView *)view;

/**
 * 根据view获取cell
 * @param view                     必须是cell的子类
 * @param superIsTableView         YES 代表父类一定是tabview
 */
-(UITableViewCell *)ym_getCellWithView:(UIView *)view superIsTableView:(BOOL) superIsTableView;

/**移除全部描述块*/
-(void)ym_removeAll;

/**根据标识符移除描述*/
-(void)ym_removeDecribeWithIdentifier:(NSString *)identifier;




@end
