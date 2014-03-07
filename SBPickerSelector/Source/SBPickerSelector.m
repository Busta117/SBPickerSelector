//
//  SBPickerSelector.m
//  SBPickerSelector
//
//  Created by Santiago Bustamante on 1/24/14.
//  Copyright (c) 2014 Busta117. All rights reserved.
//

#import "SBPickerSelector.h"

@implementation SBPickerSelector

+ (SBPickerSelector *) picker {
    return [SBPickerSelector pickerWithNibName:@"SBPickerSelector"];
}

+ (SBPickerSelector *) pickerWithNibName:(NSString*)nibName {
    SBPickerSelector *instance = [[SBPickerSelector alloc] initWithNibName:nibName bundle:nil];
    instance.pickerData = [NSMutableArray arrayWithCapacity:0];
    instance.numberOfComponents = 1;
    return instance;
}

- (void) showPickerOver:(UIViewController *)parent{

    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    __block CGRect frame = self.view.frame;
    frame.origin.y = CGRectGetMaxY(window.bounds);
    self.view.frame = frame;
    
    self.background = [[UIView alloc] initWithFrame:window.bounds];
    [self.background setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];
    [window addSubview:self.background];
    [window addSubview:self.view];
    [parent addChildViewController:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.background.backgroundColor = [self.background.backgroundColor colorWithAlphaComponent:0.5];
        frame = self.view.frame;
        frame.origin.y -= CGRectGetHeight(frame);
        self.view.frame = frame;
        
    }];
    
    [self.pickerView reloadAllComponents];
    
}


- (void) showPickerIpadFromRect:(CGRect)rect inView:(UIView *)view{
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        popOver_ = [[UIPopoverController alloc] initWithContentViewController:self];
        [popOver_ setPopoverContentSize:self.view.frame.size];
        [popOver_ presentPopoverFromRect:rect inView:view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else{
        [self showPickerOver:(UIViewController *)[self traverseResponderChainForUIViewController:view]];
    }
    
}

- (id) traverseResponderChainForUIViewController:(UIView *)view {
    id nextResponder = [view nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [self traverseResponderChainForUIViewController:nextResponder];
    } else {
        return nil;
    }
}


- (void) setPickerType:(SBPickerSelectorType)pickerType{
    _pickerType = pickerType;
    
    CGRect frame = self.view.frame;
    
    if (pickerType == SBPickerSelectorTypeDate) {
        [self.pickerView removeFromSuperview];
        [self.view addSubview:self.datePickerView];
        
        
        frame.size.height = CGRectGetHeight(toolBar_.frame) + CGRectGetHeight(self.datePickerView.frame);
        self.view.frame = frame;
        
        frame = self.datePickerView.frame;
        frame.origin.y = CGRectGetMaxY(toolBar_.frame);
        self.datePickerView.frame = frame;
 
    }else{
        [self.datePickerView removeFromSuperview];
        [self.view addSubview:self.pickerView];
        
        frame = self.pickerView.frame;
        frame.origin.y = CGRectGetMaxY(toolBar_.frame);
        self.pickerView.frame = frame;
        
    }
}

- (void) setOnlyDayPicker:(BOOL)onlyDaySelector{
    _onlyDayPicker = onlyDaySelector;
    if (onlyDaySelector) {
        self.datePickerView.datePickerMode = UIDatePickerModeDate;
    }else{
        self.datePickerView.datePickerMode = UIDatePickerModeDateAndTime;
    }
}


- (void) setDatePickerType:(SBPickerSelectorDateType)datePickerType{
    _datePickerType = datePickerType;

    switch (datePickerType) {
        case SBPickerSelectorDateTypeDefault:
            self.datePickerView.datePickerMode = UIDatePickerModeDateAndTime;
            break;
        case SBPickerSelectorDateTypeOnlyDay:
            self.datePickerView.datePickerMode = UIDatePickerModeDate;
            break;
        case SBPickerSelectorDateTypeOnlyHour:
            self.datePickerView.datePickerMode = UIDatePickerModeTime;
            break;
        default:
            break;
    }
}


- (void) setDoneButtonTitle:(NSString *)doneButtonTitle{
    self.doneButton.title = doneButtonTitle;
}

- (NSString *)doneButtonTitle{
    return self.doneButton.title;
}

- (void) setCancelButtonTitle:(NSString *)cancelButtonTitle{
    self.cancelButton.title = cancelButtonTitle;
}

- (NSString *)cancelButtonTitle{
    return self.cancelButton.title;
}

- (IBAction)setAction:(id)sender {
    if (self.pickerType == SBPickerSelectorTypeDate) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(SBPickerSelector:dateSelected:)]) {
            [self.delegate SBPickerSelector:self dateSelected:self.datePickerView.date];
        }
            [self dismissPicker];
        return;
    }
    
    if (self.delegate) {
        NSMutableString *str = [NSMutableString stringWithString:@""];
        for (int i = 0; i < self.numberOfComponents; i++) {
            if (self.numberOfComponents == 1) {
                [str appendString:self.pickerData[[self.pickerView selectedRowInComponent:0]]];
            }else{
                NSMutableArray *componentData = self.pickerData[i];
                [str appendString:componentData[[self.pickerView selectedRowInComponent:i]]];
                if (i<self.numberOfComponents-1) {
                    [str appendString:@" "];
                }
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(SBPickerSelector:selectedValue:index:)]) {
            [self.delegate SBPickerSelector:self selectedValue:str index:[self.pickerView selectedRowInComponent:0]];
        }

    }
    
    [self dismissPicker];
}


