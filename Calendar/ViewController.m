//
//  ViewController.m
//  Calendar
//
//  Created by D on 2018/7/31.
//  Copyright © 2018年 D. All rights reserved.
//

#import "ViewController.h"
#import "DayUninterruptedlyView.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton* foundDateClickButton;
@property (nonatomic, strong) DayUninterruptedlyView* dayUninterruptedlyV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //连续打卡
    [self setupCalendarView];
}

- (void) setupCalendarView
{
    _foundDateClickButton = [UIButton buttonWithType: UIButtonTypeCustom];
    _foundDateClickButton.frame = CGRectMake(self.view.frame.size.width- 80, 43, 60, 30);
    [_foundDateClickButton setBackgroundImage:[UIImage imageNamed:@"dateUninterruptedlyState"] forState:UIControlStateNormal];
    [_foundDateClickButton setTitle:@"打卡" forState:UIControlStateNormal];
    [_foundDateClickButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_foundDateClickButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [self.view addSubview:_foundDateClickButton];
    
    [_foundDateClickButton addTarget:self action:@selector(foundDateClick:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *weekArray = [NSArray arrayWithObjects:@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日", nil];
    
    NSArray *dateArray = [NSArray arrayWithObjects:@"28",@"29",@"30",@"1",@"2",@"3",@"4", nil];
    
    NSArray *statusArray = [NSArray arrayWithObjects:@"0",@"1",@"1",@"1",@"0",@"0",@"0", nil];
    
    NSArray *isCurrentArray = [NSArray arrayWithObjects:@"0",@"0",@"0",@"0",@"1",@"0",@"0", nil];
    
    NSMutableArray *mutArray = [NSMutableArray array];
    for(NSInteger i=0;i<[weekArray count];i++)
    {
        NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:weekArray[i],@"week",dateArray[i],@"date",statusArray[i],@"status",isCurrentArray[i],@"isCurrent", nil];
        [mutArray addObject:mutDic];
    }
    
    CGRect rect = CGRectMake(0, 103, self.view.frame.size.width, 100);
    _dayUninterruptedlyV = [[DayUninterruptedlyView alloc] initWithFrame:rect array:[mutArray copy] continueCount:3];
    [self.view addSubview:_dayUninterruptedlyV];
}

- (void) foundDateClick:(UIButton*) sender
{
    [_foundDateClickButton setBackgroundImage:[UIImage imageNamed:@"dateUninterruptedlyDefalitState"] forState:UIControlStateNormal];
    [_foundDateClickButton setTitle:@"已打卡" forState:UIControlStateNormal];
    [_foundDateClickButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_foundDateClickButton.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_dayUninterruptedlyV clickCurrentDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
