//
//  SBViewController.m
//  SBPickerSelectorExample
//
//  Created by Santiago Bustamante on 1/24/14.
//  Copyright (c) 2014 Busta117. All rights reserved.
//

#import "SBViewController.h"


@interface SBViewController ()
{
    UILabel *resultLbl_;
}


@end

@implementation SBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *but = [UIButton buttonWithType:UIButtonTypeSystem];
    but.frame = CGRectMake(0, 0, 200, 50);
    but.center = self.view.center;
    [but setTitle:@"show picker" forState:UIControlStateNormal];
    [but addTarget:self action:@selector(showPicker:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:but];
    
    resultLbl_ = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    resultLbl_.text = @"result here";
    resultLbl_.textAlignment = NSTextAlignmentCenter;
    resultLbl_.center = CGPointMake(but.center.x, but.center.y + 50);
    [self.view addSubview:resultLbl_];
    
    
}


- (void) showPicker:(id)sender{
    
    
    
    //*********************
    //setup here your picker
    //*********************
    
    
    SBPickerSelector *picker = [SBPickerSelector picker];
    
    picker.pickerData = [@[@"one",@"two",@"three",@"four",@"five",@"six"] mutableCopy]; //picker content
    picker.pickerType = SBPickerSelectorTypeText;
    
//    picker.pickerType = PGPickerSelectorTypeDate; //select date(needs implements delegate method with date)
//    picker.onlyDayPicker = YES;  //if i want select only year, month and day, without hour (default NO)

    picker.delegate = self;
    [picker showPickerOver:self];
    
}


#pragma mark - pickerSelector Delegate
-(void) SBPickerSelector:(SBPickerSelector *)selector selectedValue:(NSString *)value index:(NSInteger)idx{
    resultLbl_.text = value;
}


-(void) SBPickerSelector:(SBPickerSelector *)selector dateSelected:(NSDate *)date{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    resultLbl_.text = [dateFormat stringFromDate:date];
}

-(void) SBPickerSelector:(SBPickerSelector *)selector cancelPicker:(BOOL)cancel{
    NSLog(@"press cancel");
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
