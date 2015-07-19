	//
	//  SBPickerSelector.h
	//  SBPickerSelector
	//
	//  Created by Santiago Bustamante on 1/24/14.
	//  Copyright (c) 2014 Busta117. All rights reserved.
	//

#import <UIKit/UIKit.h>

@class SBPickerSelector;

typedef NS_ENUM(NSInteger, SBPickerSelectorType) {
	SBPickerSelectorTypeNumerical = 0,
	SBPickerSelectorTypeDate,
	SBPickerSelectorTypeText,
};

typedef NS_ENUM(NSInteger, SBPickerSelectorDateType) {
	SBPickerSelectorDateTypeDefault = 0,
	SBPickerSelectorDateTypeOnlyDay,
	SBPickerSelectorDateTypeOnlyHour,
	SBPickerSelectorDateTypeOnlyMonthAndYear
};


@protocol SBPickerSelectorDelegate <NSObject>

@optional

-(void) pickerSelector:(SBPickerSelector *)selector dateSelected:(NSDate *)date;
-(void) pickerSelector:(SBPickerSelector *)selector selectedValue:(NSString *)value index:(NSInteger)idx;
-(void) pickerSelector:(SBPickerSelector *)selector intermediatelySelectedValue:(id)value atIndex:(NSInteger)idx;
-(void) pickerSelector:(SBPickerSelector *)selector cancelPicker:(BOOL)cancel;


@end


@interface SBPickerSelector : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
	
	UIViewController *parent_;
	
	UIPopoverController *popOver_;
	CGPoint origin_;
	
}

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UIToolbar *optionsToolBar;

@property (nonatomic, strong) UIView *background;
@property (nonatomic, strong) NSArray *pickerData;
@property (nonatomic, assign) SBPickerSelectorType pickerType;
@property (nonatomic, weak) id<SBPickerSelectorDelegate> delegate;
@property (nonatomic, assign) int numberOfComponents;
@property (nonatomic, weak) id pickerId;
@property (nonatomic, assign) int tag;
@property (nonatomic, assign) BOOL onlyDayPicker;
@property (nonatomic, assign) SBPickerSelectorDateType datePickerType;
@property (nonatomic, strong) NSDate *defaultDate;
@property (nonatomic, strong) NSString *doneButtonTitle;
@property (nonatomic, strong) NSString *cancelButtonTitle;

	//for month and year selection (default, min:2008, max: 2030)
@property (nonatomic, assign) int minYear;
@property (nonatomic, assign) int maxYear;


+ (instancetype) picker;
+ (instancetype) pickerWithNibName:(NSString*)nibName;
- (void) showPickerIpadFromRect:(CGRect)rect inView:(UIView *)view;
- (void) showPickerOver:(UIViewController *)parent;


@end
