//
//  ChartClass.m
//  ChartViewDemo
//
//  Created by apple on 13/3/8.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "ChartClass.h"

@implementation ChartClass

@synthesize infoData;
@synthesize countData;
@synthesize infoArray, countArray;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(30, 0, 480, 320)];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        infoArray = [[NSMutableArray alloc] init];
        countArray = [[NSMutableArray alloc] init];
    }
    return self;
}

//自訂Label
-(BOOL) createLabel:(CGRect)rect labelText:(NSString *)string fontSize:(NSInteger)fontsize fontColor:(UIColor *)color
{
    UILabel *lbTemp = [[UILabel alloc] initWithFrame:rect];
    lbTemp.text = string;
    lbTemp.textColor = color;
    lbTemp.backgroundColor = [UIColor clearColor];
    lbTemp.font = [UIFont fontWithName:@"Courier" size:fontsize];
    [lbTemp setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:lbTemp];
    return YES;
}

//接收資料和資料筆數
-(void) receiveData:(float)data dataCount:(int)count
{
    infoData = data;
    countData = count;
    
    [infoArray addObject:[NSNumber numberWithFloat:infoData]];
    [countArray addObject:[NSNumber numberWithInteger:countData]];
    //NSLog(@"infoArray%@",infoArray);
    //NSLog(@"countArray:%@",countArray);
}

//移除資料的label
-(void) removeDataLabel
{
    [infoArray removeAllObjects];
    [countArray removeAllObjects];
}

