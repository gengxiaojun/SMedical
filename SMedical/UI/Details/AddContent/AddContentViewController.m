//
//  AddContentViewController.m
//  SMedical
//
//  Created by _SS on 14/12/18.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "AddContentViewController.h"
#import "Header.h"
#import "ChangePersonalcommentsViewController.h"
#import "AddViewController.h"
@interface AddContentViewController()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *_titleArray;
}

@end

@implementation AddContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self creatSubView];
    
    _titleArray = [[NSArray alloc] initWithObjects:@"个人注释",@"临床任务",@"治疗进度", nil];
}

- (void)creatSubView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    topView.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    [self.view addSubview:topView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(10, 20, 40, 40);
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancelButton addTarget:self action:@selector(dismissAddContentView:) forControlEvents:UIControlEventTouchDown];
    [topView addSubview:cancelButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 50, 20, 100, 40)];
    titleLabel.text = @"添加新项";
    titleLabel.font = [UIFont systemFontOfSize:19.0];
    [topView addSubview:titleLabel];
    
    UITableView *listTableView = [[UITableView alloc] initWithFrame:CGRectMake(-1, 64, SCREENWIDTH + 2, SCREENHEIGHT_INBAR + 1)];
    listTableView.delegate = self;
    listTableView.dataSource = self;
    listTableView.layer.borderWidth = 0.3;
    listTableView.layer.borderColor = [[UIColor lightGrayColor] CGColor];

    [self.view addSubview:listTableView];
    
    [self setExtraCellLineHidden:listTableView];
}

- (void)dismissAddContentView:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark -
#pragma mark - 去掉多余的线
- (void)setExtraCellLineHidden:(UITableView *)tableView{
    UIView *view = [UIView new];
    [tableView setTableFooterView:view];
}

#pragma mark -
#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    cell.textLabel.text = [_titleArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.navigationController.navigationBar.hidden = YES;
    switch (indexPath.row) {
        case 0:{
            ChangePersonalcommentsViewController *percommentsVC = [[ChangePersonalcommentsViewController alloc] init];
            percommentsVC.patiemtName = self.patientName;
            [self presentViewController:percommentsVC animated:YES completion:^{
            }];
        }
            break;
        case 1:{
            AddViewController *addView = [[AddViewController alloc] init];
            addView.patientName = self.patientName;
            addView.isAddClinicalTask = YES;
            UINavigationController *addNC = [[UINavigationController alloc] initWithRootViewController:addView];
            [self presentViewController:addNC animated:YES completion:^{
            }];
        }
            break;
        case 2:{
            AddViewController *addView = [[AddViewController alloc] init];
            addView.patientName = self.patientName;
            addView.isAddClinicalTask = NO;
            UINavigationController *addNC = [[UINavigationController alloc] initWithRootViewController:addView];
            [self presentViewController:addNC animated:YES completion:^{
            }];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
