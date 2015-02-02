//
//  TestResultsViewController.m
//  SMedical
//
//  Created by _SS on 15/1/27.
//  Copyright (c) 2015年 shanshan. All rights reserved.
//

#import "TestResultsViewController.h"
#import "Header.h"
@interface TestResultsViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSArray *_sectionArray;
    NSArray *_firstSectionRowArray;
    NSArray *_secondSectionRowArray;
    NSArray *_thirdSectionRowArray;
}
@end

@implementation TestResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITableView *leftView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH / 3, SCREENHEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:leftView];
    leftView.delegate = self;
    leftView.dataSource = self;
    
//    UITableView *leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT) style:UITableViewStylePlain];
//    leftTableView.backgroundColor = [UIColor yellowColor];
//    leftTableView.delegate = self;
//    leftTableView.dataSource = self;
//    [self.view addSubview:leftTableView];
//
    NSString *path = [[NSBundle mainBundle] pathForResource:@"TestResults" ofType:@"json"];
    NSData *theData = [NSData dataWithContentsOfFile:path];
    id responseJSON = [NSJSONSerialization JSONObjectWithData:theData options:NSJSONReadingMutableContainers error:nil];
    
    id responseJSONResult = [responseJSON objectForKey:@"心绞痛"];
    NSLog(@"%@",responseJSONResult);
    _sectionArray = [[NSArray alloc] initWithObjects:@"动脉血气分析", nil];
    _firstSectionRowArray = [[NSArray alloc] initWithObjects:@"碱剩余(-2.5/+2.5 mmol/L)",@"血氧饱和度(93/99 %)",@"CO2 分压(4.7/5.7 kPa)",@"pH值，硼氢化钠(7.36/7.44)",@"氧气(9/13.9 kPa)",@"标准碳酸氢盐(20/28 mmol/L)", nil];
    _sectionArray = nil;
    _thirdSectionRowArray = nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark -delegate datasouce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:{
            return 2;
        }break;
        case 1:{
            if (_secondSectionRowArray) {
                return _secondSectionRowArray.count;
            }
        }break;
        case 2:{
            if (_thirdSectionRowArray) {
                return _thirdSectionRowArray.count;
            }
        }break;
            
        default:
            break;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *myView = [[UIView alloc] init];
    myView.backgroundColor = RGBACOLOR(204, 204, 204, 1);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH / 3, 30)];
    titleLabel.textColor = RGBACOLOR(0, 122, 255, 1);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = [ _sectionArray objectAtIndex:section];
    NSLog(@"%@",[_sectionArray objectAtIndex:0]);
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [myView addSubview:titleLabel];
    return myView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"aa";
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    switch (indexPath.section) {
        case 0:{
            cell.textLabel.text = @"aa";
        }break;
        case 1:{
            if (_secondSectionRowArray) {
                cell.textLabel.text = [_secondSectionRowArray objectAtIndex:indexPath.row];
            }
        }break;
        case 2:{
            if (_thirdSectionRowArray) {
                cell.textLabel.text = [_thirdSectionRowArray objectAtIndex:indexPath.row];
            }
        }break;
        default:
            break;
    }
    return cell;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
