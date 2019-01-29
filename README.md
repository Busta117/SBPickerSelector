SBPickerSelector
================

easy framework to setup pickers in your iOS project, easy picker manager, now with swift compatibility

you can see how to works in the example project the file named **"ViewController.swift"** in the method **showPickerAction**


![alt tag](https://raw.githubusercontent.com/Busta117/SBPickerSelector/master/preview.png)



### Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C and Swift, which automates and simplifies the process of using 3rd-party libraries like SBPickerSelector in your projects.

#### Podfile

```ruby
platform :ios, '9.0'
pod 'SBPickerSelector'
```

### Installation without CocoaPods
- import in your project the folder "SBPickerSelector"

### How to use

in the header of your file...
```swift
import SBPickerSwiftSelector
```

and just create an object **SBPickerSwiftSelector** with the params that you want.

- picker modes:
  - text: just a list to select
  - dateDefault: date selection with full data(year, month, day, hour, minutes)
  - dateHour: just an option to select hour and minutes
  - dateDayMonthYear: option to select day, month and year
  - dateMonthYear: option to select just month and year

- params:
  - mode: mode of the picker
  - data: an array of the datasource, can be [String] or [[String]], single string array will be display a list of 1 section with the list, array of array will display each array in a separate sections (just mandatory in mode *.text*)
  - startDate: min date for the date selection (ignored in mode: *.text*, default *nil* - year 1920)
  - endDate: max date for the date selection (ignored in mode: *.text*, default *nil* - year 2050)
  - defaultDate: default text displayed in the picker(ignored in mode: *.text*, default *nil*)

if you want to implement a cancel action just append the **cancel** method of the picker, and if you want to implement a set action just append the **set** method, this set method will return [Any] where will be [String] or [[String]] if it in *.text* mode and will be [Date] with only 1 date for the any of the date selection.

```swift
SBPickerSwiftSelector(mode: SBPickerSwiftSelector.Mode.dateHour, data: ["hi","there"], defaultDate: Date()).cancel {
            print("cancel, will be autodismissed")
            }.set { values in
                if let values = values as? [String] {
                    sender.setTitle(values[0], for: UIControl.State.normal)
                } else if let values = values as? [Date] {

                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YYYY-MM"
                    print(dateFormatter.string(from: values[0]))
                }

        }.present(into: self)
```
#### feedback?

* twitter: [@busta117](http://www.twitter.com/busta117)
* mail: <busta117@gmail.com>
* <http://www.santiagobustamante.info>
