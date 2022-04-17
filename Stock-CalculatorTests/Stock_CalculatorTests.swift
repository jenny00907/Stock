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

    func testDCA_isUsed_expectResult() {
        
    }
    
    func testDCA_isNotUsed_expectResult() {
        
    }
    
    ///initial amount = $500, DCA: $4 * 300 = 1200, total = 500 + 1200 = 1700
    func testInvestment_DCAisUsed_expectResult() {
        let investment: Double = 500
        let monthlyDCA: Double = 300
        let dateIndex = 4
        
        let investmentAmount = sut.getInvestment(initial: investment, monthly: monthlyDCA, dateIndex: dateIndex)
        
        XCTAssertEqual(investmentAmount, 1700)
        
    }
    
    func testInvestment_DCAisNotUsed_expectResult() {
        let investment: Double = 500
        let monthlyDCA: Double = 0
        let dateIndex = 4 // 5month ago
        
        let investmentAmount = sut.getInvestment(initial: investment, monthly: monthlyDCA, dateIndex: dateIndex)
        
        XCTAssertEqual(investmentAmount, 500)
        
    }
    
    ///test cases(permutations):
    ///1. asset = winning | dca = true -> positive gains
    ///2. asset = winning | dca = false -> positive gains
    ///3. asset = losing | dca = true -> negative gains
    ///4. asset = losing | dca = false -> negative gains
    private
    func buildWinningAsset() -> Asset {
        let searchResult = buildSearchResult()
        let monthlyAdjusted = buildMonthlyAdjusted()
        
        return Asset(searchResult: searchResult, monthlyAdjusted: monthlyAdjusted)
    }
    
    private
    func buildSearchResult() -> SearchResult {
        return SearchResult(symbol: "XYZ", name: "XYZ Company", type: "ETF", currency: "USD")
    }
    
    private
    func buildMonthlyAdjusted() -> MonthlyAdjusted {
        
        let meta = Meta(symbol: "XYZ")
        let timeSeries: [String:OHLC] = ["2021-01-25": OHLC(open: "100", close: "110", adjustedClose: "110"),
                                             "2021-02-25": OHLC(open: "110", close: "120", adjustedClose: "120"),
                                             "2021-03-25": OHLC(open: "120", close: "130", adjustedClose: "130"),
                                             "2021-04-25": OHLC(open: "130", close: "140", adjustedClose: "140"),
                                             "2021-05-25": OHLC(open: "140", close: "150", adjustedClose: "150"),
                                            "2021-06-25": OHLC(open: "150", close: "160", adjustedClose: "160")]

        
        return MonthlyAdjusted(meta: meta, timeSeries: timeSeries)
    }
    
    
    func testResult_firstisUsed_expectPositiveGains() {
        
        let asset = buildWinningAsset()
        let initial: Double = 5000
        let monthly: Double = 1500
        let dateIndex = 5
        
        let result = sut.calculateAmount(asset: asset, initial: initial, monthly: monthly, dateIndex: dateIndex)
        
        XCTAssertEqual(result.amount, 12500)
        XCTAssertTrue(result.isProfitable)
        XCTAssertEqual(result.current, 17342.224, accuracy: 0.1)
        XCTAssertEqual(result.gain, 4842.224, accuracy: 0.1)
        XCTAssertEqual(result.yield, 38.73, accuracy: 0.01)
    }
    
    func testResult_firstisNotUsed_expectPositiveGains() {
        
    }
    
    func testResult_secondisUsed_expectPositiveGains() {
        
    }
    
    func testResult_secondisNotUsed_expectPositiveGains() {
    }
    
    func testResult_thirdisUsed_expectNegativeGains() {
        
    }
    
    func testResult_thirdisNotUsed_expectNegativeGains() {
        
    }
    
    func testResult_fourthisUsed_expectNegativeGains() {
        
    }
    
    func testResult_fourthisNotUsed_expectNegativeGains() {
    }
    
}
