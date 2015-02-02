//
//  AddScrollView.m
//  SMedical
//
//  Created by _SS on 14/12/23.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "AddScrollView.h"
#import "Header.h"
@interface AddScrollView (){
    UILabel *_markLabel;
}

@end

@implementation AddScrollView
- (instancetype)initAddClinicalTaskViewWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createClinicalTask];
        [self createSameView];
        self.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    }
    return self;
}

- (instancetype)initAddTreatmentProgressViewWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createTreatmentProgress];
        [self createSameView];
        self.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    }
    return self;
}

#pragma mark - 两个视图相同的部分
- (void)createSameView{
    UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, (SCREENWIDTH - 40) / 2, 30)];
    categoryLabel.text = @"类别";
    categoryLabel.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:categoryLabel];
    
    self.selectView = [[UIView alloc] initWithFrame:CGRectMake(20, 30, SCREENWIDTH - 40, 35)];
    self.selectView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.selectView];
    [self addBorder4View:self.selectView];
    
    self.categoryMarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 30, SCREENWIDTH - 50, 35)];
    self.categoryMarkLabel.font = [UIFont systemFontOfSize:15.0];
    [self addSubview:self.categoryMarkLabel];
    self.categoryMarkLabel.text = @"未选择类别";
    
    // 类别选择标识图片
    UIImageView *aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 60, 5, 20, 20)];
    [self.selectView addSubview:aImageView];
    aImageView.backgroundColor = [UIColor yellowColor];
    
    //  为试图添加虚线
    UIView *lowerView = [[UIView alloc] initWithFrame:CGRectMake(-1, SCREENHEIGHT_INBAR - 50, SCREENWIDTH + 2, 51)];
    [self addSubview:lowerView];
    [self addDashedline4View:lowerView];
    
    self.recordingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 120, 0, 50, 50)];
    [lowerView addSubview:self.recordingImageView];
    self.recordingImageView.backgroundColor = [UIColor yellowColor];
    
    self.takepicturesImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 65, 0, 50, 50)];
    [lowerView addSubview:self.takepicturesImageView];
    self.takepicturesImageView.backgroundColor = [UIColor yellowColor];
    
    // 点击录音产生的覆盖层
    UIImageView *coverImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    coverImageView.backgroundColor = [UIColor whiteColor];
    coverImageView.alpha = 0.7;
    [self addSubview:coverImageView];
    coverImageView.userInteractionEnabled = YES;
    coverImageView.hidden = YES;
    coverImageView.tag = MAIN_COVERIMAGEVIEW;
    
    self.pushView = [[UIView alloc] initWithFrame:CGRectMake(-1, SCREENHEIGHT, SCREENWIDTH + 2, 200 + 1)];
    UIImageView *recordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 50, 30, 80, 80)];
    recordImageView.tag = PUSHVIEW_IMAGEVIEW;
    recordImageView.backgroundColor = [UIColor yellowColor];
    [self.pushView addSubview:recordImageView];
    [self addSubview:self.pushView];
    [self addDashedline4View:self.pushView];
    
    self.showRecordView = [[UIView alloc] initWithFrame:self.pushView.bounds];
    // 为了展示出虚线
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(-1, 50, SCREENWIDTH + 2, 150 + 1)];
    [self addDashedline4View:sectionView];
    [self.showRecordView addSubview:sectionView];
    
    UIButton *newRecordBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    [newRecordBtn setTitle:@"重新摄录" forState:UIControlStateNormal];
    [self set4Button:newRecordBtn];
    newRecordBtn.tag = SHOWRECORDVIEW_NEWRECORDBTN;
    [self.showRecordView addSubview:newRecordBtn];
    
    UIButton *useBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREENWIDTH  - 150, 0, 150, 50)];
    [useBtn setTitle:@"使用" forState:UIControlStateNormal];
    useBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    useBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [useBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    useBtn.tag = SHOWRECORDVIEW_USEBTN;
    [self.showRecordView addSubview:useBtn];
    
    UIButton *showRecordingBtn = [[UIButton alloc] initWithFrame:CGRectMake(20, 65, 60, 60)];
    [self.showRecordView addSubview:showRecordingBtn];
    showRecordingBtn.tag = SHOWRECORDVIEW_SHOWBUTTON;
    //[showRecordingBtn setImage:<#(UIImage *)#> forState:<#(UIControlState)#>];
    showRecordingBtn.backgroundColor = [UIColor redColor];
    
    //录音的播放进度展示
    UILabel *beginLabel = [[UILabel alloc] initWithFrame:CGRectMake(95, 80, 50, 30)];
    [self.showRecordView addSubview:beginLabel];
    beginLabel.font = [UIFont systemFontOfSize:13.0];
    beginLabel.tag = SHOWRECORDVIEW_BEGINLABEL;
    beginLabel.backgroundColor = [UIColor redColor];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(140, 80, SCREENWIDTH - 65 - 140, 30)];
    [self.showRecordView addSubview:slider];
    slider.minimumValue = 0;
    slider.maximumValue = 1.0;
    slider.tag = SHOWRECORDVIEW_SLIDER;
    
    UILabel *endLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH - 60, 80, 50, 30)];
    [self.showRecordView addSubview:endLabel];
    endLabel.font = [UIFont systemFontOfSize:13.0];
    endLabel.tag = SHOWRECORDVIEW_ENDLABEL;
    endLabel.backgroundColor = [UIColor redColor];
    
    [self.pushView addSubview:self.showRecordView];
    self.showRecordView.hidden = YES;
}

