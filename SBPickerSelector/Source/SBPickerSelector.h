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
};


@protocol SBPickerSelectorDelegate <NSObject>

@optional
-(void) SBPickerSelector:(SBPickerSelector *)selector dateSelected:(NSDate *)date;
-(void) SBPickerSelector:(SBPickerSelector *)selector selectedValue:(NSString *)value index:(NSInteger)idx;
-(void) SBPickerSelector:(SBPickerSelector *)selector intermediatelySelectedValue:(id)value atIndex:(NSInteger)idx;
-(void) SBPickerSelector:(SBPickerSelector *)selector cancelPicker:(BOOL)cancel;
@end


@interface SBPickerSelector : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    
    __weak IBOutlet UIToolbar *toolBar_;
    
    UIViewController *parent_;
    
    UIPopoverController *popOver_;
}

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic, strong) UIView *background;
@property (nonatomic, strong) NSMutableArray *pickerData;
@property (nonatomic, assign) SBPickerSelectorType pickerType;
@property (nonatomic, weak) id<SBPickerSelectorDelegate> delegate;
@property (nonatomic, assign) int numberOfComponents;
@property (nonatomic, weak) id pickerId;
@property (nonatomic, assign) int tag;
@property (nonatomic, assign) BOOL onlyDayPicker;
@property (nonatomic, assign) SBPickerSelectorDateType datePickerType;
@property (nonatomic, strong) NSString *doneButtonTitle;
@property (nonatomic, strong) NSString *cancelButtonTitle;


+ (SBPickerSelector *) picker;
+ (SBPickerSelector *) pickerWithNibName:(NSString*)nibName;
- (void) showPickerIpadFromRect:(CGRect)rect inView:(UIView *)view;
- (void) showPickerOver:(UIViewController *)parent;


@end
