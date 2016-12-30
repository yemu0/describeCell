//
//  YMChooseViewController.m
//  YMFastDrawCell
//
//  Created by 夜幕 on 16/12/12.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import "YMChooseViewController.h"
#import "YMBSViewController.h"
#import "YMWeiboCollectionViewController.h"

@interface YMChooseViewController ()

@end

@implementation YMChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"仿百思cell";
            break;
        case 1:
            cell.textLabel.text = @"仿微博cell";
            break;
        default:
            break;
    }
 
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    switch (indexPath.row) {
        case 0:{
            YMBSViewController *vc = [[YMBSViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 1:
        {
            YMWeiboCollectionViewController *vc = [[YMWeiboCollectionViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            break;
        }
    
        default:
            break;
    }
}


@end