#pragma mark - button的设置
/**
 *  设置button的字体对齐样式 字体据边框 和改变字体颜色
 *
 *  @param button 
 */
- (void)set4Button:(UIButton *)button{
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
    [button setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
}

#pragma mark - 为view添加虚线边框
- (void)addDashedline4View:(UIView *)view{
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = [UIColor colorWithRed:67/255.0f green:37/255.0f blue:83/255.0f alpha:0.3].CGColor;
    border.fillColor = nil;
    border.lineDashPattern = @[@4, @2];
    [view.layer addSublayer:border];
    border.path = [UIBezierPath bezierPathWithRect:view.bounds].CGPath;
    border.frame = view.bounds;
}

#pragma mark - 新临床任务界面特有的view
- (void)createClinicalTask{
    UILabel *segmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 65, (SCREENWIDTH - 40) / 2, 30)];
    segmentLabel.text = @"负责";
    segmentLabel.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:segmentLabel];
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"护士",@"医师",@"本人",@"其他", nil];
    self.segmentCtr = [[UISegmentedControl alloc] initWithItems:array];
    self.segmentCtr.frame = CGRectMake(20, 95, SCREENWIDTH - 40, 35);
    [self addSubview:self.segmentCtr];
    self.segmentCtr.tintColor = RGBACOLOR(11, 94, 173, 1);

    self.segmentCtr.selectedSegmentIndex = 0;
    
    _markLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 130, (SCREENWIDTH - 40) / 2, 30)];
    _markLabel.text = @"文本";
    _markLabel.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:_markLabel];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 160, SCREENWIDTH - 40, SCREENHEIGHT_INBAR - 220)];
    self.textView.font = [UIFont systemFontOfSize:15.0];
    [self addBorder4View:self.textView];
    [self addSubview:self.textView];
    [self createInputAccessoryView4ClinicalTasktextView:self.textView];
    
    self.showView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 216 - 50, SCREENWIDTH, 216 + 50)];
    self.showView.backgroundColor = [UIColor whiteColor];
    self.showView.alpha = 0.8;
    self.showView.hidden = YES;
    self.showLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, SCREENWIDTH, 40)];
    [self.showView addSubview:self.showLabel];
    [self addSubview:self.showView];
}

#pragma mark- 新治疗进度界面特有的view
- (void)createTreatmentProgress{
    _markLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 65, (SCREENWIDTH - 40) / 2, 30)];
    _markLabel.text = @"文本";
    _markLabel.font = [UIFont systemFontOfSize:16.0];
    [self addSubview:_markLabel];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 95, SCREENWIDTH - 40, SCREENHEIGHT_INBAR - 155)];
    self.textView.font = [UIFont systemFontOfSize:15.0];
    [self addBorder4View:self.textView];
    [self addSubview:self.textView];
}
#pragma mark - 自定义各自键盘的内容
#pragma mark - 自定义InputAccessoryViewFortextView
- (void)createInputAccessoryView4ClinicalTasktextView:(UITextView *)textView{
    UIScrollView *customScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    customScrollView.layer.borderWidth = 0.5;
    customScrollView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    customScrollView.backgroundColor = RGBACOLOR(198, 202, 209, 1);
    customScrollView.bounces = YES;
    textView.inputAccessoryView = customScrollView;
    
    UIView *buttonShowView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1.5* SCREENWIDTH, 50)];
    [customScrollView addSubview:buttonShowView];
    customScrollView.contentSize = buttonShowView.frame.size;
    
    self.clinicalTaskdateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.clinicalTaskdateButton.frame = CGRectMake(10, 5, 40, 40);
    self.clinicalTaskdateButton.backgroundColor = [UIColor yellowColor];
