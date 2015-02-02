//
//  TextTableViewController.m
//  SMedical
//
//  Created by _SS on 14/12/26.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "TextTableViewController.h"
#import "Header.h"
#import "TextTableViewCell.h"
@interface TextTableViewController (){
    BOOL _isEdit;
    NSMutableArray *_focusOnArray; // 关注的病患section里的数据
    NSMutableArray *_useArray; // 最近使用section里的数据
    NSArray *_titleArray; // 所有文档名
}
@property (nonatomic, strong)NSArray *nameArray; // 所有文本模板section里的数据

@end

@implementation TextTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"文本模板";
    self.view.backgroundColor = RGBACOLOR(240, 239, 245, 1);
    
    UIBarButtonItem *leftBBI = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(dismissTextTableViewCtr:)];
    self.navigationItem.leftBarButtonItem = leftBBI;
    
    UIBarButtonItem *rightBBI = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStylePlain) target:self action:@selector(editText:)];
    self.navigationItem.rightBarButtonItem = rightBBI;
    
    _isEdit = NO;

    self.nameArray = [[NSArray alloc] initWithObjects:@{@"title":@"检查Cx",@"content":@"  检查培养报告"},@{@"title":@"检查结果",@"content":@"  检查化验结果"},@{@"title":@"制备Cx",@"content":@"  制备培养标准"},@{@"title":@"审核X-R",@"content":@"  审核放射医学影像"},nil];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"focuseOnArray"]) {
        _focusOnArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"focuseOnArray"]];
    }else{
        _focusOnArray = [[NSMutableArray alloc] init];
    }
    
    _useArray = [[NSMutableArray alloc] init];
    // 已经使用过的数据在最近使用中展示
    _titleArray = [[NSArray alloc] initWithObjects:@"检查Cx",@"制备Cx",@"检查结果",@"审核X-R", nil];
    for (NSString *title in _titleArray) {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:title]) {
            [_useArray addObject:[[NSUserDefaults standardUserDefaults] objectForKey:title]];
        }
    }

    [self setExtraCellLineHidden:self.tableView];
    // 在编辑状态下也可以响应点击事件
    [self.tableView setAllowsSelectionDuringEditing:YES];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 删除空数据
    for (NSDictionary *dic in _focusOnArray) {
        if ([[dic objectForKey:@"title"] isEqualToString:@""]) {
            [_focusOnArray removeObject:dic];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:_focusOnArray forKey:@"focuseOnArray"];
}

