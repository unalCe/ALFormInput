//
//  ALDatePicker.swift
//  ALFormInput_Example
//
//  Created by AppLogist on 14.04.2020.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import SwiftValidatorNew
import ActionSheetPicker_3_0
import AlExtensions

public protocol ALDatePickerDelegate: class {
    func didSelectDate(_ view: ALDatePicker, selectedDate: Date)
}


public class ALDatePicker: ALValidatableTextField {
    
    weak var datePickerDelegate: ALDatePickerDelegate?
    private var datePickerMode: UIDatePicker.Mode?
    private var minDate: Date?
    private var maxDate: Date?
    private var showFormat: String = "dd/MM/yyyy"
    private var locale: Locale?
    public var selectedDate: Date?
    
    public override init(rules: [Rule], config: ALTextFieldConfig) {
        super.init(rules: rules, config: config)
        delegate = self
        setDropDownIcon()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        delegate = self
        setDropDownIcon()
    }
    
    public func setupPicker(pickerMode: UIDatePicker.Mode? = nil,
                            minDate: Date? = nil,
                            maxDate: Date? = nil,
                            locale: Locale? = Locale.current,
                            dateShowFormat: String = "dd/MM/yyyy") {
        self.datePickerMode = pickerMode
        self.minDate = minDate
        self.maxDate = maxDate
        self.locale = locale
        self.showFormat = dateShowFormat
    }
    
    private func showActionSheetDatePicker() {
        
        let picker = ActionSheetDatePicker(title: title,
                                           datePickerMode: datePickerMode ?? UIDatePicker.Mode.date,
                                           selectedDate: selectedDate ?? Date(),
                                           doneBlock: { (_, selectedDate, _) in
                                            guard let selectedDate = selectedDate as? Date else { return }
                                            self.selectedDate = selectedDate
                                            self.text = selectedDate.formatted(format: self.showFormat)
                                            self.datePickerDelegate?.didSelectDate(self, selectedDate: selectedDate)
        },
                                           cancel: nil,
                                           origin: self)
        if let minDate = self.minDate {
            picker?.minimumDate = minDate
        }
        if let maxDate = self.maxDate {
            picker?.maximumDate = maxDate
        }
        if let locale = self.locale {
            picker?.locale = locale
        }
        picker?.addButtons()
        picker?.show()
    }
    
    
}

// MARK: - UITextFieldDelegate
extension ALDatePicker: UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        showActionSheetDatePicker()
        return false
    }
}