//    [self.clinicalTaskdateButton setImage:<#(UIImage *)#> forState:<#(UIControlState)#>]
    [buttonShowView addSubview:self.clinicalTaskdateButton];
    
    self.markButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.markButton.frame = CGRectMake(60, 5, 40, 40);
    self.markButton.backgroundColor = [UIColor yellowColor];
    //    [self.clinicalTaskdateButton setImage:<#(UIImage *)#> forState:<#(UIControlState)#>]
    [buttonShowView addSubview:self.markButton];
    
    NSString *xrStr = @"审核 X-R";
    CGFloat xrWidth = [self width4String:xrStr withsystemFontOfSize:18.0];
    self.XRLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 5, xrWidth, 40)];
    self.XRLabel.text = xrStr;
    self.XRLabel.backgroundColor = [UIColor whiteColor];
    [self addCornerRadius4VieW:self.XRLabel];
    [buttonShowView addSubview:self.XRLabel];
    
    NSString *tCxStr = @"检查 Cx";
    CGFloat tCxWidth = [self width4String:tCxStr withsystemFontOfSize:18.0];
    self.checkCxLabel = [[UILabel alloc] initWithFrame:CGRectMake(110 + xrWidth + 10, 5, tCxWidth, 40)];
    self.checkCxLabel.text = tCxStr;
    self.checkCxLabel.backgroundColor = [UIColor whiteColor];
    [self addCornerRadius4VieW:self.checkCxLabel];
    [buttonShowView addSubview:self.checkCxLabel];
    
    NSString *mCxStr = @"制备 Cx";
    CGFloat mCxWidth = [self width4String:mCxStr withsystemFontOfSize:18.0];
    self.makeCxLabel = [[UILabel alloc] initWithFrame:CGRectMake(110 + xrWidth + 10 + tCxWidth + 10, 5, mCxWidth, 40)];
    self.makeCxLabel.text = mCxStr;
    self.makeCxLabel.backgroundColor = [UIColor whiteColor];
    [self addCornerRadius4VieW:self.makeCxLabel];
    [buttonShowView addSubview:self.makeCxLabel];
    
    NSString *crStr = @"检查结果";
    CGFloat crWidth = [self width4String:crStr withsystemFontOfSize:18.0];
    self.checkResultLabel = [[UILabel alloc] initWithFrame:CGRectMake(110 + xrWidth + 10 + tCxWidth + 10 + mCxWidth + 10, 5, crWidth, 40)];
    self.checkResultLabel.text = crStr;
    self.checkResultLabel.backgroundColor = [UIColor whiteColor];
    [self addCornerRadius4VieW:self.checkResultLabel];
    [buttonShowView addSubview:self.checkResultLabel];
    
    self.othButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.othButton.frame = CGRectMake(110 + xrWidth + 10 + tCxWidth + 10 + mCxWidth + 10 + crWidth + 10, 5, 40, 40);
    self.othButton.backgroundColor = [UIColor yellowColor];
    //    [self.clinicalTaskdateButton setImage:<#(UIImage *)#> forState:<#(UIControlState)#>]
    [buttonShowView addSubview:self.othButton];
    
    self.markShowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH * 1.5, 50)];
    self.markShowView.backgroundColor = RGBACOLOR(198, 202, 209, 1);
    [customScrollView addSubview:self.markShowView];
    self.showMarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREENWIDTH - 20, 50)];
    [self.markShowView addSubview:self.showMarkLabel];
    self.showMarkLabel.textColor = [UIColor whiteColor];
    self.markShowView.hidden = YES;
}

#pragma mark - createInputAccessoryView4TreatmentProgressView
- (void)createInputAccessoryView4TreatmentProgressView:(UITextView *)textView{
    
}

#pragma mark - 计算字符串的宽度
- (CGFloat)width4String:(NSString *)str withsystemFontOfSize:(CGFloat)fsize{
    CGSize size  = CGSizeMake(20000,40);
    NSDictionary * attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fsize],NSFontAttributeName, nil];
    CGRect crtect = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributeDic context:nil];
    return crtect.size.width;
}

#pragma mark - add border cornerRadius ForView
- (void)addBorder4View:(UIView *)aView{
    aView.layer.masksToBounds = YES;
    aView.layer.cornerRadius = 5.0;
    aView.layer.borderWidth = 1.0;
    aView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
}

- (void)addCornerRadius4VieW:(UIView *)aView{
    aView.layer.masksToBounds = YES;
    aView.layer.cornerRadius = 5.0;
}

@end
