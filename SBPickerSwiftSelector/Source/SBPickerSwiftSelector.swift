//
//  SBPickerSwiftSelector.swift
//  SBPickerSwiftSelectorExample
//
//  Created by Santiago Bustamante on 1/25/19.
//  Copyright © 2019 Busta. All rights reserved.
//

import UIKit

public class SBPickerSwiftSelector: UIViewController {
    
    
    public enum Mode {
        case text, dateDefault, dateHour, dateDayMonthYear, dateMonthYear
    }

    @IBOutlet fileprivate weak var stackView: UIStackView!
    @IBOutlet fileprivate weak var toolBar: UIToolbar!
    @IBOutlet public var datePickerView: UIDatePicker!
    @IBOutlet public var pickerView: UIPickerView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    var pickerMode: Mode = .text
    var numberOfComponents = 1
    var data = [Any]()
    
    fileprivate var setAction: ((_ values: [Any])->())?
    fileprivate var cancelAction: (()->())?
    
    fileprivate var monthList = [String]()
    fileprivate var yearList = [String]()
    fileprivate var startDate: Date?
    fileprivate var endDate: Date?
    fileprivate var defaultDate: Date?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        monthList = formatter.monthSymbols
        //repeat the list
        monthList.append(contentsOf: formatter.monthSymbols)
        monthList.append(contentsOf: formatter.monthSymbols)
        monthList.append(contentsOf: formatter.monthSymbols)
        monthList.append(contentsOf: formatter.monthSymbols)
        
        
        //create year list
        var minYear = 1920
        var maxYear = 2050
        
        let calendar = Calendar.current
        if let startDate = startDate {
            minYear = calendar.component(.year, from: startDate)
            datePickerView.minimumDate = startDate
        }
        if let endDate = endDate {
            maxYear = calendar.component(.year, from: endDate)
            datePickerView.maximumDate = endDate
        }
        if let defaultDate = defaultDate {
            datePickerView.setDate(defaultDate, animated: false)
        }
        
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = UIDatePickerStyle.wheels
        }
        
        let yearArr = Array(minYear ... maxYear).map({"\($0)"})
        yearList.append(contentsOf: yearArr)
        yearList.append(contentsOf: yearArr)
        yearList.append(contentsOf: yearArr)
        yearList.append(contentsOf: yearArr)
        yearList.append(contentsOf: yearArr)
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        pickerView.backgroundColor = UIColor.white
        datePickerView.backgroundColor = UIColor.white
        setupPicker()
        
        cancelButton.title = NSLocalizedString("Cancel", comment: "")
        doneButton.title = NSLocalizedString("Set", comment: "")
    }
    
    func setupPicker() {
        switch pickerMode {
        case .text:
            datePickerView.isHidden = true
            pickerView.isHidden = false
        case .dateDefault:
            datePickerView.isHidden = false
            pickerView.isHidden = true
            datePickerView.datePickerMode = UIDatePicker.Mode.dateAndTime
        case .dateHour:
            datePickerView.isHidden = false
            pickerView.isHidden = true
            datePickerView.datePickerMode = UIDatePicker.Mode.time
        case .dateDayMonthYear:
            datePickerView.isHidden = false
            pickerView.isHidden = true
            datePickerView.datePickerMode = UIDatePicker.Mode.date
        case .dateMonthYear:
            datePickerView.isHidden = true
            pickerView.isHidden = false
            numberOfComponents = 2
            setDefaultDateToMonthAndYearPicker()
        }
        
    }
    
    func setDefaultDateToMonthAndYearPicker() {
        var date = Date()
        
        if let defaultDate = defaultDate {
            date = defaultDate
        }
        
        let calendar = Calendar.current
        let formatter = DateFormatter()
        let months = formatter.monthSymbols!
        let monthDefault = calendar.component(.month, from: date)
        let yearDefault = calendar.component(.year, from: date)
        let month = months[monthDefault-1]
        
        let monthIndex = monthList.firstIndex(of: month)! + (months.count*2)
        pickerView.selectRow(monthIndex, inComponent: 0, animated: false)
        
        if yearDefault >= Int(yearList.first!)! && yearDefault <= Int(yearList.last!)! {
            let yearIndex = yearList.firstIndex(of: "\(yearDefault)")! + (yearList.count/5*2)
            pickerView.selectRow(yearIndex, inComponent: 1, animated: false)
        }
        
    }
    
    @IBAction fileprivate func doneAction(_ sender: Any) {
        switch pickerMode {
        case .text:
            var values = [String]()
            if numberOfComponents > 1 {
                for index in 0 ..< numberOfComponents {
                    let row = pickerView.selectedRow(inComponent: index)
                    let arrayComp = data[index] as! [String]
                    values.append(arrayComp[row])
                }
            } else {
                let row = pickerView.selectedRow(inComponent: 0)
                values.append(data[row] as! String)
            }
            setAction?(values)
        
        case .dateDefault, .dateDayMonthYear, .dateHour:
            setAction?([datePickerView.date])
            
        case .dateMonthYear:
            let monthSelectedIndex = pickerView.selectedRow(inComponent: 0)
            let monthSelected = monthList[monthSelectedIndex]
            let yearSelectedIndex = pickerView.selectedRow(inComponent: 1)
            let yearSelected = yearList[yearSelectedIndex]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM"
            let date = dateFormatter.date(from: "\(yearSelected)-\(monthSelected)")!
            setAction?([date])
        }
        
        
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction fileprivate func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    public func set(_ action: @escaping (_ values: [Any])->()) -> SBPickerSwiftSelector {
        setAction = action
        return self
    }
    
    public func cancel(_ action: @escaping ()->()) -> SBPickerSwiftSelector {
        cancelAction = action
        return self
    }
    
    
}

