//
//  ViewController.m
//  ChartViewDemo
//
//  Created by apple on 13/3/8.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize scrollView;
@synthesize chartClass;
@synthesize app, infoData, context, fetchRequest, entity, results;
@synthesize addButton, deleteButton;
@synthesize saveCount;
@synthesize firstStart;

-(void) addDataToInformation
{
    //測試用的資料
    NSArray *array = [[NSArray alloc] initWithObjects:@"34.5", @"36.4", @"38.6", @"40.0", @"42.2", nil];
    
    //test 34.5~36.4
    //NSArray *array = [[NSArray alloc] initWithObjects:@"34.5", @"35.0", @"35.5", @"36.0", @"36.4", nil];
    //test 36.4~38.6
    //NSArray *array = [[NSArray alloc] initWithObjects:@"36.86", @"37.32", @"37.78", @"38.24", @"38.6", nil];
    //test 38.6~40.0
    //NSArray *array = [[NSArray alloc] initWithObjects:@"38.6", @"38.9", @"39.35", @"39.5", @"40.0", nil];
    //test 40.0~42.2
    //NSArray *array = [[NSArray alloc] initWithObjects:@"40.0", @"40.44", @"40.88", @"41.32", @"42.2", nil];
    
    //利用迴圈一筆一筆加到資料庫裡面
    for (int i=0;i<[array count];i++){
        infoData = [NSEntityDescription insertNewObjectForEntityForName:@"Information" inManagedObjectContext:context];
        infoData.data = [NSNumber numberWithFloat:[[array objectAtIndex:i] floatValue]];
        infoData.count = [NSNumber numberWithInt:saveCount];
        
        NSError *error;
        
        if (![context save:&error]) {
            NSLog(@"Save infoData error;%@",error);
        }else{
            NSLog(@"%@",infoData);
        }
        
        [self getAllData];
    }
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //初始charClass並加進scrollView
    chartClass = [[ChartClass alloc] initWithFrame:self.view.bounds];
    [self getAllData];
    [self.scrollView addSubview:chartClass];
    //Reset button
    deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [deleteButton setFrame:CGRectMake(50, 5, 60, 30)];
    [deleteButton setTitle:@"Reset" forState:UIControlStateNormal];
    [deleteButton setBackgroundColor:[UIColor grayColor]];
    [deleteButton addTarget:self action:@selector(deleteAllData) forControlEvents:UIControlEventTouchUpInside];
    [chartClass addSubview:deleteButton];
    //Add button
    addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [addButton setFrame:CGRectMake(350, 5, 60, 30)];
    [addButton setTitle:@"Add" forState:UIControlStateNormal];
    [addButton setBackgroundColor:[UIColor grayColor]];
    [addButton addTarget:self action:@selector(addDataToInformation) forControlEvents:UIControlEventTouchUpInside];
    [chartClass addSubview:addButton];
    
    firstStart = FALSE;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    app = [[UIApplication sharedApplication] delegate];
    context = [app managedObjectContext];
    fetchRequest = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription entityForName:@"Information" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    results = [[NSMutableArray alloc] init];
    
    //初始scrollView
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
    [scrollView setScrollEnabled:YES];
    [self.view addSubview:scrollView];
    
    //第一次執行時scrollView不做左移的動作
    firstStart = TRUE;
}

//取得資料庫的資料
-(void) getAllData
{
    NSError *error;
    results = [[context executeFetchRequest:fetchRequest error:&error] mutableCopy];
    
    if ([results count] == 0){
        return;
    }
    
    //清除ChartClass的infoArray和countArray,重新排列所有的值
    [chartClass removeDataLabel];
    
    for (int i=0;i<[results count];i++){
        infoData = [results objectAtIndex:i];
        
        //將infoData的資料一筆一筆傳到ChartClass
        [chartClass receiveData:[[infoData valueForKey:@"data"] floatValue] dataCount:[[infoData valueForKey:@"count"] intValue]];
        //每傳一筆圖表就重新畫過
        [chartClass setNeedsDisplay];
    }
    //儲存順序次數
    saveCount = [infoData.count intValue]+1;
    
    //依據量測數量並給予scrollView寬度
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width+([results count]*45), 300)];
    //依據量測樹量並給予monthlyView寬度
    [chartClass refreshWidthSize:[results count]*45];
    //存到9次以上和不是第一次執行此App時scrollView會自動向左移
    if ([results count] > 9 && firstStart == FALSE){
        CGFloat currentOffSet = scrollView.contentOffset.x;
        CGFloat newOffSet = currentOffSet + 45;
        [scrollView setContentOffset:CGPointMake(newOffSet, 0.0) animated:YES];
    }
}

//刪除所有記錄的資料
-(void) deleteAllData
{
    for (int i=0;i<[results count];i++){
        infoData = [results objectAtIndex:i];
        [context deleteObject:infoData];
    }
    
    NSError *error;
    
    if (![context save:&error]){
        NSLog(@"Delete infoData error:%@",error);
    }else{
        NSLog(@"%@",infoData);
    }
    
    //清除charClass上的點
    [chartClass removeDataLabel];
    [chartClass removeFromSuperview];
    [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 300)];
    saveCount = 0;
    [self viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
