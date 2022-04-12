//
//  TextField+Ex.swift
//  Stock-Calculator
//
//  Created by Jenny Lee on 4/12/22.
//

import UIKit

extension UITextField {
    
    func addDoneButton() {
        let screenWidth = UIScreen.main.bounds.width
        let doneToolBar = UIToolbar(frame: .init(x: 0, y: 0, width: screenWidth, height: 50))
        doneToolBar.barStyle = .default
        let flexBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dissmissKeyboard))
        
        let items = [flexBarButtonItem, doneBarButonItem]
        doneToolBar.items = items
        doneToolBar.sizeToFit()
        inputAccessoryView = doneToolBar
        
    }
    
    @objc private
    func dissmissKeyboard() {
        resignFirstResponder()
    }
}
