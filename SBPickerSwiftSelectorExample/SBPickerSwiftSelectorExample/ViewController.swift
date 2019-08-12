//
//  ViewController.swift
//  SBPickerSwiftSelectorExample
//
//  Created by Santiago Bustamante on 1/25/19.
//  Copyright © 2019 Busta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    @IBAction func showPickerAction(_ sender: UIButton) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let date = dateFormatter.date(from: "1989-10")!
        
        
        SBPickerSwiftSelector(mode: SBPickerSwiftSelector.Mode.text, data: ["hi","there", "G", "B"], selectedRow: 2).cancel {
            print("cancel")
            }.set { values in
                if let values = values as? [String] {
                    print(values)
                    sender.setTitle(values[0], for: UIControl.State.normal)
                } else if let values = values as? [Date] {
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YYYY-MM"
                    print(dateFormatter.string(from: values[0]))
                    
                    sender.setTitle(values[0].description(with: Locale.current), for: UIControl.State.normal)
                }
                
        }.present(into: self)
        
    }

}

