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

-(void) pickerSelector:(SBPickerSelector * _Nonnull)selector dateSelected:(NSDate *_Nonnull)date;
-(void) pickerSelector:(SBPickerSelector * _Nonnull)selector selectedValues:(NSArray<NSString *> * _Nonnull)values atIndexes:(NSArray<NSNumber *> * _Nonnull)idxs;
-(void) pickerSelector:(SBPickerSelector * _Nonnull)selector intermediatelySelectedValues:(NSArray<NSString *> * _Nonnull)values atIndexes:(NSArray<NSNumber *> * _Nonnull)idxs;
-(void) pickerSelector:(SBPickerSelector * _Nonnull)selector cancelPicker:(BOOL)cancel;

//deprecated

-(void) pickerSelector:(SBPickerSelector * _Nonnull)selector selectedValue:(NSString * _Nonnull)value index:(NSInteger)idx __attribute__((deprecated("use pickerSelector:selectedValues:atIndexes instead.")));
-(void) pickerSelector:(SBPickerSelector * _Nonnull)selector intermediatelySelectedValue:(id  _Nonnull)value atIndex:(NSInteger)idx __attribute__((deprecated));

@end


@interface SBPickerSelector : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
	
	UIViewController *parent_;
	CGPoint origin_;
	
}

@property (strong, nonatomic) IBOutlet UIPickerView * _Nonnull pickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker * _Nonnull datePickerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem * _Nullable cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem * _Nullable doneButton;
@property (weak, nonatomic) IBOutlet UIToolbar * _Nullable optionsToolBar;

@property (nonatomic, strong) UIView * _Nonnull background;
@property (nonatomic, strong) NSArray * _Nonnull pickerData;
@property (nonatomic, assign) SBPickerSelectorType pickerType;
@property (nonatomic, weak) id<SBPickerSelectorDelegate> _Nullable delegate;
@property (nonatomic, assign) int numberOfComponents;
@property (nonatomic, strong) NSString * _Nullable pickerId;
@property (nonatomic, assign) int tag;
@property (nonatomic, assign) BOOL onlyDayPicker;
@property (nonatomic, assign) SBPickerSelectorDateType datePickerType;
@property (nonatomic, strong) NSDate * _Nullable defaultDate;
@property (nonatomic, strong) NSString * _Nullable doneButtonTitle;
@property (nonatomic, strong) NSString * _Nullable cancelButtonTitle;

	//for month and year selection (default, min:2014, max: 2030)
@property (nonatomic, assign) int minYear;
@property (nonatomic, assign) int maxYear;


+ (instancetype _Nonnull) picker;
+ (instancetype _Nonnull) pickerWithNibName:(NSString* _Nonnull)nibName;
- (void) showPickerFromView:(UIView * _Nonnull)view inViewController:(UIViewController * _Nonnull)viewController;
- (void) showPickerOver:(UIViewController * _Nonnull)parent;
- (void) setMaximumDateAllowed: (NSDate* _Nonnull)allowedDate;


@end