extension SBPickerSwiftSelector: UIPickerViewDataSource, UIPickerViewDelegate {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return numberOfComponents
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerMode == .dateMonthYear {
            if component == 0 {
                return monthList.count
            } else {
                return yearList.count
            }
        }
        
        if numberOfComponents == 1 {
            return data.count
        } else if let arrayComponent = data[component] as? [String] {
            return arrayComponent.count
        } else {
            fatalError("data array is not suitable with the number of components set or the type is not string")
        }
        
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerMode == .dateMonthYear {
            if component == 0 {
                return monthList[row]
            } else {
                return yearList[row]
            }
        }
        
        if numberOfComponents == 1 {
            if let value = data[row] as? String {
            return value
            } else {
                fatalError("value must be string")
            }
        } else if let arrayComponent = data[component] as? [String] {
            return arrayComponent[row]
        } else {
            fatalError("data array is not suitable with the number of components set or the type is not string")
        }
    }
    
}

extension SBPickerSwiftSelector {
    
    public convenience init(mode: Mode, data: [Any]? = nil, startDate: Date? = nil, endDate: Date? = nil, defaultDate: Date? = nil) {
        self.init(nibName: "SBPickerSwiftSelector", bundle: Bundle(for: SBPickerSwiftSelector.self))
        
        self.modalPresentationStyle = .overCurrentContext
        self.pickerMode = mode
        
        if let data = data {
            self.data = data
            if data is [String] {
                self.numberOfComponents = 1
            } else {
                self.numberOfComponents = data.count
            }
        }
        
        self.startDate = startDate
        self.endDate = endDate
        self.defaultDate = defaultDate
    }
    
    public func present(into viewController: UIViewController) {
        self.transitioningDelegate = self
        viewController.present(self, animated: true, completion: nil)
    }
    
    public func present(intoRootViewControllerFrom viewController: UIViewController) {
        self.transitioningDelegate = self
        parentVC(viewController).present(self, animated: true, completion: nil)
    }
    
    // get the most parent view controller to prenset the picker
    private func parentVC(_ viewController: UIViewController) -> UIViewController {
        if let parent = viewController.parent {
            return parentVC(parent)
        } else {
            return viewController
        }
    }
    
}


let inTransition = InAnimator()
let outTransition = OutAnimator()
extension SBPickerSwiftSelector: UIViewControllerTransitioningDelegate {
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return inTransition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return outTransition
    }

}


class InAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
 
        let containerView = transitionContext.containerView
        
        let toView = transitionContext.viewController(forKey: .to)! as! SBPickerSwiftSelector
        let fromView = transitionContext.viewController(forKey: .from)!
        
        toView.view.frame = fromView.view.frame
        containerView.addSubview(toView.view)
        containerView.bringSubviewToFront(toView.view)
        
        toView.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        
        let endFrame = toView.stackView.frame
        var originFrame = toView.stackView.frame
        originFrame.origin.y = toView.view.frame.height
        toView.stackView.frame = originFrame
        
        UIView.animate(withDuration: 0.3, delay:0.0, animations: {
            toView.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            toView.stackView.frame = endFrame
        },completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}

class OutAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        let toView = transitionContext.viewController(forKey: .to)!
        let fromView = transitionContext.viewController(forKey: .from)! as! SBPickerSwiftSelector
        
        containerView.addSubview(fromView.view)
        
        var endFrame = fromView.stackView.frame
        endFrame.origin.y = toView.view.frame.height
        UIView.animate(withDuration: 0.3, delay:0.0, animations: {
            fromView.view.backgroundColor = UIColor.black.withAlphaComponent(0)
            fromView.stackView.frame = endFrame
        },completion: { _ in
            transitionContext.completeTransition(true)
        })
    }
}
