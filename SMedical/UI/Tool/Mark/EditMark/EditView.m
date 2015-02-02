//
//  EditView.m
//  SMedical
//
//  Created by _SS on 14/12/5.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "EditView.h"
#import "Header.h"
#import "ImageManager.h"
@interface EditView (){
    
}
@property (nonatomic, strong) UIImageView *markView;
@end

@implementation EditView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSubView];
    }
    return self;
}

- (void)createSubView{
    self.backgroundColor = [UIColor whiteColor];
    self.markView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 84, 50, 30)];
    [self addSubview:self.markView];
    
    self.markTextField = [[UITextField alloc] initWithFrame:CGRectMake(70, 84, SCREENWIDTH - 80, 30)];
    [self addSubview:self.markTextField];
    self.markTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

- (void)setMarkModel:(MarkModel *)markModel{
    if (markModel != _markModel) {
        _markModel = markModel;
    }
    NSString *imageName = _markModel.markColor;
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:imageName ofType:@"png"];
    UIImage *iConImage = [[ImageManager sharedShower] scaleToSize:[UIImage imageWithContentsOfFile:imagePath] size:self.markView.frame.size];
    self.markView.image = iConImage;
    self.markTextField.placeholder = _markModel.markInstructions;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
