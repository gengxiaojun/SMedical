//
//  MarkTableViewController.m
//  SMedical
//
//  Created by _SS on 14/12/4.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "MarkTableViewController.h"
#import "MarkTableViewCell.h"
#import "MarkEditViewController.h"
@interface MarkTableViewController (){
    BOOL isEdit;
    BOOL isMark;
    NSMutableArray *_markDataArray; // 所有标注信息（{颜色字典},{信息字典}）
    NSArray *_imageViewArray;
    NSArray *_introduceArray;
    int _count;
    NSMutableArray *_selectContents; // 所有选中的标注(仅标注颜色)
}
@end

@implementation MarkTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关注的病患";
    
    // 若已经有标记的对象,首次展示
    NSArray *markArray = [[NSUserDefaults standardUserDefaults] objectForKey:self.personName];
    if (markArray) {
        _selectContents = [[NSMutableArray alloc] initWithArray:markArray];
    }else{
        _selectContents = [[NSMutableArray alloc] init];
    }
    
    _imageViewArray = [[NSArray alloc] initWithObjects:@"green",@"yellow",@"blue",@"purple", nil];
    _introduceArray = [[NSArray alloc] initWithObjects:@"绿色",@"黄色",@"蓝色",@"紫色", nil];
    
    UIBarButtonItem *leftBBI = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStylePlain) target:self action:@selector(presentViewControllerdissmiss:)];
    self.navigationItem.leftBarButtonItem = leftBBI;
    
    UIBarButtonItem *rightBBI = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStylePlain) target:self action:@selector(editMarkContent:)];
    self.navigationItem.rightBarButtonItem = rightBBI;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    [self setExtraCellLineHidden:self.tableView];
    
}

- (void)viewDidAppear:(BOOL)animated{
    _count = 0;
    [super viewDidAppear:animated];
    _markDataArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < _imageViewArray.count; i++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[_imageViewArray objectAtIndex:i] forKey:@"color"];
        // 如果做了变化就显示变化的内容
        if ([[NSUserDefaults standardUserDefaults] objectForKey:[_imageViewArray objectAtIndex:i]]) {
            [dic setObject:[[NSUserDefaults standardUserDefaults] objectForKey:[_imageViewArray objectAtIndex:i]] forKey:@"instructions"];
        }else{
            [dic setObject:[_introduceArray objectAtIndex:i] forKey:@"instructions"];
        }
        [_markDataArray addObject:dic];
    }
    [self.tableView reloadData];
}

- (void)presentViewControllerdissmiss:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        // 以患者名字为key值的选择标注的数据持久化
        [[NSUserDefaults standardUserDefaults] setObject:_selectContents forKey:self.personName];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloaData" object:nil userInfo:nil];
    }];
}

- (void)editMarkContent:(id)sender{
    UIBarButtonItem *rightBBI = (UIBarButtonItem *)sender;
    if ([rightBBI.title isEqualToString:@"编辑"]) {
        isEdit = YES;
        rightBBI.title = @"完成";
        self.navigationItem.leftBarButtonItem.title = @"";
    }else{
        isEdit = NO;
        rightBBI.title = @"编辑";
        self.navigationItem.leftBarButtonItem.title = @"完成";
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifer = @"cell";
    MarkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[MarkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.markModel = [[MarkModel alloc] initWithDic:[_markDataArray objectAtIndex:indexPath.row]];
    for (NSString *color in _selectContents) {
        if ([cell.markModel.markColor isEqual:color]) {
            cell.isSelect = YES;
        }
    }
    if (isEdit == YES) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        if (cell.isSelect == YES) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MarkTableViewCell *cell = (MarkTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"编辑"]) {
        if (cell.isSelect == YES) {
            cell.isSelect = NO;
            [_selectContents removeObject:cell.markModel.markColor];
        }else{
            cell.isSelect = YES;
            [_selectContents addObject:cell.markModel.markColor];
        }
    }else{
        MarkEditViewController *markEditVC = [[MarkEditViewController alloc] init];
        markEditVC.markModel = cell.markModel;
        [self.navigationController pushViewController:markEditVC animated:YES];
    }
    [self.tableView reloadData];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* myView = [[UIView alloc] init];
    myView.backgroundColor = [UIColor whiteColor];
    return myView;
}
#pragma mark -
#pragma mark - 除去多余的线
- (void)setExtraCellLineHidden:(UITableView *)tableView{
    UIView *view = [UIView new];
    [tableView setTableFooterView:view];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
