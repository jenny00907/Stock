//
//  Date+Ex.swift
//  Stock-Calculator
//
//  Created by Jenny Lee on 4/12/22.
//

import Foundation


extension Date {
    var MMYYFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: self)
    }
}
