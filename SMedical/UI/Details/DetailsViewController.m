//
//  DetailsViewController.m
//  SMedical
//
//  Created by _SS on 14/12/15.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "DetailsViewController.h"
#import "Header.h"
#import "ImageManager.h"
#import "DataArchive.h"

#import "DetailsTableViewCell.h"
#import "showPersonalInfoView.h"
#import "AddContentViewController.h"
// 各推出页面
#import "ChartViewController.h"
#import "TestResultsViewController.h"
#import "ImageVideosTableViewController.h"
@interface DetailsViewController ()<UITableViewDataSource,UITableViewDelegate>{
    BOOL _iswiggle;
    showPersonalInfoView *_showView;
    UIImageView *_aImageview;
    NSMutableArray *_listLabelTextArray;
    NSMutableArray *_iconImageNameArray;
    UIBarButtonItem *_rightBBI;
    UITableView *_listTableView;
    UIView *_tabView;
    UIImageView *_animationImageView;
}
@end

@implementation DetailsViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self createNaviagtionBarTitleView];
    
    _rightBBI = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStylePlain) target:self action:@selector(editListTableCell:)];
    self.navigationItem.rightBarButtonItem = _rightBBI;
    
    _listTableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:(UITableViewStylePlain)];
    [self.view addSubview:_listTableView];
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    [self setExtraCellLineHidden:_listTableView];
    
    NSArray *listLabelArray = [[DataArchive sharedShower] unArchiveDetalsShowWithKey:@"listLabelText"];
    NSArray *iconImageArray = [[DataArchive sharedShower] unArchiveDetalsShowWithKey:@"iconImageName"];

    if (listLabelArray.count > 0) {
        _listLabelTextArray = [NSMutableArray arrayWithArray:listLabelArray];
    }else{
        _listLabelTextArray = [[NSMutableArray alloc] initWithObjects:@"图表",@"文档",@"影像",@"化验结果",@"临床医嘱",@"编码信息",@"病患数据",@"治疗进度",@"临床任务",@"关于我们", nil];
    }
    if (iconImageArray.count > 0) {
        _iconImageNameArray = [NSMutableArray arrayWithArray:iconImageArray];
    }else{
        _iconImageNameArray = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10", nil];
    }
    
    [self createLikeTabBar];
    // 半透明遮挡层
    _aImageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT- 64)];
    [self.view insertSubview:_aImageview aboveSubview:_tabView];
    self.view.backgroundColor = [UIColor whiteColor];
    _aImageview.backgroundColor = RGBACOLOR(0, 0, 0, 0.7);
    _aImageview.hidden = YES;
    _aImageview.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapIamge = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideImageView:)];
    [_aImageview addGestureRecognizer:tapIamge];
    
    _showView = [[showPersonalInfoView alloc] initWithFrame:CGRectMake(0, - SCREENHEIGHT_INBAR / 3 , SCREENWIDTH, SCREENHEIGHT_INBAR / 3 )];
    _showView.patient = self.topPatient;
    
    [self.view insertSubview:_showView aboveSubview:_aImageview];
}

#pragma mark - 点击遮挡层消失
- (void)hideImageView:(UITapGestureRecognizer *)tap{
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(0);
    [UIView animateWithDuration:0.5 animations:^{
        _animationImageView.transform = endAngle;
    } completion:^(BOOL finished) {
        _aImageview.hidden = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [UIView animateWithDuration:0.3 animations:^{
            _showView.transform = CGAffineTransformMakeTranslation(0, - SCREENHEIGHT_INBAR / 3);
        }];
    }];
    
}
#pragma mark - 编辑状态转换
- (void)editListTableCell:(UIBarButtonItem *)rightBBI{
    if (_listTableView.editing == YES) {
        rightBBI.title = @"编辑";
        _iswiggle = NO;
    }else{
        rightBBI.title = @"完成";
        _iswiggle = YES;
    }
    [_listTableView reloadData];
    [_listTableView setEditing:!_listTableView.editing animated:YES];
}

