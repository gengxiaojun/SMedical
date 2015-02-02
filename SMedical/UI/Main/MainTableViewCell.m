//
//  MainTableViewCell.m
//  SMedical
//
//  Created by _SS on 14/11/24.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "MainTableViewCell.h"
#import "Header.h"
#import "NameManager.h"
#import "ImageManager.h"
@interface MainTableViewCell ()
{
    
}

@property (nonatomic, strong) UIImageView *iCon;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *roomLabel;
@property (nonatomic, strong) UILabel *causeLabel;
@property (nonatomic, strong) UIView *markImageView;

@end

@implementation MainTableViewCell


- (void)awakeFromNib {
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubView];
    }
    return self;
}

- (void)creatSubView{
    self.contentView.backgroundColor = [UIColor clearColor];
    UIView *aView = [[UIView alloc] initWithFrame:self.contentView.frame];
    aView.backgroundColor = RGBACOLOR(223, 239, 249, 1);
    self.selectedBackgroundView = aView;

    self.iCon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH / 4 , 80)];
    [self.contentView addSubview:self.iCon];
    self.iCon.backgroundColor = RGBACOLOR(247, 247, 247, 1);
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 4 + 10, 0, SCREENWIDTH / 4 * 2 - 10, 80 / 3)];
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.font = [UIFont systemFontOfSize:16.0];
    self.nameLabel.textColor = RGBACOLOR(11, 94, 173, 1);
    
    self.causeLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 4 + 10, 80 / 3, SCREENWIDTH / 4 * 2 - 10, 80 / 3)];
    [self.contentView addSubview:self.causeLabel];
    self.causeLabel.font = [UIFont systemFontOfSize:15.0];
    
    self.roomLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 4 + 10, 80 / 3 * 2, SCREENWIDTH / 4 * 2 - 10, 80 / 3)];
    [self.contentView addSubview:self.roomLabel];
    self.roomLabel.font = [UIFont systemFontOfSize:15.0];
    self.roomLabel.alpha = 0.65;
    
    self.markImageView = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH / 4 * 3 + 20 ,80 / 3 , SCREENWIDTH / 4  - 30, 80 / 3 )];
    [self.contentView addSubview:self.markImageView];
    self.markImageView.backgroundColor = [UIColor redColor];

}

- (void)setPatient:(ListPatient *)patient{
    if (patient != _patient) {
        _patient = patient;
    }
    NSString *imageName = [[NameManager sharedShower] letter4name:self.patient.name];
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
    UIImage *iConImage = [[ImageManager sharedShower] scaleToSize:[UIImage imageWithContentsOfFile:imagePath] size:self.iCon.frame.size];
    self.iCon.image = iConImage;
    self.nameLabel.text = self.patient.name;
    self.causeLabel.text = self.patient.cause;
    self.roomLabel.text = self.patient.room;
    if ([self.patient.isWaring isEqualToString:@"0"]) {
        self.markImageView.hidden = YES;
    }else{
        self.markImageView.hidden = NO;
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:self.patient.name]) {
        for (NSString *Str in [[NSUserDefaults standardUserDefaults] objectForKey:self.patient.name]) {
            NSLog(@"%@,%@",self.patient.name,Str);
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
