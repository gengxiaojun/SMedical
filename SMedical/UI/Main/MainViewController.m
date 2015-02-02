//
//  MainViewController.m
//  SMedical
//
//  Created by _SS on 14/11/24.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "MainViewController.h"
#import "Header.h"

#import "MainTableViewCell.h"
#import "MainSubView.h"

#import "DataManager.h"
#import "ListPatient.h"

#import "SelectListTableViewController.h"
#import "PersonalViewController.h"

@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    NSMutableArray *_patientArray;
}

@property (nonatomic, strong) MainSubView *subView;
@property (nonatomic, strong, readwrite) UISearchDisplayController *searchCtr;

@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) NSArray *famousPersons; // 搜索结果数据
@property (nonatomic, strong) NSMutableDictionary *patientListDic;

@end

@implementation MainViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SelectRoomA" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SelectRoomB" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SelectMyPatients" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SelectMyFocus" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloaData" object:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // navigationBar
    self.patientListDic = [[NSMutableDictionary alloc] init];
    self.famousPersons = [[NSArray alloc] init];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = RGBACOLOR(245, 245, 245, 1);

    UIBarButtonItem *leftBBI = [[UIBarButtonItem alloc] initWithTitle:@"登出" style:(UIBarButtonItemStylePlain) target:self action:@selector(logout:)];
    self.navigationItem.leftBarButtonItem = leftBBI;
    
    UIBarButtonItem *rightBBI = [[UIBarButtonItem alloc] initWithTitle:@"列表" style:(UIBarButtonItemStylePlain) target:self action:@selector(showSelectionList:)];
    self.navigationItem.rightBarButtonItem = rightBBI;
    
    self.subView = [[MainSubView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view = self.subView;
    self.subView.listTableView.delegate = self;
    self.subView.listTableView.dataSource = self;
    self.subView.listTableView.tag = TABLEVIEW_MAIN;
    
    self.searchCtr = [[UISearchDisplayController alloc] initWithSearchBar:self.subView.searchBar contentsController:self];
    self.searchCtr.delegate = self;
    self.searchCtr.searchResultsDataSource = self;
    self.searchCtr.searchResultsDelegate = self;
    [self setExtraCellLineHidden:self.searchCtr.searchResultsTableView];

    [self.subView.segmentCtr addTarget:self action:@selector(didClickSegmentedControlAction:) forControlEvents:(UIControlEventValueChanged)];

    self.navigationItem.title = @"我的病房-病房A";

    _patientArray = [[DataManager shareInstance] selectPatientWithRoomA];
    for (NSDictionary *dic in _patientArray) {
        ListPatient *listPatient = [[ListPatient alloc] initMainViewWithDic:dic];
        [self.patientListDic setObject:listPatient forKey:listPatient.name];
        
    }
    [self sectionIndexes4Info:self.patientListDic];

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"mark"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataNotification:) name:@"SelectRoomA" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataNotification:) name:@"SelectRoomB" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataNotification:) name:@"SelectMyPatients" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDataNotification:) name:@"SelectMyFocus" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDatas) name:@"reloaData" object:nil];
}

- (void)setExtraCellLineHidden:(UITableView *)tableView{
    UIView *view = [UIView new];
    view.backgroundColor = RGBACOLOR(247, 247, 247, 1);
    [tableView setTableFooterView:view];
}

- (void)reloadDatas{
    [self.subView.listTableView reloadData];
}

- (void)handleDataNotification:(NSNotification *)notification{
    [self.patientListDic removeAllObjects];
    
    NSDictionary *info = notification.userInfo;
    if ([notification.name isEqualToString:@"SelectRoomA"]) {
        _patientArray = [info valueForKey:@"data"];
        self.navigationItem.title = [info valueForKey:@"title"];
    }
    if ([notification.name isEqualToString:@"SelectRoomB"]) {
        _patientArray = [info valueForKey:@"data"];
        self.navigationItem.title = [info valueForKey:@"title"];
    }
    if ([notification.name isEqualToString:@"SelectMyPatients"]) {
        _patientArray = [info valueForKey:@"data"];
        self.navigationItem.title = [info valueForKey:@"title"];
    }
    if ([notification.name isEqualToString:@"SelectMyFocus"]) {
        _patientArray = [info valueForKey:@"data"];
        self.navigationItem.title = [info valueForKey:@"title"];
    }
    for (NSDictionary *dic in _patientArray) {
        ListPatient *listPatient = [[ListPatient alloc] initMainViewWithDic:dic];
        [self.patientListDic setObject:listPatient forKey:listPatient.name];
    }
    [self sectionIndexes4Info:self.patientListDic];
    [self.subView.listTableView reloadData];
}

- (void)sectionIndexes4Info:(NSMutableDictionary *)info{
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    NSMutableArray *unSortedSections = [[NSMutableArray alloc] initWithCapacity:[[collation sectionTitles] count]];
    for (NSUInteger i = 0; i < [[collation sectionTitles] count]; i++) {
        [unSortedSections addObject:[NSMutableArray array]];
    }
    for (NSString *patientName in [info allKeys]) {
        NSInteger index = [collation sectionForObject:patientName collationStringSelector:@selector(description)];
        ListPatient *patient = [info objectForKey:patientName];
        [[unSortedSections objectAtIndex:index] addObject:patient];
    }
    NSMutableArray *sortedSections = [[NSMutableArray alloc] initWithCapacity:unSortedSections.count];
    for (NSMutableArray *section in unSortedSections) {
        [sortedSections addObject:[collation sortedArrayFromArray:section collationStringSelector:@selector(description)]];
    }
    self.sections = sortedSections;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.subView.segmentCtr.selectedSegmentIndex = 0;
}

