//
//  Int+Ex.swift
//  Stock-Calculator
//
//  Created by Jenny Lee on 4/12/22.
//

import Foundation


extension Int {
    var asFloat: Float { return Float(self) }
    var asDouble: Double { return Double(self) }
}

extension Double {
    var asString: String { return String(describing: self) }
    
    var toTwoDecimal: String  { return String(format: "%.2f", self)}
    
    var asCurrency: String {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.numberStyle = .currency
    
        return formatter.string(from: self as NSNumber) ?? toTwoDecimal
    }
}
