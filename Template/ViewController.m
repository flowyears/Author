//
//  ViewController.m
//  Template
//
//  Created by boolean on 17/6/21.
//  Copyright © 2017年 boolean. All rights reserved.
//

#import "ViewController.h"
#import "MMSystemAuthorManager.h"
#import "UtilTool.h"

static NSString * const kIdentifier = @"CellIdentifier";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{}
@property(nonatomic,strong)UITableView *table;
@property(nonatomic,strong)NSMutableArray *titles;
@property(nonatomic,strong)NSMutableArray *detailTitles;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Author";
    [UtilTool appIcon];
    [self.titles addObjectsFromArray:@[@"相册权限",
                                       @"相机权限",
                                       @"麦克风权限",
                                       @"定位权限",
                                       @"通讯录权限",
                                       @"日历权限",
                                       @"备忘录权限",
                                       @"推送权限",
                                       @"联网状态监测"]];
    [self.detailTitles addObjectsFromArray:@[@"别点我",
                                             @"别点我",
                                             @"别点我",
                                             @"别点我",
                                             @"别点我",
                                             @"别点我",
                                             @"别点我",
                                             @"我没回调",
                                             @"我没回调"]];
    [self.view addSubview:self.table];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Life Cycle
#pragma mark - UI
#pragma mark - Data
#pragma mark - Action
#pragma mark - Notification
#pragma mark - Method


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kIdentifier];
    }
    
    NSInteger row = [indexPath row];
    NSString *title = self.titles[row];
   __block NSString *detailTitles = self.detailTitles[row];
    
    if (row == 8)
    {
        [MMSystemAuthorManager authorCheckForNetwork:^(BOOL granted) {
            if (granted)
            {
                detailTitles = @"有网络权限";
            }
            else
            {
                detailTitles = @"无网络权限";
            }
        }];
    }
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = detailTitles;
    
    if ([detailTitles isEqualToString:@"已授权"])
    {
        cell.detailTextLabel.textColor = [UIColor greenColor];
    }
    else if ([detailTitles isEqualToString:@"被拒绝了把，哈哈"])
    {
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    else
    {
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __weak __typeof(self)weakSelf = self;
    NSInteger row = indexPath.row;
    switch (indexPath.row) {
        
        case 0:
        {
            [MMSystemAuthorManager authorCheckForAlbum:^(BOOL granted) {
                if (granted)
                {
                    [weakSelf.detailTitles replaceObjectAtIndex:row withObject:@"已授权"];
                }
                else
                {
                    [weakSelf.detailTitles replaceObjectAtIndex:row withObject:@"被拒绝了把，哈哈"];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.table reloadData];
                });
            }];
        }
            break;
        case 1:
        {
            [MMSystemAuthorManager authorCheckForVideo:^(BOOL granted) {
                if (granted)
                {
                    [weakSelf.detailTitles replaceObjectAtIndex:row withObject:@"已授权"];
                }
                else
                {
                    [weakSelf.detailTitles replaceObjectAtIndex:row withObject:@"被拒绝了把，哈哈"];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.table reloadData];
                });
            }];
        }
            break;
        case 2:
        {
            [MMSystemAuthorManager authorCheckForAudio:^(BOOL granted) {
                if (granted)
                {
                    [weakSelf.detailTitles replaceObjectAtIndex:row withObject:@"已授权"];
                }
                else
                {
                    [weakSelf.detailTitles replaceObjectAtIndex:row withObject:@"被拒绝了把，哈哈"];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.table reloadData];
                });
            }];
        }
            break;
        case 3:
        {
            [MMSystemAuthorManager authorCheckForLocation:^(BOOL granted) {
                if (granted)
                {
                    [weakSelf.detailTitles replaceObjectAtIndex:row withObject:@"已授权"];
                }
                else
                {
                    [weakSelf.detailTitles replaceObjectAtIndex:row withObject:@"被拒绝了把，哈哈"];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.table reloadData];
                });
            }];
        }
            break;
        case 4:
        {
            [MMSystemAuthorManager authorCheckForContact:^(BOOL granted) {
                if (granted)
                {
                    [weakSelf.detailTitles replaceObjectAtIndex:row withObject:@"已授权"];
                }
                else
                {
                    [weakSelf.detailTitles replaceObjectAtIndex:row withObject:@"被拒绝了把，哈哈"];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.table reloadData];
                });
            }];
        }
            break;
        case 5:
        {
            [MMSystemAuthorManager authorCheckForEvent:^(BOOL granted) {
                if (granted)
                {
                    [weakSelf.detailTitles replaceObjectAtIndex:row withObject:@"已授权"];
                }
                else
                {
                    [weakSelf.detailTitles replaceObjectAtIndex:row withObject:@"被拒绝了把，哈哈"];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.table reloadData];
                });
            }];
        }
            break;
        case 6:
        {
            [MMSystemAuthorManager authorCheckForReminder:^(BOOL granted) {
                if (granted)
                {
                    [weakSelf.detailTitles replaceObjectAtIndex:row withObject:@"已授权"];
                }
                else
                {
                    [weakSelf.detailTitles replaceObjectAtIndex:row withObject:@"被拒绝了把，哈哈"];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.table reloadData];
                });
            }];
        }
            break;
        case 7:
        {
            [MMSystemAuthorManager authorCheckForNotificaiton];
        }
            break;
        case 8:
        {
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - Getter And Setter

- (UITableView *)table
{
    if (!_table)
    {
        _table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _table.dataSource = self;
        _table.delegate = self;
        //        _<#tableName#>.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
                _table.backgroundColor = [UIColor clearColor];
        //        _<#tableName#>.separatorStyle = UITableViewCellSeparatorStyleNone;
                _table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        
        //[_table registerClass:[UITableViewCell class] forCellReuseIdentifier:kIdentifier];
    }
    return _table;
}

- (NSMutableArray *)titles
{
    if (!_titles)
    {
        _titles = [[NSMutableArray alloc] init];
    }
    return _titles;
}
- (NSMutableArray *)detailTitles
{
    if (!_detailTitles)
    {
        _detailTitles = [[NSMutableArray alloc] init];
    }
    return _detailTitles;
}
@end