- (void)logout:(id)sender{
    
}

- (void)showSelectionList:(id)sender{
    SelectListTableViewController *selectListTVC = [[SelectListTableViewController alloc] init];
    UINavigationController *selectListNC = [[UINavigationController alloc] initWithRootViewController:selectListTVC];
    [self presentViewController:selectListNC animated:YES completion:^{
        
    }];
}

#pragma mark -
#pragma mark - searchBar 设置
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    [self.patientListDic removeAllObjects];
    NSArray * selectArray;
    _patientArray = [[DataManager shareInstance] selectAllPatients];
    for (NSDictionary *dic in _patientArray) {
        selectArray = @[[dic objectForKey:@"name"],[dic objectForKey:@"room"]];
        if ([selectArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchString]].count > 0) {
            ListPatient *patient = [[ListPatient alloc] initMainViewWithDic:dic];
            [self.patientListDic setObject:patient forKey:patient.name];
            [self sectionIndexes4Info:self.patientListDic];
            self.famousPersons = self.sections;
        }else{
        }
    }
        return YES;
}

#pragma mark -
#pragma mark - tableView设置
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* myView = [[UIView alloc] init];
    myView.layer.borderWidth = 0.5;
    myView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    myView.backgroundColor = RGBACOLOR(247, 247, 247, 1);
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 30)];
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    if (tableView.tag == TABLEVIEW_MAIN) {
        titleLabel.text = [self tableView:self.subView.listTableView titleForHeaderInSection:section];
    }else{
        titleLabel.text = [self tableView:self.searchCtr.searchResultsTableView titleForHeaderInSection:section];
    }
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [myView addSubview:titleLabel];
    return myView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView.tag == TABLEVIEW_MAIN) {
        if ([[self.sections objectAtIndex:section] count] > 0) {
            return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
        }else{
            return nil;
        }
    }else{
        if ([[self.famousPersons objectAtIndex:section] count] > 0) {
            return [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section];
        }else{
            return nil;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == TABLEVIEW_MAIN) {
        return self.sections.count;
    }else{
        return self.famousPersons.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == TABLEVIEW_MAIN) {
        return [[self.sections objectAtIndex:section] count];
    }else{
        return [[self.famousPersons objectAtIndex:section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[MainTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
    if (tableView.tag == TABLEVIEW_MAIN) {
        NSArray *sectionArray = [self.sections objectAtIndex:indexPath.section];
        ListPatient *patient = [sectionArray objectAtIndex:indexPath.row];
        patient.focus = [[NSUserDefaults standardUserDefaults] objectForKey:patient.name];
        cell.patient = patient;
    }else{
        NSArray *sectionArray = [self.famousPersons objectAtIndex:indexPath.section];
        ListPatient *patient = [sectionArray objectAtIndex:indexPath.row];
        patient.focus = [[NSUserDefaults standardUserDefaults] objectForKey:patient.name];
        cell.patient = patient;
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PersonalViewController *personalVC = [[PersonalViewController alloc] init];
    MainTableViewCell * cell =(MainTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    personalVC.patientName = cell.patient.name;
    personalVC.title = self.navigationItem.title;
    [self.navigationController pushViewController:personalVC animated:YES];
}

- (void)didClickSegmentedControlAction:(UISegmentedControl *)segmentControl{
    switch (segmentControl.selectedSegmentIndex) {
        case 0:
        {
            [self.patientListDic removeAllObjects];
            for (NSDictionary *dic in _patientArray) {
                ListPatient *listPatient = [[ListPatient alloc] initMainViewWithDic:dic];
                [self.patientListDic setObject:listPatient forKey:listPatient.name];
            }
            [self sectionIndexes4Info:self.patientListDic];
            [self.subView.listTableView reloadData];
        }
            break;
        case 1:
        {
            [self.patientListDic removeAllObjects];
            for (NSDictionary *dic in _patientArray) {
                if ([[dic objectForKey:@"isBussesInsurance"]isEqualToString:@"1"]) {
                    ListPatient *listPatient = [[ListPatient alloc] initMainViewWithDic:dic];
                    [self.patientListDic setObject:listPatient forKey:listPatient.name];
                }
            }
            [self sectionIndexes4Info:self.patientListDic];
            [self.subView.listTableView reloadData];
        }
            break;
        case 2:
        {
            [self.patientListDic removeAllObjects];
            for (NSDictionary *dic in _patientArray) {
                if ([[dic objectForKey:@"isWarning"]isEqualToString:@"1"]) {
                    ListPatient *listPatient = [[ListPatient alloc] initMainViewWithDic:dic];
                    [self.patientListDic setObject:listPatient forKey:listPatient.name];
                }
            }
            [self sectionIndexes4Info:self.patientListDic];
            [self.subView.listTableView reloadData];
        }
            break;
        case 3:
        {
            [self.patientListDic removeAllObjects];
            for (NSDictionary *dic in _patientArray) {
                if ([dic objectForKey:@"noTask"]) {
                }else{
                    ListPatient *listPatient = [[ListPatient alloc] initMainViewWithDic:dic];
                    [self.patientListDic setObject:listPatient forKey:listPatient.name];
                }
            }
            [self sectionIndexes4Info:self.patientListDic];
            [self.subView.listTableView reloadData];
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