- (void)dismissTextTableViewCtr:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editText:(UIBarButtonItem *)rightBBI{
    if (_isEdit == NO) {
        self.navigationItem.rightBarButtonItem.title = @"完成";
        _isEdit = YES;
        self.navigationItem.leftBarButtonItem.title = @"";
    }else{
        self.navigationItem.rightBarButtonItem.title = @"编辑";
        _isEdit = NO;
        self.navigationItem.leftBarButtonItem.title = @"取消";
    }
    [self.tableView reloadData];
    [self.tableView setEditing:_isEdit animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - 去掉多余的线
- (void)setExtraCellLineHidden:(UITableView *)tableView{
    UIView *view = [UIView new];
    [tableView setTableFooterView:view];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* myView = [[UIView alloc] init];
    myView.layer.borderWidth = 0.3;
    myView.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    myView.backgroundColor = RGBACOLOR(240, 239, 245, 1);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 30)];
    titleLabel.font = [UIFont systemFontOfSize:14.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [myView addSubview:titleLabel];
    
    switch (section) {
        case 0:{
            titleLabel.text = @"关注的病患";
        }break;
        case 1:{
            titleLabel.text = @"最近使用";
        }break;
        case 2:{
            titleLabel.text = @"所有文本模板";
        }break;
        default:{
            return nil;
        }break;
    }

    return myView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:{
            if (_focusOnArray.count == 0) {
                return 1;
            }else{
                return _focusOnArray.count;
            }
        }break;
        case 1:{
            if (_useArray.count == 0) {
                return 1;
            }else{
                return _useArray.count;
            }
        }break;
        case 2:{
            return self.nameArray.count;
        }break;
    
        default:{
            return 0;
        }break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *identifier = @"cell";
    TextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TextTableViewCell alloc] initWithStyle:(UITableViewCellStyleValue2) reuseIdentifier:identifier];
    }
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.detailTextLabel.textColor = RGBACOLOR(11, 94, 173, 1);
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0];

    switch (indexPath.section) {
        case 0:{
            if (_focusOnArray.count == 0) {
                cell.textLabel.text = @"";
                cell.detailTextLabel.text = @"未设置病患关注";
            }else{
                cell.textLabel.text = [[_focusOnArray objectAtIndex:indexPath.row] objectForKey:@"title"];
                cell.detailTextLabel.text = [[_focusOnArray objectAtIndex:indexPath.row] objectForKey:@"content"];
                cell.contentDic = [_focusOnArray objectAtIndex:indexPath.row];
            }
        }break;
        case 1:{
            if (_useArray.count == 0) {
                cell.textLabel.text = @"";
                cell.detailTextLabel.text = @"最近无使用记录";
            }else{
                cell.textLabel.text = [[_useArray objectAtIndex:indexPath.row] objectForKey:@"title"];
                cell.detailTextLabel.text = [[_useArray objectAtIndex:indexPath.row] objectForKey:@"content"];
                cell.contentDic = [_useArray objectAtIndex:indexPath.row];
            }
        }break;
        case 2:{
            cell.textLabel.text = [[self.nameArray objectAtIndex:indexPath.row] objectForKey:@"title"];
            cell.detailTextLabel.text = [[self.nameArray objectAtIndex:indexPath.row] objectForKey:@"content"];
            cell.contentDic = [self.nameArray objectAtIndex:indexPath.row];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"focuseOnArray"]) {
                for (NSDictionary *dic in [[NSUserDefaults standardUserDefaults] objectForKey:@"focuseOnArray"]) {
                    if ([cell.contentDic isEqual:dic]) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                }
            }
        }break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TextTableViewCell *cell = (TextTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:{
            if (_focusOnArray.count > 0) {
                if (_isEdit == YES) {
                    
                }else{
                    // 非编辑状态
                    NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:cell.contentDic,@"dic", nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendsectonmassege" object:nil userInfo:info];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }else{
                // 没有数据不能编辑
            }
        }break;
        case 1:{
            if (_useArray.count > 0) {
                if (_isEdit == YES) {
                }else{
                    NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:cell.contentDic,@"dic", nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendsectonmassege" object:nil userInfo:info];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }else{
            }
        }break;
        case 2:{
            if (_isEdit == YES) {
                // 为_focusOnArray 添加数据
                if (cell.accessoryType == UITableViewCellAccessoryNone) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    [_focusOnArray addObject:cell.contentDic];
                }else{
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    [_focusOnArray removeObject:cell.contentDic];
                }
                [self tableView:tableView reloadSection:0];

            }else{
                NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:cell.contentDic,@"dic", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"sendsectonmassege" object:nil userInfo:info];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }break;
            
        default:
            break;
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // 不是在编辑状态也可以滑动删除
    for (NSDictionary *dic in _focusOnArray) {
        if ([[dic objectForKey:@"title"] isEqualToString:@""]) {
            [_focusOnArray removeObject:dic];
        }
    }
    if (indexPath.section == 0 && _focusOnArray.count > 0 ) {
        return YES;
    }else{
        return NO;
    }
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isEdit == YES && indexPath.section == 0 && _focusOnArray.count > 0) {
        return YES;
    }else{
        return NO;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView  editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

#pragma mark - 删除数据
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_isEdit == NO) {
        [self editText:self.navigationItem.rightBarButtonItem];
    }
    if (_focusOnArray.count > 1) {
        [_focusOnArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        // 没有数据可以删的时候加入一个标记 并且重新加载数据
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:@"",@"title",@"未设置病患关注",@"content", nil];
        [_focusOnArray insertObject:dic atIndex:indexPath.row];
        [tableView reloadData];
        [_focusOnArray removeObjectAtIndex:indexPath.row + 1];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - 移动数据变化
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    NSUInteger fromRow = sourceIndexPath.row;
    NSUInteger toRow = destinationIndexPath.row;
    id object = [_focusOnArray objectAtIndex:fromRow];
    [_focusOnArray removeObjectAtIndex:fromRow];
    [_focusOnArray insertObject:object atIndex:toRow];

}

#pragma mark - 同组间移动
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath{
    if (sourceIndexPath.section != proposedDestinationIndexPath.section){
        //如果不同,返回源的起始位置
        return sourceIndexPath;
    }
    else{
        //如果相同,返回目的的位置
        return proposedDestinationIndexPath;
    }
}

#pragma mark - cell 数据变化后reloadData
- (void)tableView:(UITableView *)tableview reloadSection:(NSUInteger)section{
    //一个section刷新
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:section];
    [tableview reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    //一个cell刷新
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:section];
    [tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

@end
