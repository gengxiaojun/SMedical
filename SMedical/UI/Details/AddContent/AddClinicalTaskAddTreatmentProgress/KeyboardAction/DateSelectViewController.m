//
//  DateSelectViewController.m
//  SMedical
//
//  Created by _SS on 14/12/25.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "DateSelectViewController.h"
@interface DateSelectViewController (){
    NSDate *_date;
}
@property (nonatomic, strong) NSString *selectTime;
@end

@implementation DateSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"日期";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *leftBBI = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:(UIBarButtonItemStylePlain) target:self action:@selector(cancelAction:)];
    self.navigationItem.leftBarButtonItem = leftBBI;
    
    UIBarButtonItem *rightBBI = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStylePlain) target:self action:@selector(selectAction:)];
    self.navigationItem.rightBarButtonItem = rightBBI;
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    datePicker.minuteInterval = 5;
    
    NSDate *nowDate = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    [datePicker setDate:nowDate animated:YES];
    
    [self.view addSubview:datePicker];
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:(UIControlEventValueChanged)];
}

- (void)dateChanged:(id)sender{
    UIDatePicker *control = (UIDatePicker *)sender;
    _date = control.date;
}

#pragma mark -
#pragma mark - 获取指定格式的时间
- (NSString *)getSpecifiedDateFormDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy/MM/dd ah:mm"];
    NSString * time = [formatter stringFromDate:date];
    return time;
}

- (void)cancelAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectAction:(id)sender{
    if (_date == nil) {
        UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有选择日期" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alerView show];
    }else{
       self.selectTime =  [self getSpecifiedDateFormDate:_date];
        NSDictionary *info = [[NSDictionary alloc] initWithObjectsAndKeys:self.selectTime,@"time", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showSelectDate" object:nil userInfo:info];
        [self.navigationController popViewControllerAnimated:YES];
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
