//
//  SelectTableViewController.m
//  SMedical
//
//  Created by _SS on 14/12/23.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "SelectTableViewController.h"
#import "Header.h"
#import "SelectTableViewCell.h"
@interface SelectTableViewController (){
    NSArray *_dataArray;
    NSString *_selectCateray;
}

@end

@implementation SelectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"类别";
    self.view.backgroundColor = RGBACOLOR(245, 245, 245, 1);
   
    if (self.isAddClinicalTask == YES) {
        _dataArray = [[NSArray alloc] initWithObjects:@"出院病患",@"药物",@"时间安排",@"化验",@"诊断放射成像",@"医嘱",@"联系家人",@"开处方",@"病患教育", nil];
    }else{
        _dataArray = [[NSArray alloc] initWithObjects:@"医师",@"护士",@"社会服务人员",@"呼吸治疗师",@"营养学家",@"营养师",@"教育家",@"临床护理专家", nil];
    }
    [self setExtraCellLineHidden:self.tableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSString *Str = [[NSUserDefaults standardUserDefaults] objectForKey:@"selectcellisclick"];
    if (Str) {
        _selectCateray = [[NSString alloc] initWithFormat:@"%@",Str];
    }else{
        _selectCateray = [[NSString alloc] init];
    }

}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* myView = [[UIView alloc] init];
    myView.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    return myView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    SelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SelectTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    if ([_selectCateray isEqualToString:cell.textLabel.text]) {
        cell.isClick = YES;
    }
    if (cell.isClick == YES) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectTableViewCell *cell = (SelectTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.isClick == YES) {
        cell.isClick = NO;
        _selectCateray = @"";
    }else{
        cell.isClick = YES;
        _selectCateray = cell.textLabel.text;
        [[NSUserDefaults standardUserDefaults] setObject:cell.textLabel.text forKey:@"selectcellisclick"
         ];
        [self.navigationController popViewControllerAnimated:YES];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    [tableView reloadData];
    
}

#pragma mark -
#pragma mark - 去掉多余的线
- (void)setExtraCellLineHidden:(UITableView *)tableView{
    UIView *view = [UIView new];
    [tableView setTableFooterView:view];
}

@end
