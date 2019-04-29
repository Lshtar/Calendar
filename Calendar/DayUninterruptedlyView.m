//
//  DayUninterruptedlyView.m
//  Calendar
//
//  Created by D on 2018/7/31.
//  Copyright © 2018年 D. All rights reserved.
//

#import "DayUninterruptedlyView.h"

@interface DayUninterruptedlyView ()

@property (nonatomic, copy) NSArray *objectArray;//7个连续对象

@property (nonatomic, assign) int continueCount;//3天

@property (nonatomic, strong) NSMutableDictionary *continueDic;//存储连续数组格式{[0,1,2],@"1",[4,5,6],@"2"}
//间隙
@property (nonatomic, assign) CGFloat itemGap;
//按钮宽度
@property (nonatomic, assign) CGFloat itemWidth;
//
@property (nonatomic, assign) NSInteger currentDateIndex;//当天的对象所在下标

@property (nonatomic, assign) NSInteger currentDateLabelTag;//当天日期label的tag

@end

@implementation DayUninterruptedlyView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupFoundDateUninterruptedlyView];
        
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame array:(NSArray *)array continueCount:(int)continueCount
{
    self = [super init];
    if(self)
    {
        [self setFrame:frame];
        self.continueDic = [NSMutableDictionary dictionary];
        self.continueCount = continueCount;
        self.objectArray = [NSArray arrayWithArray:array];
        [self deleWithArray:self.objectArray];
        [self setupFoundDateUninterruptedlyView];
    }
    return self;
}

- (void) setupFoundDateUninterruptedlyView
{
    _itemWidth = 40;
    
    self.itemGap = (self.frame.size.width-20 - _itemWidth* [self.objectArray count])/6;
    for (int i = 0; i < self.objectArray.count; i++) {
        
        NSDictionary *tempDic = [self.objectArray objectAtIndex:i];
        NSString *weakString = [tempDic valueForKey:@"week"];
        NSString *dateString = [tempDic valueForKey:@"date"];
        NSString *isCurrentString = [tempDic valueForKey:@"isCurrent"];
        //
        UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+(_itemWidth+self.itemGap)*i, 10, _itemWidth, 30)];
        weekLabel.backgroundColor = [UIColor clearColor];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        weekLabel.textColor = [UIColor lightTextColor];
        weekLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:weekLabel];
        weekLabel.text = weakString;
        
        UIImageView* singleImageV = [[UIImageView alloc]initWithFrame:CGRectMake(15+(_itemWidth+self.itemGap)*i, weekLabel.frame.size.height + 20, 30, 30)];
        [self addSubview:singleImageV];
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10+(_itemWidth+self.itemGap)*i, weekLabel.frame.size.height + 20, _itemWidth, 30)];
        dateLabel.backgroundColor = [UIColor clearColor];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.textColor = [UIColor lightGrayColor];
        dateLabel.font = [UIFont systemFontOfSize:14.0f];
        dateLabel.text = dateString;
        [self addSubview:dateLabel];
        
        //
        dateLabel.tag = [dateString intValue];
        singleImageV.tag = 100+dateLabel.tag;
        weekLabel.tag = 1000+dateLabel.tag;
        
        if([isCurrentString intValue]==1)
        {
            self.currentDateIndex = i;
            self.currentDateLabelTag = dateLabel.tag;
            weekLabel.textColor = [UIColor redColor];
            dateLabel.textColor = [UIColor redColor];
        }
    }
    [self showView];
}

//总展示方法
- (void)showView
{
    //求出self.continueDic中所有的下标。和self.objectArray中下标对比。不存在的下标画单圆
    for(NSInteger i=0;i<[self.objectArray count];i++)
    {
        if([self isHaveClickIndex:i])
        {
            if(![self judgeBelongContinueSingleIndex:i])
            {
                [self showSingleDateIndex:i];
            }
        }
    }
    //画连续部分
    NSArray *array = self.continueDic.allValues;
    for(NSInteger i=0;i<[array count];i++)
    {
        NSArray *singleArray = array[i];
        NSInteger minIndex = [singleArray.firstObject intValue];
        NSInteger maxIndex = [singleArray.lastObject intValue];
        [self showContinuousViewWithMinIndex:minIndex MaxInde:maxIndex];
    }
}

