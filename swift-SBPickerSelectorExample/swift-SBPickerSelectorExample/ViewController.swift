//
//  ViewController.swift
//  swift-SBPickerSelectorExample
//
//  Created by Santiago Bustamante on 10/14/16.
//  Copyright © 2016 Santiago Bustamante. All rights reserved.
//

import UIKit
import SBPickerSelector

class ViewController: UIViewController, SBPickerSelectorDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    @IBAction func showPickerAction(_ sender: UIButton) {
        let picker = SBPickerSelector()
        
        picker.pickerData = ["one","two","three","four","five","six"] //picker content
        picker.delegate = self
//        picker.pickerType = SBPickerSelectorType.text
//        picker.doneButtonTitle = "Done"
//        picker.cancelButtonTitle = "Cancel"
        
        picker.pickerType = SBPickerSelectorType.date //select date(needs implements delegate method with date)
        picker.datePickerType = SBPickerSelectorDateType.onlyMonthAndYear //type of date picker (complete, only day, only hour)
        picker.defaultDate = Date(timeIntervalSinceNow: (60*60*24*30*5))
        picker.minYear = 2015
        picker.maxYear = 2020
        
        picker.showPickerOver(self) //classic picker display
//        picker.showPicker(from: sender, in: self)
    }
    
    func pickerSelector(_ selector: SBPickerSelector, intermediatelySelectedValues values: [String], atIndexes idxs: [NSNumber]) {
        print(values)
    }

}

