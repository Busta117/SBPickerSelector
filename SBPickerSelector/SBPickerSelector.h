//
//  SBPickerSelector.h
//  SBPickerSelector
//
//  Created by Santiago Bustamante on 1/24/14.
//  Copyright (c) 2014 Busta117. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SBPickerSelector;

typedef NS_ENUM(NSInteger, PGPickerSelectorType) {
    PGPickerSelectorTypeNumerical = 0,
    PGPickerSelectorTypeDate,
    PGPickerSelectorTypeText,
};


@protocol PGPickerSelectorDelegate <NSObject>

@optional
-(void) PGPickerSelector:(SBPickerSelector *)selector dateSelected:(NSDate *)date;
-(void) PGPickerSelector:(SBPickerSelector *)selector selectedValue:(NSString *)value index:(NSInteger)idx;

@end


@interface SBPickerSelector : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    
    __weak IBOutlet UIToolbar *toolBar_;
    
    UIViewController *parent_;
}

@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePickerView;

@property (nonatomic, strong) UIView *background;
@property (nonatomic, strong) NSMutableArray *pickerData;
@property (nonatomic, assign) PGPickerSelectorType pickerType;
@property (nonatomic, weak) id<PGPickerSelectorDelegate> delegate;
@property (nonatomic, assign) int numberOfComponents;
@property (nonatomic, weak) id pickerId;
@property (nonatomic, assign) BOOL onlyDayPicker;


+ (SBPickerSelector *) picker;
- (void) showPickerOver:(UIViewController *)parent;


@end
