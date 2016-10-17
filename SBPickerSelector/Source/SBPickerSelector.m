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

#define DEFAULT_MAX_YEAR 2030
#define DEFAULT_MIN_YEAR 2014


@interface SBDatePickerViewMonthYear : UIPickerView <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong, readonly) NSDate *date;
@property (nonatomic, strong) NSArray *months;
@property (nonatomic, strong) NSArray *years;

@property (nonatomic, assign) NSInteger minYear;
@property (nonatomic, assign) NSInteger maxYear;
@property (nonatomic, strong) NSIndexPath *dateIndexPath;

-(void)setupMinYear:(NSInteger)minYear maxYear:(NSInteger)maxYear;
-(void)selectDate;
-(NSArray *)nameOfYears;
-(NSIndexPath *)pathForDate:(NSDate *) date;

@end

@interface SBPickerSelector()
@property (assign, nonatomic) BOOL isPopOver;
@property (strong, nonatomic) SBDatePickerViewMonthYear *dateOnlyMonthYearPickerView;

@end

@implementation SBPickerSelector

+ (instancetype) picker {
    NSLog(@"SBPickerSelector : please use the default init");
	return [SBPickerSelector pickerWithNibName:@"SBPickerSelector"];
}

+ (instancetype) pickerWithNibName:(NSString*)nibName {
	SBPickerSelector *instance = [[self alloc] initWithNibName:nibName bundle:[NSBundle bundleForClass:[SBPickerSelector class]]];
	instance.pickerData = [NSMutableArray arrayWithCapacity:0];
	instance.numberOfComponents = 1;
	return instance;
}

