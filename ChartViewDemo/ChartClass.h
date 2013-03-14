//
//  ChartClass.h
//  ChartViewDemo
//
//  Created by apple on 13/3/8.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartClass : UIView{
    float infoData;
    int countData;
    NSMutableArray *infoArray, *countArray;
}

@property (nonatomic, assign) float infoData;
@property (nonatomic, assign) int countData;
@property (nonatomic, retain) NSMutableArray *infoArray, *countArray;

//接收資料和資料筆數
-(void) receiveData:(float)data dataCount:(int)count;
//自訂Label
-(BOOL) createLabel:(CGRect)rect labelText:(NSString *)string fontSize:(NSInteger)size fontColor:(UIColor *)color;
//移除資料的label
-(void) removeDataLabel;
//更新寬度
-(void) refreshWidthSize:(int) width;
@end
