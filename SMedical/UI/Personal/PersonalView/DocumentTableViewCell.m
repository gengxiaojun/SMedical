//
//  DocumentTableViewCell.m
//  SMedical
//
//  Created by _SS on 14/12/10.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "DocumentTableViewCell.h"
#import "Header.h"
@interface DocumentTableViewCell (){
    
}

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *categoryLabel;
@property (nonatomic, strong) UILabel *useLabel;
@end

@implementation DocumentTableViewCell

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
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, (SCREENWIDTH - 50) / 2 , (self.frame.size.height - 20) / 2)];
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 + (SCREENWIDTH - 50) / 2, 10, (SCREENWIDTH - 50) / 2, (self.frame.size.height - 20) / 2)];
    self.categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10 + (self.frame.size.height - 20) / 2 + 15, (SCREENWIDTH - 50) / 2 , (self.frame.size.height - 20) / 2)];
    self.useLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 + (SCREENWIDTH - 50) / 2, 10 + (self.frame.size.height - 20) / 2 + 15, (SCREENWIDTH - 50) / 2, (self.frame.size.height - 20) / 2)];
    
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    self.useLabel.textAlignment = NSTextAlignmentRight;
    self.nameLabel.font = [UIFont systemFontOfSize:16.0];
    self.dateLabel.font = [UIFont systemFontOfSize:16.0];
    self.categoryLabel.font = [UIFont systemFontOfSize:15.0];
    self.useLabel.font = [UIFont systemFontOfSize:15.0];

    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.categoryLabel];
    [self.contentView addSubview:self.useLabel];

    self.nameLabel.textColor = RGBACOLOR(11, 94, 173, 1);
}

- (void)setDocumentModel:(ShowModel *)documentModel{
    if (documentModel != _documentModel) {
        _documentModel = documentModel;
    }
    self.nameLabel.text = self.documentModel.name;
    self.dateLabel.text = self.documentModel.date;
    self.categoryLabel.text = self.documentModel.category;
    self.useLabel.text = self.documentModel.use;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