- (id) init {
    return [SBPickerSelector pickerWithNibName:@"SBPickerSelector"];
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

- (void) showPickerFromView:(UIView *)view inViewController:(UIViewController *)viewController{
	
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.isPopOver = YES;
        self.modalPresentationStyle = UIModalPresentationPopover;
        self.popoverPresentationController.sourceView = view;
        self.popoverPresentationController.sourceRect = CGRectMake(view.frame.size.width/2, view.frame.size.height/2, 5, 5);
        [self setPreferredContentSize:[self pickerSize]];
        [viewController presentViewController:self animated:NO completion:nil];
        
	}else{
		[self showPickerOver:viewController];
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

- (void) setMaximumDateAllowed: (NSDate*)allowedDate {
    
    self.datePickerView.maximumDate = allowedDate;
    
}

-(CGSize) pickerSize{
	CGSize size = self.view.frame.size;
	
	if (self.pickerType == SBPickerSelectorTypeDate && self.datePickerType != SBPickerSelectorDateTypeOnlyMonthAndYear) {
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
		case SBPickerSelectorDateTypeOnlyMonthAndYear:
			[self setOnlyMonthAndYearPicker];
			break;
		default:
			break;
	}
}

-(void) setOnlyMonthAndYearPicker{
	
	self.dateOnlyMonthYearPickerView = [SBDatePickerViewMonthYear new];
//	[self.dateOnlyMonthYearPickerView selectToday]; 
	
	[self.datePickerView removeFromSuperview];
	[self.pickerView removeFromSuperview];
	[self.view addSubview:self.dateOnlyMonthYearPickerView];
	
	CGRect frame = self.view.frame;
	frame.size.height = CGRectGetHeight(self.optionsToolBar.frame) + CGRectGetHeight(self.pickerView.frame);
	self.view.frame = frame;
	
	frame = self.dateOnlyMonthYearPickerView.frame;
	frame.origin.y = CGRectGetMaxY(self.optionsToolBar.frame);
	frame.size.height = CGRectGetHeight(self.pickerView.frame);
	self.dateOnlyMonthYearPickerView.frame = frame;
	
	
}


-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	if (self.dateOnlyMonthYearPickerView) {

/*
        NSInteger min = self.minYear > 0 ? self.minYear : self.dateOnlyMonthYearPickerView.minYear;
        NSInteger max = self.maxYear > 0 ? self.maxYear : self.dateOnlyMonthYearPickerView.maxYear;
        
        [self.dateOnlyMonthYearPickerView setupMinYear:min maxYear:max];
  */
        if (self.minYear > 0 || self.maxYear > 0){
            [self.dateOnlyMonthYearPickerView setupMinYear:self.minYear maxYear:self.maxYear];
        }
        
        if (self.defaultDate != nil) {
            self.dateOnlyMonthYearPickerView.dateIndexPath = [self.dateOnlyMonthYearPickerView pathForDate:self.defaultDate];
        }
        
        [self.dateOnlyMonthYearPickerView selectDate];
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
	
		if (_datePickerType == SBPickerSelectorDateTypeOnlyMonthAndYear){
			if (self.delegate && [self.delegate respondsToSelector:@selector(pickerSelector:dateSelected:)]) {
				[self.delegate pickerSelector:self dateSelected:[self.dateOnlyMonthYearPickerView date]];
			}
			[self dismissPicker];
			return;
		}
		
		if (self.delegate && [self.delegate respondsToSelector:@selector(pickerSelector:dateSelected:)]) {
			[self.delegate pickerSelector:self dateSelected:self.datePickerView.date];
		}
        
		[self dismissPicker];
		return;
	}
	
    if (self.delegate && self.pickerData.count > 0) {
        
        NSMutableArray *values = [NSMutableArray new];
        NSMutableArray *indexes = [NSMutableArray new];
        
		NSMutableString *str = [NSMutableString stringWithString:@""];
		for (int i = 0; i < self.numberOfComponents; i++) {
			if (self.numberOfComponents == 1) {
                int rowSelected = [self.pickerView selectedRowInComponent:i];
                
				[str appendString:self.pickerData[rowSelected]];
                
                [values addObject:self.pickerData[rowSelected]];
                [indexes addObject:[NSNumber numberWithInt:rowSelected]];
                
			}else{
                
                int rowSelected = [self.pickerView selectedRowInComponent:i];
                
                NSMutableArray *componentData = self.pickerData[i];
                [str appendString:componentData[rowSelected]];
                if (i<self.numberOfComponents-1) {
                    [str appendString:@" "];
                }
                
                [values addObject:componentData[rowSelected]];
                [indexes addObject:[NSNumber numberWithInt:rowSelected]];
                
			}
		}
		
		//deprecated
		if ([self.delegate respondsToSelector:@selector(pickerSelector:selectedValue:index:)]) {
			[self.delegate pickerSelector:self selectedValue:str index:[self.pickerView selectedRowInComponent:0]];
		}
		
        if ([self.delegate respondsToSelector:@selector(pickerSelector:selectedValues:atIndexes:)]) {
            [self.delegate pickerSelector:self selectedValues:values atIndexes:indexes];
        }
        
	}
	
	[self dismissPicker];
}


- (IBAction)cancelAction:(id)sender {
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(pickerSelector:cancelPicker:)]) {
		[self.delegate pickerSelector:self cancelPicker:YES];
	}
	[self dismissPicker];
}

