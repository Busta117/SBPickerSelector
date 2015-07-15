SBPickerSelector
================

easy framework to setup pickers in your iOS project, easy picker manager, now with swift compatibility

you can see how to works in the example project the file named <b>"SBViewController"</b> in the method <b>showPicker:</b>


![alt tag](https://raw.githubusercontent.com/Busta117/SBPickerSelector/master/preview.png)



### Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like SBPickerSelector in your projects.

#### Podfile

```ruby
platform :ios, '6.0'
pod 'SBPickerSelector'
```

### Installation without CocoaPods
- import in your project the folder "SBPickerSelector"

###How to use

- in your code import SBPickerSelector.h
```objective-c
#import "SBPickerSelector.h"
```
<b>swift:</b>
```swift

#import "SBPickerSelector.h" //in your -Bridging-Header.h file
#//if you are using frameworks:
#import SBPickerSelector //in the class where you will use it
```
- implement delegate in your class
```objective-c
@interface className : UIViewController <SBPickerSelectorDelegate>
```
<b>swift:</b>
```swift
class className: UIViewController, SBPickerSelectorDelegate
```
- add delegate methods depends of your necesities
```objective-c
//if your piker is a traditional selection
-(void) pickerSelector:(SBPickerSelector *)selector selectedValue:(NSString *)value index:(NSInteger)idx;
//if your picker is a date selection
-(void) pickerSelector:(SBPickerSelector *)selector dateSelected:(NSDate *)date;
//when picker value is changing
-(void) pickerSelector:(SBPickerSelector *)selector intermediatelySelectedValue:(id)value atIndex:(NSInteger)idx;
//if the user cancel the picker
-(void) pickerSelector:(SBPickerSelector *)selector cancelPicker:(BOOL)cancel;
```
<b>swift:</b>
```swift
//if your piker is a traditional selection
func pickerSelector(selector: SBPickerSelector!, selectedValue value: String!, index idx: Int)
//if your picker is a date selection
func pickerSelector(selector: SBPickerSelector!, dateSelected date: NSDate!)
//when picker value is changing
func pickerSelector(selector: SBPickerSelector!, intermediatelySelectedValue value: AnyObject!, atIndex idx: Int)
//if the user cancel the picker
func pickerSelector(selector: SBPickerSelector!, cancelPicker cancel: Bool)
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

<b>swift:</b>
```swift
var picker: SBPickerSelector = SBPickerSelector.picker()        
picker.pickerData = ["one","two","three","four","five","six"] //picker content
picker.delegate = self
picker.pickerType = SBPickerSelectorType.Text
picker.doneButtonTitle = "Done"
picker.cancelButtonTitle = "Cancel"

picker.pickerType = SBPickerSelectorType.Date //select date(needs implements delegate method with date)
picker.datePickerType = SBPickerSelectorDateType.OnlyHour //type of date picker (complete, only day, only hour)

picker.showPickerOver(self) //classic picker display 

var point: CGPoint = view.convertPoint(sender.frame.origin, fromView: sender.superview)
var frame: CGRect = sender.frame
frame.origin = point
picker.showPickerIpadFromRect(frame, inView: view) //if you whant a popover picker in ipad, set the view an point target(if you set this and opens in iphone, picker shows normally)
```
####feedback?

* twitter: [@busta117](http://www.twitter.com/busta117)
* mail: <busta117@gmail.com>
* <http://www.santiagobustamante.info>
