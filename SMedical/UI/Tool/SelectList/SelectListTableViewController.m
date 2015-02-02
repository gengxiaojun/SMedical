//
//  SelectListTableViewController.m
//  SMedical
//
//  Created by _SS on 14/12/1.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "SelectListTableViewController.h"
#import "DataManager.h"
#import "Header.h"
@interface SelectListTableViewController ()
@end

@implementation SelectListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(247, 247, 247, 1);
    self.navigationItem.title = @"病患列表";
    UIBarButtonItem *leftBBI = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = leftBBI;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    [self setExtraCellLineHidden:self.tableView];
}

- (void)setExtraCellLineHidden:(UITableView *)tableView{
    UIView *view = [UIView new];
    [tableView setTableFooterView:view];
}

- (void)cancel:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark -
#pragma mark - tableView设置
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* myView = [[UIView alloc] init];
    myView.backgroundColor = RGBACOLOR(247, 247, 247, 1);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 300, 30)];
    titleLabel.font = [UIFont systemFontOfSize:13.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [myView addSubview:titleLabel];
    if (section == 0) {
        titleLabel.text = @"我的病房";
    }
    return myView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 30;
    }else{
        return 20;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                cell.textLabel.text = @"病房A";
                
            }else{
                cell.textLabel.text = @"病房B";
            }
            break;
        case 1:
            cell.textLabel.text = @"我的病患";
            break;
        case 2:
            cell.textLabel.text = @"我关注的病患";
            break;

        default:
            break;
    }
    if([cell.textLabel.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"mark"]]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:{
            if (indexPath.row == 0) {
                NSMutableArray *dataArray = [[DataManager shareInstance] selectPatientWithRoomA];
                NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:dataArray,@"data",@"我的病房-病房A",@"title", nil];
                [self dismissViewControllerAnimated:YES completion:^{
                    [[NSUserDefaults standardUserDefaults] setObject:cell.textLabel.text forKey:@"mark"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectRoomA" object:nil userInfo:info];
                }];
            }else{
                NSMutableArray *dataArray = [[DataManager shareInstance] selectPatientWithRoomB];
                NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:dataArray,@"data",@"我的病房-病房A",@"title", nil];
                [self dismissViewControllerAnimated:YES completion:^{
                    [[NSUserDefaults standardUserDefaults] setObject:cell.textLabel.text forKey:@"mark"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectRoomB" object:nil userInfo:info];
                }];
            }
        }
            break;
        case 1:{
            NSMutableArray *dataArray = [[DataManager shareInstance] selectAllPatients];
            NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:dataArray,@"data",@"我的病患",@"title", nil];
            [self dismissViewControllerAnimated:YES completion:^{
                [[NSUserDefaults standardUserDefaults] setObject:cell.textLabel.text forKey:@"mark"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectMyPatients" object:nil userInfo:info];
            }];
        }
            break;
        case 2:{
            NSMutableArray *dataArray = [[DataManager shareInstance] selectAllFocusPatients];
            NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:dataArray,@"data",@"我关注的病患",@"title", nil];
            [self dismissViewControllerAnimated:YES completion:^{
                [[NSUserDefaults standardUserDefaults] setObject:cell.textLabel.text forKey:@"mark"];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectMyFocus" object:nil userInfo:info];
            }];
        }
            break;
        default:
            break;
    }
    [self.tableView reloadData];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
