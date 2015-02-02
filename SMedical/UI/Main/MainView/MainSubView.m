//
//  MainSubView.m
//  SMedical
//
//  Created by _SS on 14/12/2.
//  Copyright (c) 2014年 shanshan. All rights reserved.
//

#import "MainSubView.h"
#import "Header.h"
@interface MainSubView ()
{
    
}
@property (nonatomic, strong) NSArray *segmentArray;
@property (nonatomic, strong) UIView *aView;

@end

@implementation MainSubView

- (id)initWithFrame:(CGRect)frame{
   self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self creatSubView];
    }
    return self;
}

- (void)creatSubView{
    // listTableView
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    self.listTableView.backgroundColor = [UIColor whiteColor];
    self.listTableView.separatorInset = UIEdgeInsetsZero;

    // searchBar
    self.searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10, 0, self.bounds.size.width-20, 49)];
    self.searchBar.placeholder = @"输入患者姓名或者房间号";
    self.searchBar.barTintColor = RGBACOLOR(245, 245, 245, 1);
    self.searchBar.barStyle = UIBarStyleBlack;
    self.searchBar.layer.borderWidth= 0.5;
    self.searchBar.layer.borderColor=[[UIColor whiteColor] CGColor];
    self.listTableView.tableHeaderView = self.searchBar;
    
    // segmentCtr
    self.segmentArray = [[NSArray alloc] initWithObjects:@"全部",@"医疗保险",@"注意",@"任务", nil];
    
    self.aView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT_INBAR - 45, SCREENWIDTH, 45)];
    self.aView.backgroundColor = [UIColor whiteColor];
    self.segmentCtr = [[UISegmentedControl alloc] initWithItems:self.segmentArray];
    self.segmentCtr.frame = CGRectMake(4, 4, SCREENWIDTH - 8,45 - 8);
    self.segmentCtr.tintColor = RGBACOLOR(11, 94, 173, 1);
    [self.segmentCtr setTitleTextAttributes:@{NSForegroundColorAttributeName:RGBACOLOR(11, 94, 173, 1),NSFontAttributeName: [UIFont systemFontOfSize: 15.0]} forState: UIControlStateNormal];
    [self.segmentCtr setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName: [UIFont systemFontOfSize: 16.0]} forState: UIControlStateSelected];
    
    [self addSubview:self.listTableView];
    [self addSubview:self.aView];
    [self.aView addSubview:self.segmentCtr];

    [self setExtraCellLineHidden:self.listTableView];
}

- (void)setExtraCellLineHidden:(UITableView *)tableView{
    UIView *view = [UIView new];
    [tableView setTableFooterView:view];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
