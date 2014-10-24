//
//  SBPickerSelector.m
//  SBPickerSelector
//
//  Created by Santiago Bustamante on 1/24/14.
//  Copyright (c) 2014 Busta117. All rights reserved.
//

#import "SBPickerSelector.h"
#import <QuartzCore/QuartzCore.h>

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@implementation SBPickerSelector

+ (instancetype) picker {
    return [SBPickerSelector pickerWithNibName:@"SBPickerSelector"];
}

+ (instancetype) pickerWithNibName:(NSString*)nibName {
    SBPickerSelector *instance = [[self alloc] initWithNibName:nibName bundle:nil];
    instance.pickerData = [NSMutableArray arrayWithCapacity:0];
    instance.numberOfComponents = 1;
    return instance;
}

- (void) showPickerOver:(UIViewController *)parent{

    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    
    self.background = [[UIView alloc] initWithFrame:window.bounds];
    [self.background setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0]];
    [window addSubview:self.background];
    [window addSubview:self.view];
    [parent addChildViewController:self];
    
    
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    
    __block CGRect frame = self.view.frame;
    float rotateAngle = 0;
    CGSize screenSize = CGSizeMake(window.frame.size.width, [self pickerSize].height);
    origin_ = CGPointMake(0,CGRectGetMaxY(window.bounds));
    CGPoint target = CGPointMake(0,origin_.y - CGRectGetHeight(frame));
    
    
    if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
        //only accept orientation in iphone
        if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
            
            switch (orientation) {
                case UIInterfaceOrientationPortraitUpsideDown:
                    rotateAngle = M_PI;
                    break;
                case UIInterfaceOrientationLandscapeLeft:
                    rotateAngle = -M_PI/2.0f;
                    screenSize = CGSizeMake(screenSize.height, window.frame.size.height);
                    origin_ = CGPointMake(CGRectGetMaxX(window.bounds),0);
                    target = CGPointMake(origin_.x - CGRectGetHeight(frame),0);
                    break;
                case UIInterfaceOrientationLandscapeRight:
                    rotateAngle = M_PI/2.0f;
                    screenSize = CGSizeMake(screenSize.height,window.frame.size.height);
                    origin_ = CGPointMake(-CGRectGetHeight(frame),0);
                    target = CGPointMake(origin_.x + CGRectGetHeight(frame),0);
                    break;
                default: // as UIInterfaceOrientationPortrait
                    rotateAngle = 0.0;
                    break;
            }
        }
    }
    
    
    self.view.transform = CGAffineTransformMakeRotation(rotateAngle);
    frame = self.view.frame;
    frame.size = screenSize;
    frame.origin = origin_;
    self.view.frame = frame;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        self.background.backgroundColor = [self.background.backgroundColor colorWithAlphaComponent:0.5];
        frame = self.view.frame;
        frame.origin = target;
        self.view.frame = frame;
        
    }];
    
    [self.pickerView reloadAllComponents];
    
    //only accept orientation in iphone
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(positionPicker:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
    }
            
    
}

- (void) positionPicker:(NSNotification*)notification{
    
    double animationDuration = 0;
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect orientationFrame = [UIScreen mainScreen].bounds;
    
    
    if(notification != nil) {
        NSDictionary* keyboardInfo = [notification userInfo];
        animationDuration = [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    }
    
    
    if(UIInterfaceOrientationIsLandscape(orientation)) {
        float temp = orientationFrame.size.width;
        orientationFrame.size.width = orientationFrame.size.height;
        orientationFrame.size.height = temp;
    }
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    
    CGFloat rotateAngle = 0;
    __block CGRect frame = self.view.frame;
    frame.size = [self pickerSize];
    CGSize screenSize = CGSizeMake(window.frame.size.width, [self pickerSize].height);
    origin_ = CGPointMake(0,CGRectGetMaxY(window.bounds));
    CGPoint target = CGPointMake(0,origin_.y - CGRectGetHeight(frame));
    
    
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            rotateAngle = M_PI;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            
            rotateAngle = -M_PI/2.0f;
            
            if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
                screenSize = CGSizeMake(screenSize.height, window.frame.size.height);
                origin_ = CGPointMake(CGRectGetMaxX(window.bounds),0);
                target = CGPointMake(origin_.x - CGRectGetHeight(frame),0);
            }else{
                target = CGPointMake(0,origin_.y - CGRectGetHeight(frame));
            }
            
            break;
        case UIInterfaceOrientationLandscapeRight:
            rotateAngle = M_PI/2.0f;
            
            if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
                screenSize = CGSizeMake(screenSize.height,window.frame.size.height);
                origin_ = CGPointMake(-CGRectGetHeight(frame),0);
                target = CGPointMake(origin_.x + CGRectGetHeight(frame),0);
            }else{
                target = CGPointMake(0,origin_.y - CGRectGetHeight(frame));
            }
            break;
        default: // as UIInterfaceOrientationPortrait
            rotateAngle = 0.0;
            break;
    }
    
    
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        if (SYSTEM_VERSION_LESS_THAN(@"8.0")) {
            self.view.transform = CGAffineTransformMakeRotation(rotateAngle);
            frame.origin = target;
            frame.size = screenSize;
            self.view.frame = frame;
        }else{
            frame.origin = target;
            self.view.frame = frame;
            self.background.transform = CGAffineTransformMakeRotation(-rotateAngle);
            self.background.frame = window.frame;
        }
    } completion:NULL];
    
    
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
        
        
        frame.size.height = CGRectGetHeight(self.optionsToolBar.frame) + CGRectGetHeight(self.datePickerView.frame);
        self.view.frame = frame;
        
        frame = self.datePickerView.frame;
        frame.origin.y = CGRectGetMaxY(self.optionsToolBar.frame);
        self.datePickerView.frame = frame;
 
    }else{
        [self.datePickerView removeFromSuperview];
        [self.view addSubview:self.pickerView];
        
        frame = self.pickerView.frame;
        frame.origin.y = CGRectGetMaxY(self.optionsToolBar.frame);
        self.pickerView.frame = frame;
        
    }
}

