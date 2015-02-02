//
//  PersonalViewController.m
//  SMedical
//
//  Created by _SS on 14/12/2.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "PersonalViewController.h"
#import "PersonalBackView.h"
#import "Header.h"

#import "DataManager.h"
#import "ImageManager.h"
#import "JSONDataManager.h"

#import "ListPatient.h"

#import "TroubleTableViewCell.h"
#import "DocumentTableViewCell.h"
#import "ImageTableViewCell.h"
#import "ShowTableViewCell.h"

#import "MarkTableViewController.h"

#import "DetailsViewController.h"

#import "PersonalImageViewController.h"
#import "PersonalDocumentViewController.h"

@interface PersonalViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *_troubleContentArray;
    NSArray *_troubleNameArray;
    
    NSArray *_documentNameArray;
    NSArray *_documentNoteArray;
    
    NSArray *_imageNameArray;
    NSArray *_imageNoteArray;
    
    NSArray *_doctorAdviceArray;

    NSArray *_treatmentProgressArray;
    
    NSMutableArray *_clinicalTaskArray;
    
}
@property (nonatomic, strong) PersonalBackView *perView;
@property (nonatomic, strong) NSMutableArray *sectionsArray;
@property (nonatomic, strong) ListPatient *patient;
@end

@implementation PersonalViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.patientName;
    self.view.backgroundColor = [UIColor whiteColor];

    if ([self.title isEqualToString:@"我的病患"] || [self.title isEqualToString:@"我关注的病患"]) {
        self.navigationItem.leftBarButtonItem.title = self.title;
    }else{
        self.navigationItem.leftBarButtonItem.title = @"返回";
    }

#pragma mark - 关注按钮图片
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mark_focus" ofType:@"png"];
    UIBarButtonItem *rightBBI = [[UIBarButtonItem alloc] initWithImage:[[ImageManager sharedShower] scaleToSize:[UIImage imageWithContentsOfFile:filePath] size:CGSizeMake(30, 30)] style:UIBarButtonItemStyleDone target:self action:@selector(mark:)];
    self.navigationItem.rightBarButtonItem = rightBBI;
    self.perView = [[PersonalBackView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:self.perView ];
    
    self.perView.personalTable.delegate = self;
    self.perView.personalTable.dataSource = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(interDetailsView:)];
    [self.perView.topView addGestureRecognizer:tap];
    
    self.sectionsArray = [[NSMutableArray alloc] initWithObjects:@"过敏药物或风险因素",@"图表",@"文档",@"影像",@"化验结果",@"临床医嘱",@"编码信息",@"病患数据",@"治疗进度",@"临床任务", nil];

    // PersonalData
    NSMutableArray *patients = [NSMutableArray array];
    NSMutableArray *mArray = [[DataManager shareInstance] selectPatientWithName:self.patientName];
    for (NSDictionary *dic in mArray) {
        self.patient = [[ListPatient alloc] initPersonalViewWithDic:dic];
        [patients addObject:self.patient];
    }
    if (patients.count == 1) {
        self.perView.patient = [patients firstObject];
    }else{
        
    }

    // _troubleData
    NSDictionary *troubleDic = [[JSONDataManager shareInstance] troubleInfoWithName:self.patientName];
    _troubleContentArray = [troubleDic  allValues];
    _troubleNameArray = [troubleDic allKeys];
    
    // _documentData
    NSDictionary *documentDic = [[JSONDataManager shareInstance] documentInfoWithName:self.patientName];
    _documentNameArray = [documentDic allKeys];
    _documentNoteArray = [documentDic allValues];
    
    // _ImageData
    NSDictionary *imageDic = [[JSONDataManager shareInstance] imageInfoWithName:self.patientName];
    _imageNameArray = [imageDic allKeys];
    _imageNoteArray = [imageDic allValues];
    
    //_doctorAdviceDate
    _doctorAdviceArray = [[JSONDataManager shareInstance] doctorAdciceInfoWithName:self.patientName];
    
    //_treatmentProgressDate
    _treatmentProgressArray = [[JSONDataManager shareInstance] treatmentProgressInfoWithName:self.patientName];

    //_clinicalTaskDate
    NSDictionary *clinicalTaskDic = [[JSONDataManager shareInstance] clinicalTaskInfoWithName:self.patientName];
    _clinicalTaskArray = [clinicalTaskDic objectForKey:@"unhandle"];

}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.perView.selectView.hidden = YES;
}

- (void)interDetailsView:(UITapGestureRecognizer *)tap{
    // click effect
    self.perView.selectView.hidden = NO;
   
    DetailsViewController *detailsView = [[DetailsViewController alloc] init];
    detailsView.topPatient = self.patient;
    [self.navigationController pushViewController:detailsView animated:YES];
}

