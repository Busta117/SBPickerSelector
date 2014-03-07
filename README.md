SBPickerSelector
================

easy framework to setup pickers in your iOS project, easy picker manager.

you can see how to works in the example project the file named <b>"SBViewController"</b> in the method <b>showPicker:</b>

### Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like SBPickerSelector in your projects.

#### Podfile

```ruby
platform :ios, '5.0'
pod "SBPickerSelector", "~> 1.0.1"
```

### Installation without CocoaPods
- import in your project the folder "SBPickerSelector"

###How to use

- in your code import SBPickerSelector.h
```objective-c
#import "SBPickerSelector.h"
```
- implement delegate in your class
```objective-c
@interface className : UIViewController <SBPickerSelectorDelegate>
```
- add delegate methods depends of your necesities
```objective-c
//if your piker is a traditional selection
-(void) SBPickerSelector:(SBPickerSelector *)selector selectedValue:(NSString *)value index:(NSInteger)idx;

//if your picker is a date selection
-(void) SBPickerSelector:(SBPickerSelector *)selector dateSelected:(NSDate *)date;

//when picker value is changing
-(void) SBPickerSelector:(SBPickerSelector *)selector intermediatelySelectedValue:(id)value atIndex:(NSInteger)idx;

//if the user cancel the picker
-(void) SBPickerSelector:(SBPickerSelector *)selector cancelPicker:(BOOL)cancel;
```
- in your code add follow code when you need show the picker
```objective-c
SBPickerSelector *picker = [SBPickerSelector picker];

picker.pickerData = [@[@"one",@"two",@"three",@"four",@"five",@"six"] mutableCopy]; //picker content
picker.pickerType = SBPickerSelectorTypeText;

picker.pickerType = SBPickerSelectorTypeDate; //select date(needs implements delegate methid with date)
picker.onlyDayPicker = YES;  //if i want select only year, month and day, without hour (default NO)
picker.datePickerType = SBPickerSelectorDateTypeOnlyHour; //type of date picker (complete, only day, only hour)

picker.delegate = self;

picker.doneButtonTitle = @"Done";
picker.cancelButtonTitle = @"Cancel";


[picker showPickerOver:self]; //classic picker display 

[picker showPickerIpadFromRect:CGRectZero inView:self.view]; //if you whant a popover picker in ipad, set the view an point target(if you set this and opens in iphone, picker shows normally)
```
####feedback?

* twitter: [@busta117](http://www.twitter.com/busta117)
* mail: <busta117@gmail.com>
* <http://www.santiagobustamante.info>