//依據量測到的筆數再給予view新的width
-(void) refreshWidthSize:(int) width{
    [self setFrame:CGRectMake(30, 0, 480+width, 320)];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    Float32 f32StepX,f32StepY,f32x,f32y;
    int i = 0;
    
    //x軸單位
    f32StepX = (rect.size.width - 7.5) / 50;
    //y軸單位
    f32StepY = (rect.size.height - 14.5) / 50;
    //NSLog(@"SetpX=%f, SetpY=%f",f32StepX,f32StepY);
    
    //clear view
    [self clearsContextBeforeDrawing];
    
    for (UIView *view in self.subviews){
        if ([view isKindOfClass:[UILabel class]]){
            [view removeFromSuperview];
        }
    }
    
    //取得畫布
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //==========================畫出溫度間隔線==========================
    //線寬
    CGContextSetLineWidth(ctx, 2.5);
    //線條顏色(深藍色
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:33/255.0 green:0 blue:120/255.0 alpha:1].CGColor);
    //在Y軸上畫出橫線條
    f32y = rect.size.height + 17 - f32StepY * 7;
    //設定啟始點
    CGContextMoveToPoint(ctx, 20, f32y);
    //畫出線段
    CGContextAddLineToPoint(ctx, rect.size.width-5.5, f32y);
    //畫出
    CGContextStrokePath(ctx);
    //顯示溫度Label
    NSArray *tempLabel = [NSArray arrayWithObjects:@"34.5˚C", @"36.4˚C", @"38.6˚C", @"40.0˚C", @"42.2˚C", nil];
    //以view的高度除以5個Label, 就能算出每個label的y要落在哪個點
    for (int i=0;i<[tempLabel count];i++){
        [self createLabel:CGRectMake(-37, (f32y-42.5-i*55), 60, 20)
                labelText:[tempLabel objectAtIndex:i]
                 fontSize:13.0
                fontColor:[UIColor blackColor]];
        
        //NSLog(@"f32y:%f",f32y-42.5-i*55);
    }
    
    //==========================畫出時間區隔線==========================
    //線寬
    CGContextSetLineWidth(ctx, 2.5);
    //線條顏色
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:33/255.0 green:0 blue:120/255.0 alpha:1].CGColor);
    //在X軸上畫出直線條
    //f32x = rect.size.width - f32StepX * 5 + 0.25;
    f32x = 20;
    //設定啟始點
    CGContextMoveToPoint(ctx, f32x, f32y);
    //畫出線段
    CGContextAddLineToPoint(ctx, f32x, 40);
    //畫出
    CGContextStrokePath(ctx);
    
    //    //加上X軸的時間 label
    //    for (i=0;i<4;i++) {
    //        NSArray *timeTitle = [NSArray arrayWithObjects:@"AM12:00",@"AM06:00",@"PM12:00",@"PM06:00", nil];
    //
    //        [self createLabel:CGRectMake(0+100*i, rect.size.height-22.5, 100, 30)
    //                labelText:[NSString stringWithFormat:@"%@",[timeTitle objectAtIndex:i]]
    //                 fontSize:17.0
    //                fontColor:[UIColor blackColor]];
    //    }
    
    //單位°C
    //==========================畫出量測的體溫資料==========================
    for (i=0;i<[infoArray count];i++){
        int hour = [[countArray objectAtIndex:i] intValue];
        float temp = [[infoArray objectAtIndex:i] floatValue];
        
        //NSLog(@"攝氏:%.1f , 華氏:%.2f",(temp-32)*5/9,temp);
        
        //體溫出現的x軸座標
        f32x = 35 + 45 * hour;
        //體溫出現的y軸座標 (以view的高度除, 就能算出每個點的y要落在哪個點)
        if (temp >= 40.0){
            f32y = 50 + 20 * (42.2 - temp);
        }
        else if (temp > 38.5 && temp < 40.0){
            f32y = 65 + 22 * (42.2 - temp);
        }
        else if (temp > 36.4 && temp < 38.6){
            f32y = 70 + 23.25 * (42.2 - temp);
        }
        else if (temp < 36.4){
            f32y = 73 + 24.0 * (42.2 - temp);
        }
        
        //NSLog(@"f32x:%f f32y:%f",f32x,f32y);
        [self createLabel:CGRectMake(f32x-15, f32y-20, 50, 30)
                labelText:[NSString stringWithFormat:@"%@",[infoArray objectAtIndex:i]]
                 fontSize:11.0
                fontColor:[UIColor blackColor]];
        
        //標示出溫度
        if (f32y >= 280){
            [self createLabel:CGRectMake(f32x-20, 270, 50, 30)
                    labelText:@"."
                     fontSize:35.0
                    fontColor:[UIColor blueColor]];
        }
        else if (f32y <= 40){
            [self createLabel:CGRectMake(f32x-20, -20, 50, 30)
                    labelText:@"."
                     fontSize:35.0
                    fontColor:[UIColor redColor]];
        }
        else {
            [self createLabel:CGRectMake(f32x-20, f32y-18, 50, 30)
                    labelText:@"."
                     fontSize:35.0
                    fontColor:[UIColor colorWithRed:33/255.0 green:0/255.0 blue:255/255.0 alpha:1.0]];
        }
    }
    
    //==========================畫出點與點之間的線==========================
    //線寬
    CGContextSetLineWidth(ctx, 1.0);
    //線條顏色
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithRed:69/255.0 green:150/255.0 blue:0 alpha:0.5].CGColor);
    for (i=0;i<[infoArray count];i++){
        float temp = [[infoArray objectAtIndex:i] floatValue];
        float startX = 35 + 45 * [[countArray objectAtIndex:i] intValue];
        float startY = 0.0;
        
        if (temp >= 40.0){
            startY = 50 + 20 * (42.2 - temp);
        }
        else if (temp > 38.5 && temp < 40.0){
            startY = 65 + 22 * (42.2 - temp);
        }
        else if (temp > 36.3 && temp < 38.6){
            startY = 70 + 23.25 * (42.2 - temp);
        }
        else if (temp < 36.4){
            startY = 73 + 24.0 * (42.2 - temp);
        }
        
        //NSLog(@"startX:%f startY:%f",startX,startY);
        CGContextMoveToPoint(ctx, startX+5, startY+4);
        
        for(i=1;i<[infoArray count];i++){
            float temp = [[infoArray objectAtIndex:i] floatValue];
            float endX = 35 + 45 * [[countArray objectAtIndex:i] intValue];
            float endY = 0.0;
            
            if (temp >= 40.0){
                endY = 50 + 20 * (42.2 - temp);
            }
            else if (temp > 38.5 && temp < 40.0){
                endY = 65 + 22 * (42.2 - temp);
            }
            else if (temp > 36.3 && temp < 38.6){
                endY = 70 + 23.25 * (42.2 - temp);
            }
            else if (temp < 36.4){
                endY = 73 + 24.0 * (42.2 - temp);
            }
            
            //NSLog(@"endX:%f endY:%f",endX,endY);
            CGContextAddLineToPoint(ctx, endX+5, endY+4);
        }
        CGContextStrokePath(ctx);
    }
}


@end