- (void)mark:(id)sender{
    MarkTableViewController *markTVC = [[MarkTableViewController alloc] init];
    markTVC.personName = self.navigationItem.title;
    UINavigationController *markNC = [[UINavigationController alloc] initWithRootViewController:markTVC];
    [self presentViewController:markNC animated:YES completion:^{
    }];
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
    titleLabel.text = [self tableView:self.perView.personalTable titleForHeaderInSection:section];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [myView addSubview:titleLabel];
    return myView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.sectionsArray objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[self tableView:self.perView.personalTable titleForHeaderInSection:indexPath.section] isEqualToString:@"影像"]) {
        return 80;
    }else{
        return 60;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[self tableView:self.perView.personalTable titleForHeaderInSection:section] isEqualToString:@"过敏药物或风险因素"]) {
        return _troubleNameArray.count;
    }
    if ([[self tableView:self.perView.personalTable titleForHeaderInSection:section] isEqualToString:@"文档"]) {
        return _documentNameArray.count;
    }
    if ([[self tableView:self.perView.personalTable titleForHeaderInSection:section] isEqualToString:@"临床任务"]) {
        return _clinicalTaskArray.count;
    }
    if ([[self tableView:self.perView.personalTable titleForHeaderInSection:section] isEqualToString:@"临床医嘱"]) {
        return _doctorAdviceArray.count;
    }
    if ([[self tableView:self.perView.personalTable titleForHeaderInSection:section] isEqualToString:@"治疗进度"]) {
        return _treatmentProgressArray.count;
    }
    if ([[self tableView:self.perView.personalTable titleForHeaderInSection:section] isEqualToString:@"影像"]) {
        return _imageNameArray.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[self tableView:self.perView.personalTable titleForHeaderInSection:indexPath.section] isEqualToString:@"过敏药物或风险因素"]) {
        static NSString *identifier = @"troubleTableViewCell";
        TroubleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[TroubleTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        cell.contentLabel.text = [_troubleContentArray objectAtIndex:indexPath.row];
        cell.nameLabel.text = [_troubleNameArray objectAtIndex:indexPath.row];
        
        if ([cell.contentLabel.text isEqualToString:@"所选期间没有可用数据"]) {
            cell.contentLabel.alpha = 0.65;
        }else{
            cell.contentLabel.textColor = RGBACOLOR(11, 94, 173, 1);
            cell.contentLabel.alpha = 1.0;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if ([[self tableView:self.perView.personalTable titleForHeaderInSection:indexPath.section] isEqualToString:@"临床医嘱"]) {
        static NSString *identifier = @"doctorAdviceTableViewCell";
        ShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ShowTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dic in _doctorAdviceArray) {
            ShowModel *doctorAdviceModle = [[ShowModel alloc] initDoctorAdviceInfoWithDic:dic];
            [dataArray addObject:doctorAdviceModle];
        }
        cell.doctorAdviceModel = [dataArray objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if ([[self tableView:self.perView.personalTable titleForHeaderInSection:indexPath.section] isEqualToString:@"治疗进度"]) {
        static NSString *identifier = @"treatmentProgressTableViewCell";
        ShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ShowTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dic in _treatmentProgressArray) {
            ShowModel *doctorAdviceModle = [[ShowModel alloc] initDoctorAdviceInfoWithDic:dic];
            [dataArray addObject:doctorAdviceModle];
        }
        cell.treatmentProgressModel = [dataArray objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if ([[self tableView:self.perView.personalTable titleForHeaderInSection:indexPath.section] isEqualToString:@"临床任务"]) {
        static NSString *identifier = @"clinicalTaskTableViewCell";
        ShowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ShowTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dic in _clinicalTaskArray) {
            ShowModel *doctorAdviceModle = [[ShowModel alloc] initClinicalTaskInfoWithDic:dic];
            [dataArray addObject:doctorAdviceModle];
        }
        cell.clinicalTaskModel = [dataArray objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if ([[self tableView:self.perView.personalTable titleForHeaderInSection:indexPath.section] isEqualToString:@"文档"]) {
        static NSString *identifier = @"documentTableViewCell";
        DocumentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[DocumentTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dic in _documentNoteArray) {
            ShowModel *documentModle = [[ShowModel alloc] initDocumentInfoWithDic:dic];
            [dataArray addObject:documentModle];
        }
        cell.documentModel = [dataArray objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    if ([[self tableView:self.perView.personalTable titleForHeaderInSection:indexPath.section] isEqualToString:@"影像"]) {
        static NSString *identifier = @"imageTableViewCell";
        ImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ImageTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        }
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSDictionary *dic in _imageNoteArray) {
            ShowModel *ImageModle = [[ShowModel alloc] initImageInfoWithDic:dic];
            [dataArray addObject:ImageModle];
        }
        cell.imageModel = [dataArray objectAtIndex:indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[self tableView:self.perView.personalTable titleForHeaderInSection:indexPath.section] isEqualToString:@"影像"]) {
        ImageTableViewCell *cell = (ImageTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        PersonalImageViewController *psonImageVC = [[PersonalImageViewController alloc] init];
        psonImageVC.imageModel = cell.imageModel;
        [self.navigationController pushViewController:psonImageVC animated:YES];
    }
    if ([[self tableView:self.perView.personalTable titleForHeaderInSection:indexPath.section] isEqualToString:@"文档"]) {
        DocumentTableViewCell *cell = (DocumentTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        PersonalDocumentViewController *psonDocumentVC = [[PersonalDocumentViewController alloc] init];
        psonDocumentVC.documentModel = cell.documentModel;
        [self.navigationController pushViewController:psonDocumentVC animated:YES];
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