-(CGSize) pickerSize{
    CGSize size = self.view.frame.size;
    
    if (_pickerType == SBPickerSelectorTypeDate) {
        size.height = CGRectGetHeight(self.optionsToolBar.frame) + CGRectGetHeight(self.datePickerView.frame);
        size.width = CGRectGetWidth(self.datePickerView.frame);
    }else{
        size.height = CGRectGetHeight(self.optionsToolBar.frame) + CGRectGetHeight(self.pickerView.frame);
        size.width = CGRectGetWidth(self.pickerView.frame);
    }
    
    
    
    return size;
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

- (void) setDefaultDate:(NSDate *)defaultDate{
    _defaultDate = defaultDate;
    self.datePickerView.date = defaultDate;
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
        
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        if (self.delegate && [self.delegate respondsToSelector:@selector(SBPickerSelector:dateSelected:)]) {
            [self.delegate SBPickerSelector:self dateSelected:self.datePickerView.date];
        }
#pragma GCC diagnostic pop
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(pickerSelector:dateSelected:)]) {
            [self.delegate pickerSelector:self dateSelected:self.datePickerView.date];
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
        
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        if ([self.delegate respondsToSelector:@selector(SBPickerSelector:selectedValue:index:)]) {
            [self.delegate SBPickerSelector:self selectedValue:str index:[self.pickerView selectedRowInComponent:0]];
        }
#pragma GCC diagnostic pop
        
        if ([self.delegate respondsToSelector:@selector(pickerSelector:selectedValue:index:)]) {
            [self.delegate pickerSelector:self selectedValue:str index:[self.pickerView selectedRowInComponent:0]];
        }

    }
    
    [self dismissPicker];
}


- (IBAction)cancelAction:(id)sender {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    if (self.delegate && [self.delegate respondsToSelector:@selector(SBPickerSelector:cancelPicker:)]) {
        [self.delegate SBPickerSelector:self cancelPicker:YES];
    }
#pragma GCC diagnostic pop
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerSelector:cancelPicker:)]) {
        [self.delegate pickerSelector:self cancelPicker:YES];
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
        frame.origin = origin_;
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
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        if (self.delegate && [self.delegate respondsToSelector:@selector(SBPickerSelector:intermediatelySelectedValue:atIndex:)]) {
            [self.delegate SBPickerSelector:self intermediatelySelectedValue:self.datePickerView.date atIndex:0];
        }
#pragma GCC diagnostic pop
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(pickerSelector:intermediatelySelectedValue:atIndex:)]) {
            [self.delegate pickerSelector:self intermediatelySelectedValue:self.datePickerView.date atIndex:0];
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
        
        
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        if ([self.delegate respondsToSelector:@selector(SBPickerSelector:intermediatelySelectedValue:atIndex:)]) {
            [self.delegate SBPickerSelector:self intermediatelySelectedValue:str atIndex:[self.pickerView selectedRowInComponent:0]];
        }
#pragma GCC diagnostic pop
        if ([self.delegate respondsToSelector:@selector(pickerSelector:intermediatelySelectedValue:atIndex:)]) {
            [self.delegate pickerSelector:self intermediatelySelectedValue:str atIndex:[self.pickerView selectedRowInComponent:0]];
        }
        
    }
}

@end
