//
//  ViewController.m
//  Template
//
//  Created by boolean on 17/6/21.
//  Copyright © 2017年 boolean. All rights reserved.
//

#import "ViewController.h"


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
    [self.titles addObjectsFromArray:@[@"联网状态监测",
                                      @"相册权限",
                                      @"相机权限",
                                      @"麦克风权限",
                                      @"定位权限",
                                      @"推送权限",
                                      @"通讯录权限",
                                      @"日历权限",
                                       @"备忘录权限"]];
    [self.detailTitles addObjectsFromArray:@[@"别点我",
                                       @"别点我",
                                       @"别点我",
                                       @"别点我",
                                       @"别点我",
                                       @"别点我",
                                       @"别点我",
                                       @"别点我",
                                       @"别点我"]];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
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
    NSString *detailTitles = self.detailTitles[row];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = detailTitles;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
        {
        
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            
        }
            break;
        case 5:
        {
            
        }
            break;
        case 6:
        {
            
        }
            break;
        case 7:
        {
            
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
