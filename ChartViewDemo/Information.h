//
//  Information.h
//  ChartViewDemo
//
//  Created by apple on 13/3/8.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Information : NSManagedObject

@property (nonatomic, retain) NSNumber * data;
@property (nonatomic, retain) NSNumber * count;

@end
