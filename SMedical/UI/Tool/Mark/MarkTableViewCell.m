//
//  MarkTableViewCell.m
//  SMedical
//
//  Created by _SS on 14/12/4.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "MarkTableViewCell.h"
#import "Header.h"

@interface MarkTableViewCell (){
    
}
@property (nonatomic, strong) UIImageView *markImage;
@property (nonatomic, strong) UILabel *instructionsLabel;

@end
@implementation MarkTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubView];
    }
    return self;
}

- (void)creatSubView{
    self.markImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 30)];
    self.instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 5,SCREENWIDTH - 80 , 30)];
    [self.contentView addSubview:self.markImage];
    [self.contentView addSubview:self.instructionsLabel];
}

- (void)setMarkModel:(MarkModel *)markModel{
    if (markModel != _markModel){
        _markModel = markModel;
    }
    self.markImage.image = [UIImage imageNamed:self.markModel.markColor];
    self.instructionsLabel.text = self.markModel.markInstructions;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