//展示单圈的方法
- (void)showSingleDateIndex:(NSInteger)index
{
    NSDictionary *tempDic = self.objectArray[index];
    NSString *dateString = [tempDic valueForKey:@"date"];
    NSInteger tag = [dateString intValue];
    UIImageView *singleImageV = [self viewWithTag:(100+tag)];
    //改变圈
    singleImageV.image = [UIImage imageNamed:@"dateDay"];
}

//展示3个以上圈起来的方法index和它以后的self.continueCount个对象
- (void)showContinuousViewWithMinIndex:(NSInteger)minIndex MaxInde:(NSInteger)maxIndex
{
    NSDictionary *minDic = self.objectArray[minIndex];
    NSString *minDate = [minDic valueForKey:@"date"];
    NSInteger minTag = [minDate intValue];
    //
    NSDictionary *maxDic = self.objectArray[maxIndex];
    NSString *maxDate = [maxDic valueForKey:@"date"];
    NSInteger maxTag = [maxDate intValue];
    //
    UILabel *dateLabelLeft = [self viewWithTag:minTag];
    UILabel *dateLabelright = [self viewWithTag:maxTag];
    //
    UIImageView* imaV = [[UIImageView alloc]initWithFrame:CGRectMake(dateLabelLeft.frame.origin.x+2, dateLabelLeft.frame.origin.y, dateLabelright.frame.origin.x+dateLabelright.frame.size.width-dateLabelLeft.frame.origin.x-6, 30)];
    UIImage* ima = [UIImage imageNamed:@"dateUninterruptedly"];
    // 设置端盖的值
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10, 90, 10, 90);
    // 设置拉伸的模式
    UIImageResizingMode mode = UIImageResizingModeStretch;
    // 拉伸图片
    UIImage *newImage = [ima resizableImageWithCapInsets:edgeInsets resizingMode:mode];
    imaV.image = newImage;
    imaV.tag = dateLabelLeft.tag +200;
    [self addSubview:imaV];
}

//打卡
- (void)clickCurrentDate
{
    NSInteger tag = self.currentDateLabelTag;
    UILabel *dateLabel = [self viewWithTag:tag];
    UIImageView *singleImageV = [self viewWithTag:(100+tag)];
    UILabel *weekLabel = [self viewWithTag:(1000+tag)];
    weekLabel.textColor = [UIColor redColor];
    dateLabel.textColor = [UIColor whiteColor];
    singleImageV.image = [UIImage imageNamed:@"datePunch"];
    //做处理
    NSInteger minIndex = 0;
    NSInteger currentIndex = self.currentDateIndex;
    for(NSInteger i=currentIndex-1;i>=0;i--)
    {
        NSDictionary *tempDic = [self.objectArray objectAtIndex:i];
        NSString *status = [tempDic valueForKey:@"status"];
        NSInteger date = [[tempDic valueForKey:@"date"] intValue];
        if([status integerValue]==0)
        {
            minIndex = i+1;
            break;
        }
        else
        {
            if([self currentDateHaveContinuous])
            {
                UIImageView *singV = [self viewWithTag:(100+date)];
                [singV removeFromSuperview];
            }
        }
    }
    //
    if([self currentDateHaveContinuous])
    {
        NSDictionary *minDic = [self.objectArray objectAtIndex:minIndex];
        NSString *minTagString = [minDic valueForKey:@"date"];
        UILabel *minLabel = [self viewWithTag:[minTagString intValue]];
        //
        UIImageView* imaV = [[UIImageView alloc]initWithFrame:CGRectMake(minLabel.frame.origin.x+2, minLabel.frame.origin.y, dateLabel.frame.origin.x+dateLabel.frame.size.width-minLabel.frame.origin.x-6, 30)];
        UIImage* ima = [UIImage imageNamed:@"dateUninterruptedly"];
        // 设置端盖的值
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(10, 90, 10, 90);
        // 设置拉伸的模式
        UIImageResizingMode mode = UIImageResizingModeStretch;
        // 拉伸图片
        UIImage *newImage = [ima resizableImageWithCapInsets:edgeInsets resizingMode:mode];
        imaV.image = newImage;
        [self addSubview:imaV];
        //隐藏方法
        tag = minLabel.tag +200;
        UIImageView *tempV = [self viewWithTag:tag];
        if(tempV)
        {
            [tempV removeFromSuperview];
        }
    }
    
}

