//
//  ViewController.h
//  ChartViewDemo
//
//  Created by apple on 13/3/8.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChartClass.h"
#import "AppDelegate.h"
#import "Information.h"

@interface ViewController : UIViewController{
    UIScrollView *scrollView;
    ChartClass *chartClass;
    AppDelegate *app;
    Information *infoData;
    NSManagedObjectContext *context;
    NSFetchRequest *fetchRequest;
    NSEntityDescription *entity;
    NSMutableArray *results;
    UIButton *addButton, *deleteButton;
    int saveCount;
    BOOL firstStart;
}

@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) ChartClass *chartClass;
@property (nonatomic, retain) AppDelegate *app;
@property (nonatomic, retain) Information *infoData;
@property (nonatomic, retain) NSManagedObjectContext *context;
@property (nonatomic, retain) NSFetchRequest *fetchRequest;
@property (nonatomic, retain) NSEntityDescription *entity;
@property (nonatomic, retain) NSMutableArray *results;
@property (nonatomic, retain) UIButton *addButton, *deleteButton;
@property (nonatomic, assign) int saveCount;
@property (nonatomic, assign) BOOL firstStart;

-(void) addDataToInformation;
-(void) getAllData;
-(void) deleteAllData;

@end