#pragma mark - tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    DetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DetailsTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
    }
    cell.iconImageView.image = [[ImageManager sharedShower] sourceForResource:[_iconImageNameArray objectAtIndex:indexPath.row] ofType:@"png"];
    cell.listLabel.text = [_listLabelTextArray objectAtIndex:indexPath.row];
    if (_iswiggle == NO) {
        // Cell处于非编辑状态下的布局
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.listLabel.frame = CGRectMake(50, 0, SCREENWIDTH - 50, 50);
        cell.iconImageView.frame = CGRectMake(0, 0, 50, 50);

    }else{
        // Cell处于编辑状态下的布局
        [UIView animateWithDuration:0.0 animations:^{
            cell.iconImageView.frame = CGRectMake(0, 0, 40, 40);
            cell.iconImageView.transform = CGAffineTransformMakeTranslation(-38, 0);
            cell.listLabel.frame = CGRectMake(12, 0, SCREENWIDTH - 12, 50);
        }completion:^(BOOL finished) {
            cell.iconImageView.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
        [self wiggle4view:cell.iconImageView];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailsTableViewCell *cell = (DetailsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell.listLabel.text isEqualToString:@"图表"]) {
        ChartViewController *chartVC = [[ChartViewController alloc] init];
        [self.navigationController pushViewController:chartVC animated:YES];
    }
    if ([cell.listLabel.text isEqualToString:@"文档"]) {
        
    }
    if ([cell.listLabel.text isEqualToString:@"影像"]) {
        ImageVideosTableViewController *imageVideosTVC = [[ImageVideosTableViewController alloc] init];
        [self.navigationController pushViewController:imageVideosTVC animated:YES];
    }
    if ([cell.listLabel.text isEqualToString:@"化验结果"]) {
        TestResultsViewController *testResultsVC = [[TestResultsViewController alloc] init];
        [self.navigationController pushViewController:testResultsVC animated:YES];
    }
    if ([cell.listLabel.text isEqualToString:@"临床医嘱"]) {
        
    }
    if ([cell.listLabel.text isEqualToString:@"编码信息"]) {
        
    }
    if ([cell.listLabel.text isEqualToString:@"病患数据"]) {
        
    }
    if ([cell.listLabel.text isEqualToString:@"治疗进度"]) {
        
    }
    if ([cell.listLabel.text isEqualToString:@"临床任务"]) {
        
    }
    if ([cell.listLabel.text isEqualToString:@"关于我们"]) {
        
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    NSUInteger fromRow = [sourceIndexPath row];
    NSUInteger toRow = [destinationIndexPath row];

    id object = [_listLabelTextArray objectAtIndex:fromRow];
    id objectOth = [_iconImageNameArray objectAtIndex:fromRow];
    
    [_listLabelTextArray removeObjectAtIndex:fromRow];
    [_iconImageNameArray removeObjectAtIndex:fromRow];
    
    [_listLabelTextArray insertObject:object atIndex:toRow];
    [_iconImageNameArray insertObject:objectOth atIndex:toRow];
    
    // 数据归档
    DataArchive *archiveListLable = [[DataArchive alloc] init];
    NSDictionary *dic = @{@"listLabelText":_listLabelTextArray,@"iconImageName":_iconImageNameArray};
    [archiveListLable archiveDetalsShowWithDic:dic];

}

- (void)setExtraCellLineHidden:(UITableView *)tableView{
    UIView *view = [UIView new];
    [tableView setTableFooterView:view];
}

#pragma mark -
#pragma mark - cell wiggle animation
- (void)wiggle4view:(UIView *)aview{
    CALayer *viewLayer = aview.layer;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.1;
    animation.repeatCount = 100000;
    animation.autoreverses = YES;
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DRotate
                           (viewLayer.transform, -0.1, 0.0, 0.0, 0.1)];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DRotate
                         (viewLayer.transform, 0.1, 0.0, 0.0, 0.1)];
    [viewLayer addAnimation:animation forKey:@"wiggle"];
}