- (void) dismissPicker{
	
    if (self.isPopOver){
        [self dismissViewControllerAnimated:YES completion:nil];
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
		//deprecated
		if (self.delegate && [self.delegate respondsToSelector:@selector(pickerSelector:intermediatelySelectedValue:atIndex:)]) {
			[self.delegate pickerSelector:self intermediatelySelectedValue:self.datePickerView.date atIndex:0];
		}
		
        if (self.delegate && [self.delegate respondsToSelector:@selector(pickerSelector:intermediatelySelectedValues:atIndexes:)]) {
            [self.delegate pickerSelector:self intermediatelySelectedValues:@[self.datePickerView.date] atIndexes:@[[NSNumber numberWithInt:0]]];
        }
        
		return;
	}
	
    if (self.delegate && self.pickerData.count > 0) {
        
        NSMutableArray *values = [NSMutableArray new];
        NSMutableArray *indexes = [NSMutableArray new];
        
		NSMutableString *str = [NSMutableString stringWithString:@""];
		for (int i = 0; i < self.numberOfComponents; i++) {
			if (self.numberOfComponents == 1) {
                
                [values addObject:self.pickerData[[self.pickerView selectedRowInComponent:0]]];
                [indexes addObject:[NSNumber numberWithInt:0]];
                
				[str appendString:self.pickerData[[self.pickerView selectedRowInComponent:0]]];
			}else{
                
                int rowSelected = [self.pickerView selectedRowInComponent:i];
                
				NSMutableArray *componentData = self.pickerData[i];
				[str appendString:componentData[rowSelected]];
				if (i<self.numberOfComponents-1) {
					[str appendString:@" "];
				}
                
                
                [values addObject:componentData[rowSelected]];
                [indexes addObject:[NSNumber numberWithInt:rowSelected]];
                
			}
		}
		
        //deprecated
		if ([self.delegate respondsToSelector:@selector(pickerSelector:intermediatelySelectedValue:atIndex:)]) {
			[self.delegate pickerSelector:self intermediatelySelectedValue:str atIndex:[self.pickerView selectedRowInComponent:0]];
		}
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(pickerSelector:intermediatelySelectedValues:atIndexes:)]) {
            [self.delegate pickerSelector:self intermediatelySelectedValues:values atIndexes:indexes];
        }
		
		
	}
}

@end



	// Identifiers of components
#define MONTH ( 0 )
#define YEAR ( 1 )


	// Identifies for component views
#define LABEL_TAG 43


@interface SBDatePickerViewMonthYear()

@end

@implementation SBDatePickerViewMonthYear

const NSInteger bigRowCount = 1000;
const NSInteger numberOfComponents = 2;

#pragma mark - Init

-(instancetype)init
{
	if (self = [super init])
	{
		[self loadDefaultsParameters];
	}
	return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
	if (self = [super initWithFrame:frame])
	{
		[self loadDefaultsParameters];
	}
	return self;
}

-(void)awakeFromNib
{
	[super awakeFromNib];
	
	[self loadDefaultsParameters];
}


#pragma mark - Open methods

-(NSDate *)date
{
	NSInteger monthCount = self.months.count;
	NSString *month = [self.months objectAtIndex:([self selectedRowInComponent:MONTH] % monthCount)];
	
	NSInteger yearCount = self.years.count;
	NSString *year = [self.years objectAtIndex:([self selectedRowInComponent:YEAR] % yearCount)];
	
	NSDateFormatter *formatter = [NSDateFormatter new];
	[formatter setDateFormat:@"MMMM:yyyy"];
	[formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
	NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@:%@", month, year]];
	return date;
}

- (void)setupMinYear:(NSInteger)minYear maxYear:(NSInteger)maxYear
{
    minYear = minYear == 0 ? DEFAULT_MIN_YEAR : minYear;
    maxYear = maxYear == 0 ? DEFAULT_MAX_YEAR : maxYear;
    
	self.minYear = minYear;
	
	if (maxYear > minYear)
	{
		self.maxYear = maxYear;
	}
	else
	{
		self.maxYear = minYear + 10;
	}
	
	self.years = [self nameOfYears];
	self.dateIndexPath = [self todayPath];
}

-(void)selectDate
{
	[self selectRow: self.dateIndexPath.row
		inComponent: MONTH
		   animated: NO];
	
	[self selectRow: self.dateIndexPath.section
		inComponent: YEAR
		   animated: NO];
}

#pragma mark - UIPickerViewDelegate

-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	return [self componentWidth];
}

