//
//  ImageTableViewCell.m
//  SMedical
//
//  Created by _SS on 14/12/10.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "ImageTableViewCell.h"
#import "Header.h"
@interface ImageTableViewCell (){
    
}
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UILabel *useLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@end
@implementation ImageTableViewCell

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
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, (SCREENWIDTH - 50) / 2 , (self.frame.size.height - 10) / 3)];
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 + (SCREENWIDTH - 50) / 2, 10, (SCREENWIDTH - 50) / 2, (self.frame.size.height - 10) / 3)];
    self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10 + (self.frame.size.height - 10) / 3 + 15, (SCREENWIDTH - 50) / 2 , (self.frame.size.height - 10) / 3)];
    self.useLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 + (SCREENWIDTH - 50) / 2, 10 + (self.frame.size.height - 20) / 2 + 15, (SCREENWIDTH - 50) / 2, (self.frame.size.height - 10) / 3)];
    self.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10 + (self.frame.size.height - 10) / 3 + 25 + (self.frame.size.height - 10) / 3, SCREENWIDTH - 50, (self.frame.size.height - 10) / 3)];

    self.useLabel.textAlignment = NSTextAlignmentRight;
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    self.nameLabel.font = [UIFont systemFontOfSize:16.0];
    self.dateLabel.font = [UIFont systemFontOfSize:16.0];
    self.numberLabel.font = [UIFont systemFontOfSize:15.0];
    self.useLabel.font = [UIFont systemFontOfSize:15.0];
    self.categoryLabel.font = [UIFont systemFontOfSize:15.0];
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.categoryLabel];
    [self.contentView addSubview:self.useLabel];
    [self.contentView addSubview:self.numberLabel];
    
    self.nameLabel.textColor = RGBACOLOR(11, 94, 173, 1);
}

- (void)setImageModel:(ShowModel *)imageModel{
    if (imageModel != _imageModel) {
        _imageModel = imageModel;
    }
    self.nameLabel.text = self.imageModel.name;
    self.dateLabel.text = self.imageModel.date;
    self.categoryLabel.text = self.imageModel.category;
    self.useLabel.text = self.imageModel.use;
    self.numberLabel.text = [[NSString alloc] initWithFormat:@"已选用%@张影像",self.imageModel.number];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
