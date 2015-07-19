//
//  ViewController.swift
//  swift-SBPickerSelectorExample
//
//  Created by Santiago Bustamante on 10/24/14.
//  Copyright (c) 2014 Santiago Bustamante. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SBPickerSelectorDelegate {

    @IBOutlet weak var resultLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func showPicker(sender: AnyObject) {
        
        
        //*********************
        //setup here your picker
        //*********************
        
        let picker: SBPickerSelector = SBPickerSelector.picker()
        
        picker.pickerData = ["one","two","three","four","five","six"] //picker content
        picker.delegate = self
        picker.pickerType = SBPickerSelectorType.Text
        picker.doneButtonTitle = "Done"
        picker.cancelButtonTitle = "Cancel"

//		picker.pickerType = SBPickerSelectorType.Date //select date(needs implements delegate method with date)
//        picker.datePickerType = SBPickerSelectorDateType.OnlyMonthAndYear
//		picker.minYear = 2015
//		picker.maxYear = 2051

        
//        picker.showPickerOver(self)
        
        let point: CGPoint = view.convertPoint(sender.frame.origin, fromView: sender.superview)
        var frame: CGRect = sender.frame
        frame.origin = point
        picker.showPickerIpadFromRect(frame, inView: view)
        

    }

    
    //MARK: SBPickerSelectorDelegate
    func pickerSelector(selector: SBPickerSelector!, selectedValue value: String!, index idx: Int) {
        resultLbl.text = value
    }
    
    func pickerSelector(selector: SBPickerSelector!, dateSelected date: NSDate!) {
    
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        resultLbl.text = dateFormat.stringFromDate(date)
    }
    

    func pickerSelector(selector: SBPickerSelector!, cancelPicker cancel: Bool) {
        print("press cancel")
    }
    
    func pickerSelector(selector: SBPickerSelector!, intermediatelySelectedValue value: AnyObject!, atIndex idx: Int) {
        if value.isMemberOfClass(NSDate){
            pickerSelector(selector, dateSelected: value as! NSDate)
        }else{
            pickerSelector(selector, selectedValue: value as! String, index: idx)
        }
    }
    
}

