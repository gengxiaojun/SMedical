//
//  ChangePersonalcommentsViewController.m
//  SMedical
//
//  Created by _SS on 14/12/18.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "ChangePersonalcommentsViewController.h"
#import "Header.h"
#import "DataManager.h"
#import "JSONDataManager.h"
@interface ChangePersonalcommentsViewController ()<UITextViewDelegate>{
    UITextView *_textView;
}
@property (nonatomic, strong) NSString *personalcommentsStr;
@end

@implementation ChangePersonalcommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    [self creatSubView];
    // Do any additional setup after loading the view.
}

- (void)creatSubView{
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(-1, -1, SCREENWIDTH+2, 64)];
    topView.backgroundColor = RGBACOLOR(245, 245, 245, 1);
    [self.view addSubview:topView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cancelButton.frame = CGRectMake(10, 20, 40, 40);
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [cancelButton setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancelButton addTarget:self action:@selector(dismissView:) forControlEvents:UIControlEventTouchDown];
    [topView addSubview:cancelButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREENWIDTH / 2 - 100, 20, 200, 40)];
    titleLabel.text = @"更新个人注释";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17.0];
    [topView addSubview:titleLabel];
    
    UIButton *updataButton = [UIButton buttonWithType:UIButtonTypeSystem];
    updataButton.frame = CGRectMake(SCREENWIDTH - 50, 20, 40, 40);
    updataButton.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [updataButton setTitle:@"更新" forState:(UIControlStateNormal)];
    [updataButton addTarget:self action:@selector(upPersonalcommentsData:) forControlEvents:UIControlEventTouchDown];
    [topView addSubview:updataButton];
    
    UIView *bodyView = [[UIView alloc] initWithFrame:CGRectMake(-1, 64, SCREENWIDTH + 2, SCREENHEIGHT_INBAR + 1)];
    bodyView.layer.borderWidth = 0.5;
    bodyView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [self.view addSubview:bodyView];
    
    UILabel *markLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, SCREENWIDTH - 40, 30)];
    markLabel.text = @"文本";
    [bodyView addSubview:markLabel];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 30, SCREENWIDTH - 40, SCREENHEIGHT_INBAR - 50)];
    _textView.font = [UIFont systemFontOfSize:15.0];
    _textView.delegate = self;
    _textView.layer.masksToBounds = YES;
    _textView.layer.cornerRadius = 5.0;
    _textView.layer.borderWidth = 1.0;
    _textView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    [bodyView addSubview:_textView];
    
    NSString *text = [[DataManager shareInstance] showPersonalcommentTableContentWithPatientName:self.patiemtName];
    if (text.length > 0) {
        _textView.text = text;
    }else{
        NSDictionary *dic = [[JSONDataManager shareInstance] dataInfoWithName:self.patiemtName];
        NSString *text = [dic objectForKey:@"personalcomments"];
        _textView.text = text;
    }
}

#pragma mark -
#pragma mark - texteViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [[DataManager shareInstance] removeData4PersonalcommentTableContentWithPatientName:self.patiemtName];
    [UIView animateWithDuration:0.4 animations:^{
        textView.frame = CGRectMake(20, 30, SCREENWIDTH - 40, SCREENHEIGHT_INBAR - 315);
    }];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    textView.frame = CGRectMake(20, 30, SCREENWIDTH - 40, SCREENHEIGHT_INBAR - 50);
    
}

#pragma mark -
#pragma mark - 点击空白处回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
}

#pragma mark -
#pragma mark - button响应事件
- (void)dismissView:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)upPersonalcommentsData:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{
        [[DataManager shareInstance] createPersonalcommentTable];
        [[DataManager shareInstance] insertWithPatientName:self.patiemtName content:_textView.text];

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
