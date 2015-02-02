//
//  DetailsTableViewCell.m
//  SMedical
//
//  Created by _SS on 14/12/16.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "DetailsTableViewCell.h"
#import "Header.h"
@implementation DetailsTableViewCell

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
    self.contentView.backgroundColor = [UIColor clearColor];
    UIView *aView = [[UIView alloc] initWithFrame:self.contentView.frame];
    aView.backgroundColor = RGBACOLOR(223, 239, 249, 1);
    self.selectedBackgroundView = aView;
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self.contentView addSubview:self.iconImageView];
    
    self.listLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, SCREENWIDTH - 50, 50)];
    [self.contentView addSubview:self.listLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