#pragma mark -- 算法逻辑

//判断当前日期前边是否有大于self.continueCount-1个连续天
- (BOOL)currentDateHaveContinuous
{
    BOOL result = NO;
    if(self.currentDateIndex +1 < self.continueCount)
    {
        return result;
    }
    NSInteger count = 0;
    for(NSInteger i=self.currentDateIndex-1;i>=0;i--)
    {
        NSDictionary *dicTemp = self.objectArray[i];
        NSString *status = [dicTemp valueForKey:@"status"];
        if([status intValue]==1)
        {
            count++;
            if(count >= self.continueCount-1)
            {
                result = YES;
                break;
            }
        }
        else
        {
            break;
        }
    }
    return result;
}

//通过对象数组 self.objectArray处理 得到存储连续数据的字典对象
- (void)deleWithArray:(NSArray *)array
{
    int tempCount = 0;//计数器.遇到continueCount清零加入字典对象
    for(NSInteger i=0;i<[array count];i++)
    {
        NSDictionary *tempDic = [array objectAtIndex:i];
        NSString *status = [tempDic valueForKey:@"status"];
        if([status integerValue]==1)
        {
            tempCount++;
            if(tempCount >= self.continueCount)
            {
                [self storeObjectIndex:i withIndexCount:tempCount];
            }
        }
        else
        {
            tempCount = 0;
        }
    }
}

//存储该下标的前self.continueCount个数量的对象放到self.continueDic中
- (void)storeObjectIndex:(NSInteger)index withIndexCount:(NSInteger)count
{
    NSInteger number = index+1;//考虑到下标2减去数量3.
    NSMutableArray *mutArray = [NSMutableArray array];
    for(NSInteger i=number-count;i<number;i++)
    {
        NSString *tempString = [NSString stringWithFormat:@"%ld",(long)i];
        [mutArray addObject:tempString];
    }
    //
    NSUInteger haveCount = self.continueDic.allKeys.count;
    NSString *key;
    if(count==self.continueCount)//=3的时候创建新key
    {
        key = [NSString stringWithFormat:@"%lu",haveCount+1];
    }
    else//大于3的时候覆盖
    {
        key = [NSString stringWithFormat:@"%lu",haveCount];
    }
    [self.continueDic setObject:mutArray forKey:key];
    
}


//判断当前下表是否打过卡
- (BOOL)isHaveClickIndex:(NSInteger)index
{
    BOOL result = NO;
    //
    NSDictionary *dicTemp = self.objectArray[index];
    NSString *status = [dicTemp valueForKey:@"status"];
    if([status intValue]==0)
    {
        result = NO;
    }
    else
    {
        result = YES;
    }
    return result;
}

//判断单个的下标是否在连续的范围内
- (BOOL)judgeBelongContinueSingleIndex:(NSInteger)index
{
    BOOL result = NO;
    NSString *valuestring = [NSString stringWithFormat:@"%ld",index];
    //
    NSArray *array = self.continueDic.allValues;
    for(NSInteger i=0;i<[array count];i++)
    {
        NSArray *singleArray = array[i];
        if([singleArray containsObject:valuestring])
        {
            result = YES;
            break;
        }
    }
    return result;
}


@end
