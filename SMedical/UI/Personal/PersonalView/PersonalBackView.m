//
//  PersonalBackView.m
//  SMedical
//
//  Created by _SS on 14/12/15.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "PersonalBackView.h"
#import "Header.h"

#import "NameManager.h"
#import "ImageManager.h"

@interface PersonalBackView ()
{
    
}
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *nameLable;
@property (nonatomic, strong) UILabel *ageAndBloodType;
@property (nonatomic, strong) UILabel *birthDate;
@property (nonatomic, strong) UILabel *warning;
@property (nonatomic, strong) UILabel *diagnosis;
@property (nonatomic, strong) UILabel *bussesInsurance;

@property (nonatomic, strong) UILabel *causeLabel;
@property (nonatomic, strong) UILabel *othLable;
@property (nonatomic, strong) UIView *tableHeaderView;
@end

@implementation PersonalBackView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.scrollEnabled = NO;
        [self createSubView];
    }
    return self;
}

- (void)createSubView{
    
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT_INBAR / 3)];
    self.topView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.topView];
    
    self.selectView = [[UIView alloc] initWithFrame:self.topView.frame];
    self.selectView.backgroundColor = RGBACOLOR(223, 239, 249, 1);
    self.selectView.hidden = YES;
    [self.topView addSubview:self.selectView];

    self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT_INBAR / 6)];
    self.tableHeaderView.backgroundColor = [UIColor clearColor];
    
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, SCREENHEIGHT_INBAR / 6, SCREENHEIGHT_INBAR / 6)];
    self.icon.backgroundColor = [UIColor yellowColor];
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 5.0;
    self.icon.layer.borderWidth = 0.5;
    self.icon.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.topView addSubview:self.icon];
    
    self.nameLable = [[UILabel alloc] initWithFrame:CGRectMake(20 + SCREENHEIGHT_INBAR / 6, 10, SCREENWIDTH - 20 - SCREENHEIGHT_INBAR / 6 - 80, SCREENHEIGHT_INBAR / 18)];
    [self.topView addSubview:self.nameLable];
    
    self.ageAndBloodType = [[UILabel alloc] initWithFrame:CGRectMake(20 + SCREENHEIGHT_INBAR / 6, 10 + SCREENHEIGHT_INBAR / 18, SCREENWIDTH - 20 - SCREENHEIGHT_INBAR / 6 - 80, SCREENHEIGHT_INBAR / 18)];
    [self.topView addSubview:self.ageAndBloodType];
    
    self.birthDate = [[UILabel alloc] initWithFrame:CGRectMake(20 + SCREENHEIGHT_INBAR / 6, 10 + SCREENHEIGHT_INBAR / 18 + SCREENHEIGHT_INBAR / 18, SCREENWIDTH - 20 - SCREENHEIGHT_INBAR / 6 - 80, SCREENHEIGHT_INBAR / 18 )];
    [self.topView addSubview:self.birthDate];
    
    self.warning = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - 60, 15 , 50, SCREENHEIGHT_INBAR / 18-10)];
    self.warning.text = @"!";
    [self set4Label:self.warning];
    self.warning.backgroundColor = RGBACOLOR(250, 0, 45, 1);
    [self.topView addSubview:self.warning];
    
    self.diagnosis = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - 60, 15 + SCREENHEIGHT_INBAR / 18, 50, SCREENHEIGHT_INBAR / 18 - 10)];
    [self set4Label:self.diagnosis];
    self.diagnosis.text = @"诊断";
    [self.topView addSubview:self.diagnosis];
    
    self.bussesInsurance = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - 60, 15 + SCREENHEIGHT_INBAR / 18 + SCREENHEIGHT_INBAR / 18, 50, SCREENHEIGHT_INBAR / 18 - 10)];
    [self set4Label:self.bussesInsurance];
    self.bussesInsurance.text = @"P";
    self.bussesInsurance.backgroundColor = RGBACOLOR(83, 83, 83, 1);
    [self.topView addSubview:self.bussesInsurance];
    
    self.causeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + SCREENHEIGHT_INBAR / 6, SCREENWIDTH, SCREENHEIGHT_INBAR / 12)];
    [self.topView addSubview:self.causeLabel];
    
    self.othLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 10 + SCREENHEIGHT_INBAR / 6 + SCREENHEIGHT_INBAR / 12, SCREENWIDTH, SCREENHEIGHT_INBAR / 12)];
    [self.topView addSubview:self.othLable];
    
    self.personalTable = [[UITableView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT_INBAR / 6 + 10, SCREENWIDTH, SCREENHEIGHT_INBAR  - SCREENHEIGHT_INBAR / 6 - 11)];
    self.personalTable.backgroundColor = [UIColor clearColor];
    [self addSubview:self.personalTable];
    self.personalTable.tableHeaderView = self.tableHeaderView;
    self.personalTable.separatorInset = UIEdgeInsetsZero;
    
}

- (void)set4Label:(UILabel *)label{
    label.layer.masksToBounds = YES;
    label.layer.cornerRadius = 5.0;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
}

- (void)setPatient:(ListPatient *)patient{
    if (patient != _patient) {
        _patient = patient;
    }
    NSString *imagePath = [[NameManager sharedShower] letter4name:self.patient.name];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:imagePath ofType:@"jpg"];
    UIImage *iConImage = [[ImageManager sharedShower] scaleToSize:[UIImage imageWithContentsOfFile:filePath] size:self.icon.frame.size];
    self.icon.image = iConImage;
    
    self.nameLable.text = self.patient.name;
    self.nameLable.textColor = RGBACOLOR(11, 94, 173, 1);
    
    self.ageAndBloodType.text = [[NSString alloc] initWithFormat:@"%@岁 | %@",self.patient.age,self.patient.bloodType];
    self.ageAndBloodType.font = [UIFont systemFontOfSize:15.0];
    
    self.birthDate.text = self.patient.birthDate;
    self.birthDate.font = [UIFont systemFontOfSize:15.0];
    
    if ([patient.isWaring isEqualToString:@"1"]) {
        self.warning.hidden = NO;
    }else{
        self.warning.hidden = YES;
    }
    if ([patient.isBussesInsurance isEqualToString:@"1"]) {
        self.bussesInsurance.hidden = NO;
    }else{
        self.bussesInsurance.hidden = YES;
    }
    if ([self.patient.isDiagnosis isEqualToString:@"green"]) {
        self.diagnosis.backgroundColor = RGBACOLOR(17, 115, 39, 1);
    }
    if ([self.patient.isDiagnosis isEqualToString:@"red"]) {
        self.diagnosis.backgroundColor = RGBACOLOR(250, 0, 44, 1);
    }
    if ([self.patient.isDiagnosis isEqualToString:@"yellow"]) {
        self.diagnosis.backgroundColor = RGBACOLOR(237, 156, 11, 1);
    }
    self.causeLabel.text = self.patient.cause;
    self.causeLabel.font = [UIFont systemFontOfSize:16.0];
    self.othLable.text = [[NSString alloc] initWithFormat:@"%@ / 入院时间:%@  / 住院天数:%@",self.patient.room,self.patient.admissionDate,self.patient.stayDate];
    self.othLable.font = [UIFont systemFontOfSize:15.0];
    self.othLable.alpha = 0.65;
}

@end
