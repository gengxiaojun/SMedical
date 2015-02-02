//
//  TroubleTableViewCell.m
//  SMedical
//
//  Created by _SS on 14/12/9.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "TroubleTableViewCell.h"
#import "Header.h"

@implementation TroubleTableViewCell

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
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, SCREENWIDTH - 40, (self.frame.size.height - 20) / 2)];
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, (self.frame.size.height - 20) / 2 + 25, SCREENWIDTH - 40, (self.frame.size.height - 20) / 2)];
    
    self.contentLabel.font = [UIFont systemFontOfSize:16.0];
    self.nameLabel.font = [UIFont systemFontOfSize:15.0];
    
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.nameLabel];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