#pragma mark -
#pragma mark - custom navigationbarTitle
- (void)createNaviagtionBarTitleView{
    // 计算字符串的宽度
    NSString *text = @"详细信息";
    NSDictionary * attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:19.0],NSFontAttributeName, nil];
    CGSize size  = CGSizeMake(200, 40);
    CGRect tect = [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributeDic context:nil];
    
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - tect.size.width / 2, 0, SCREENWIDTH / 4, 40)];
    aView.backgroundColor = [UIColor clearColor];
    aView.userInteractionEnabled = YES;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = text;
    titleLabel.frame = CGRectMake(0, 0, tect.size.width, 40);
    [aView addSubview:titleLabel];
  
    _animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(tect.size.width, 0,40, 40)];
    _animationImageView.tag = ANIMATIONIMAGEVIEW_DETAILS;
    [aView addSubview:_animationImageView];
    [_animationImageView setBackgroundColor:[UIColor grayColor]];
    
    _animationImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPersonlInfo:)];
    [aView addGestureRecognizer:tap];
    
    self.navigationItem.titleView = aView;
}

#pragma mark -
#pragma mark - custom likeTabBar
- (void)createLikeTabBar{
    _tabView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT_INBAR - 50, SCREENWIDTH, 50)];
    [self.view insertSubview:_tabView aboveSubview:_listTableView];
    _tabView.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(0, 0, 50, 50);
    addButton.backgroundColor = [UIColor yellowColor];
    [addButton addTarget:self action:@selector(addListContect:) forControlEvents:UIControlEventTouchDown];
    [_tabView addSubview:addButton];
    
    UIButton *dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dateButton.frame = CGRectMake(SCREENWIDTH / 2 - 25, 0, 50, 50);
    dateButton.backgroundColor = [UIColor yellowColor];
    [dateButton addTarget:self action:@selector(dateShow:) forControlEvents:UIControlEventTouchDown];
    [_tabView addSubview:dateButton];
    
    UIButton *markButton = [UIButton buttonWithType:UIButtonTypeCustom];
    markButton.frame = CGRectMake(SCREENWIDTH - 50, 0, 50, 50);
    markButton.backgroundColor = [UIColor yellowColor];
    [markButton addTarget:self action:@selector(mark:) forControlEvents:UIControlEventTouchDown];
    [_tabView addSubview:markButton];
    
}

#pragma mark -
#pragma mark - tabBar上的点击事件
- (void)addListContect:(id)sender{
    AddContentViewController *addVC = [[AddContentViewController alloc] init];
    addVC.patientName = self.topPatient.name;
    [self presentViewController:addVC animated:YES completion:^{
        
    }];
}

- (void)dateShow:(id)sender{
    NSLog(@"%s",__FUNCTION__);
 
}

- (void)mark:(id)sender{
    NSLog(@"%s",__FUNCTION__);

}

#pragma mark -
#pragma mark - did click imageview show personal info
- (void)showPersonlInfo:(UITapGestureRecognizer *)tap{
    if (_aImageview.hidden == YES) {
        CGAffineTransform endAngle = CGAffineTransformMakeRotation(M_PI);
        [UIView animateWithDuration:0.5 animations:^{
            _animationImageView.transform = endAngle;
        } completion:^(BOOL finished) {
            _rightBBI.enabled = NO;
            [UIView animateWithDuration:0.5 animations:^{
                _showView.transform = CGAffineTransformMakeTranslation(0, SCREENHEIGHT_INBAR / 3);
            }completion:^(BOOL finished) {
                _aImageview.hidden = NO;
            }];
        }];
    }else{
        CGAffineTransform endAngle = CGAffineTransformMakeRotation(0);
        [UIView animateWithDuration:0.5 animations:^{
            _animationImageView.transform = endAngle;
        } completion:^(BOOL finished) {
            _rightBBI.enabled = YES;
            [UIView animateWithDuration:0.5 animations:^{
                _aImageview.hidden = YES;
                _showView.transform = CGAffineTransformMakeTranslation(0, - SCREENHEIGHT_INBAR / 3);
            }completion:^(BOOL finished) {
            }];
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
