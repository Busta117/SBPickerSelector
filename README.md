SBPickerSelector
================

easy framework to setup pickers in your iOS project, easy picker manager.

you can see how to works in the example project the file named <b>"SBViewController"</b> in the method <b>showPicker:</b>

###How to use

- import in your project the folder "SBViewController"

- in your code import SBPickerSelector.h

        #import "SBPickerSelector.h"

- implement delegate in your class

        @interface className : UIViewController <SBPickerSelectorDelegate>

- add delegate methods depends of your necesities

        //if your piker is a traditional selection
        -(void) SBPickerSelector:(SBPickerSelector *)selector selectedValue:(NSString *)value index:(NSInteger)idx;
        
        //if your picker is a date selection
        -(void) SBPickerSelector:(SBPickerSelector *)selector dateSelected:(NSDate *)date;
        
        //if the user cancel the picker
        -(void) SBPickerSelector:(SBPickerSelector *)selector cancelPicker:(BOOL)cancel;

- in your code add follow code when you need show the picker

        SBPickerSelector *picker = [SBPickerSelector picker];
        
        picker.pickerData = [@[@"one",@"two",@"three",@"four",@"five",@"six"] mutableCopy]; //picker content
        picker.pickerType = SBPickerSelectorTypeText;
        
        picker.pickerType = SBPickerSelectorTypeDate; //select date(needs implements delegate methid with date)
        picker.onlyDayPicker = YES;  //if i want select only year, month and day, without hour (default NO)
        
        picker.delegate = self;
        [picker showPickerOver:self];
    
####feedback?

* twitter: [@busta117](http://www.twitter.com/busta117)
* mail: <busta117@gmail.com>
* <http://www.santiagobustamante.info>
