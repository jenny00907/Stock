//
//  Stock_CalculatorTests.swift
//  Stock-CalculatorTests
//
//  Created by Jenny Lee on 4/16/22.
//

import XCTest
@testable import Stock_Calculator

class Stock_CalculatorTests: XCTestCase {
    
    var sut: DCAService!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = DCAService()
    }

    override func tearDownWithError() throws {
        try super.setUpWithError()
        sut = nil
    }

    func testExample() {
        //given, when, then
        
        
    }
    
    func addition(num1: Int, num2: Int) -> Int {
        return num1 + num2
    }
}