- (IBAction)cancelAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(SBPickerSelector:cancelPicker:)]) {
        [self.delegate SBPickerSelector:self cancelPicker:YES];
    }
    [self dismissPicker];
}

- (void) dismissPicker{
    
    if (popOver_) {
        [popOver_ dismissPopoverAnimated:YES];
        return;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.background.backgroundColor = [self.background.backgroundColor colorWithAlphaComponent:0];
        CGRect frame = self.view.frame;
        frame.origin.y += CGRectGetHeight(frame);
        self.view.frame = frame;
        
    } completion:^(BOOL finished) {
        [self.background removeFromSuperview];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];
    
}


#pragma mark - picker delegate and datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return self.numberOfComponents;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (self.numberOfComponents > 1) {
        NSMutableArray *comp = self.pickerData[component];
        return comp.count;
    }
    return self.pickerData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (self.numberOfComponents > 1) {
        NSMutableArray *comp = self.pickerData[component];
        return comp[row];
    }
    return self.pickerData[row];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (self.pickerType == SBPickerSelectorTypeDate) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(SBPickerSelector:intermediatelySelectedValue:atIndex:)]) {
            [self.delegate SBPickerSelector:self intermediatelySelectedValue:self.datePickerView.date atIndex:0];
        }
        return;
    }
    
    if (self.delegate) {
        NSMutableString *str = [NSMutableString stringWithString:@""];
        for (int i = 0; i < self.numberOfComponents; i++) {
            if (self.numberOfComponents == 1) {
                [str appendString:self.pickerData[[self.pickerView selectedRowInComponent:0]]];
            }else{
                NSMutableArray *componentData = self.pickerData[i];
                [str appendString:componentData[[self.pickerView selectedRowInComponent:i]]];
                if (i<self.numberOfComponents-1) {
                    [str appendString:@" "];
                }
            }
        }
        
        if ([self.delegate respondsToSelector:@selector(SBPickerSelector:intermediatelySelectedValue:atIndex:)]) {
            [self.delegate SBPickerSelector:self intermediatelySelectedValue:str atIndex:[self.pickerView selectedRowInComponent:0]];
        }
        
    }
}

@end
