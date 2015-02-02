//
//  MarkEditViewController.m
//  SMedical
//
//  Created by _SS on 14/12/4.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "MarkEditViewController.h"
#import "EditView.h"
@interface MarkEditViewController ()<UITextFieldDelegate>{
    EditView *_editView;
    
}
@end

@implementation MarkEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"编辑关注的病患";
    
    _editView = [[EditView alloc] initWithFrame:self.view.bounds];
    self.view = _editView;
    _editView.markModel = self.markModel;
    _editView.markTextField.delegate = self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.text.length > 0) {
        [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:self.markModel.markColor];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark -
#pragma mark - 回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [_editView.markTextField resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([@"\n" isEqualToString:string] == YES){
        [textField resignFirstResponder];
        return NO;
    }
    return YES;
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