-(UIView *)pickerView: (UIPickerView *)pickerView viewForRow: (NSInteger)row forComponent: (NSInteger)component reusingView: (UIView *)view
{
	BOOL selected = NO;
	if(component == MONTH)
	{
		NSInteger monthCount = self.months.count;
		NSString *monthName = [self.months objectAtIndex:(row % monthCount)];
		NSString *currentMonthName = [self currentMonthName];
		if([monthName isEqualToString:currentMonthName] == YES)
		{
			selected = YES;
		}
	}
	else
	{
		NSInteger yearCount = self.years.count;
		NSString *yearName = [self.years objectAtIndex:(row % yearCount)];
		NSString *currenrYearName  = [self currentYearName];
		if([yearName isEqualToString:currenrYearName] == YES)
		{
			selected = YES;
		}
	}
	
	UILabel *returnView = nil;
	if(view.tag == LABEL_TAG)
	{
		returnView = (UILabel *)view;
	}
	else
	{
		returnView = [self labelForComponent:component];
	}
	
	returnView.text = [self titleForRow:row forComponent:component];
	return returnView;
}

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	return 44;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return numberOfComponents;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	if(component == MONTH)
	{
		return [self bigRowMonthCount];
	}
	return [self bigRowYearCount];
}

#pragma mark - Util

-(NSInteger)bigRowMonthCount
{
	return self.months.count  * bigRowCount;
}

-(NSInteger)bigRowYearCount
{
	return self.years.count  * bigRowCount;
}

-(CGFloat)componentWidth
{
	return self.bounds.size.width / numberOfComponents;
}

-(NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if(component == MONTH)
	{
		NSInteger monthCount = self.months.count;
		return [self.months objectAtIndex:(row % monthCount)];
	}
	NSInteger yearCount = self.years.count;
	
	return [self.years objectAtIndex:(row % yearCount)];
}

-(UILabel *)labelForComponent:(NSInteger)component
{
	CGRect frame = CGRectMake(0, 0, [self componentWidth], 44);
	
	UILabel *label = [[UILabel alloc] initWithFrame:frame];
	label.textAlignment = NSTextAlignmentCenter;
	label.backgroundColor = [UIColor clearColor];
	label.userInteractionEnabled = NO;
	
	label.tag = LABEL_TAG;
	
	return label;
}

-(NSArray *)nameOfMonths
{
	return @[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
}

-(NSArray *)nameOfYears
{
	NSMutableArray *years = [NSMutableArray array];
	
	for(NSInteger year = self.minYear; year <= self.maxYear; year++)
	{
		NSString *yearStr = [NSString stringWithFormat:@"%li", (long)year];
		[years addObject:yearStr];
	}
	return years;
}


-(NSIndexPath *)pathForDate:(NSDate *)date // row - month ; section - year
{
    CGFloat row = 0.f;
    CGFloat section = 0.f;
    
    NSString *month = [self monthNameForDate:date];
    NSString *year  = [self yearNameForDate:date];
    
    //set table on the middle
    for(NSString *cellMonth in self.months)
    {
        if([cellMonth isEqualToString:month])
        {
            row = [self.months indexOfObject:cellMonth];
            row = row + ([self bigRowMonthCount] / 2);
            break;
        }
    }
    
    for(NSString *cellYear in self.years)
    {
        if([cellYear isEqualToString:year])
        {
            section = [self.years indexOfObject:cellYear];
            section = section + ([self bigRowYearCount] / 2);
            break;
        }
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}



-(NSIndexPath *)todayPath // row - month ; section - year
{
    return [self pathForDate:[NSDate date]];
}

-(NSString *)currentMonthName
{
	return [self monthNameForDate:[NSDate date]];
}

-(NSString *)monthNameForDate:(NSDate *)date
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setDateFormat:@"MMMM"];
    return [formatter stringFromDate:date];
}

-(NSString *)currentYearName
{
    return [self yearNameForDate:[NSDate date]];
}

-(NSString *)yearNameForDate:(NSDate *)date
{
	NSDateFormatter *formatter = [NSDateFormatter new];
	[formatter setDateFormat:@"yyyy"];
	[formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
	return [formatter stringFromDate:date];
}


-(void)loadDefaultsParameters
{
    self.minYear = DEFAULT_MIN_YEAR;
    self.maxYear = DEFAULT_MAX_YEAR;
	
	self.months = [self nameOfMonths];
	self.years = [self nameOfYears];
	self.dateIndexPath = [self todayPath];
	
	self.delegate = self;
	self.dataSource = self;
	
}

@end


