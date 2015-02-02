//
//  ShowTableViewCell.m
//  SMedical
//
//  Created by _SS on 14/12/11.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "ShowTableViewCell.h"
#import "Header.h"
@interface ShowTableViewCell (){
    
}

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UILabel *stateLabel;
@end

@implementation ShowTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createSubView];
    }
    return self;
}

- (void)createSubView{
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, (SCREENWIDTH - 30) / 2 , (self.frame.size.height - 20) / 2)];
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 + (SCREENWIDTH - 30) / 2, 10, (SCREENWIDTH - 30) / 2, (self.frame.size.height - 20) / 2)];
    self.stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10 + (self.frame.size.height - 20) / 2 + 15, (SCREENWIDTH - 30) / 2 , (self.frame.size.height - 20) / 2)];
    self.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 + (SCREENWIDTH - 30) / 2, 10 + (self.frame.size.height - 20) / 2 + 15, (SCREENWIDTH - 30) / 2, (self.frame.size.height - 20) / 2)];
    
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    self.categoryLabel.textAlignment = NSTextAlignmentRight;
    self.nameLabel.textColor = RGBACOLOR(11, 94, 173, 1);
    self.nameLabel.font = [UIFont systemFontOfSize:16.0];
    self.dateLabel.font = [UIFont systemFontOfSize:16.0];
    self.stateLabel.font = [UIFont systemFontOfSize:15.0];
    self.categoryLabel.font = [UIFont systemFontOfSize:15.0];

    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.categoryLabel];
    [self.contentView addSubview:self.stateLabel];
}

- (void)setTreatmentProgressModel:(ShowModel *)treatmentProgressModel{
    if (treatmentProgressModel != _treatmentProgressModel) {
        _treatmentProgressModel = treatmentProgressModel;
    }
    self.nameLabel.text = self.treatmentProgressModel.name;
    self.dateLabel.text = self.treatmentProgressModel.date;
    self.categoryLabel.text = self.treatmentProgressModel.category;
    self.stateLabel.text = self.treatmentProgressModel.state;
}

- (void)setClinicalTaskModel:(ShowModel *)clinicalTaskModel{
    if (clinicalTaskModel != _clinicalTaskModel) {
        _clinicalTaskModel = clinicalTaskModel;
    }
    self.nameLabel.text = self.clinicalTaskModel.name;
    self.dateLabel.text = self.clinicalTaskModel.date;
    NSString *categoryStr = self.clinicalTaskModel.state;
    NSString *labelStr = [[categoryStr componentsSeparatedByString:@","] firstObject];
    self.stateLabel.text = labelStr;
    self.categoryLabel.text = @"未处理";
    
}

- (void)setDoctorAdviceModel:(ShowModel *)doctorAdviceModel{
    if (doctorAdviceModel != _doctorAdviceModel) {
        _doctorAdviceModel = doctorAdviceModel;
    }
    self.nameLabel.text = self.doctorAdviceModel.name;
    self.dateLabel.text = self.doctorAdviceModel.date;
    NSString *categoryStr = self.doctorAdviceModel.category;
    NSString *labelText = [[categoryStr componentsSeparatedByString:@"+"] firstObject];
    self.stateLabel.text = labelText;
    self.categoryLabel.text = self.doctorAdviceModel.state;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
