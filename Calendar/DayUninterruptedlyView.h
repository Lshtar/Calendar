//
//  DayUninterruptedlyView.h
//  Calendar
//
//  Created by D on 2018/7/31.
//  Copyright © 2018年 D. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DayUninterruptedlyView : UIView

//初始化
- (instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array continueCount:(int)continueCount;

//当天打卡
- (void)clickCurrentDate;

@end
