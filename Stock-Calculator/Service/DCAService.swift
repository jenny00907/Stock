//
//  DCAService.swift
//  Stock-Calculator
//
//  Created by Jenny Lee on 4/14/22.
//

import Foundation
import Combine

struct DCAService {
    func calculateAmount(asset: Asset, initial: Double, monthly: Double, dateIndex: Int) -> DCAResult{
        
        let investment = getInvestment(initial: initial, monthly: monthly, dateIndex: dateIndex)
        let sharePrice = getSharePrice(asset: asset)
        let numberOfShares = getNumberOfShares(asset: asset, initial: initial, monthly: monthly, dateIndex: dateIndex)
        
        
        let current = getCurrent(numberOfShares: numberOfShares, price: sharePrice)
        let isProfitable = current > investment
        
        
        
        return .init(current: current, amount: investment, gain: 0, yield: 0, annualReturn: 0, isProfitable: isProfitable)
    }
    
    private
    func getInvestment(initial: Double, monthly: Double, dateIndex: Int) -> Double {
        var total = Double()
        total += initial
        let average = dateIndex.asDouble * monthly
        total += average
        return total
    }
    
    private
    func getCurrent(numberOfShares: Double, price: Double) -> Double {
        return numberOfShares * price
    }
    
    private
    func getSharePrice(asset: Asset) -> Double {
        return asset.monthlyAdjusted.getMonthlyInfo().first?.adjustedClose ?? 0
    }
    
    private
    func getNumberOfShares(asset: Asset, initial: Double, monthly: Double, dateIndex: Int) ->Double {
        var total = Double()
        let openPrice = asset.monthlyAdjusted.getMonthlyInfo()[dateIndex].adjustedOpen
        
        let shares = initial / openPrice
        total += shares
        asset.monthlyAdjusted.getMonthlyInfo().prefix(dateIndex).forEach { (monthInfo) in
            let dcaShares = monthly / monthInfo.adjustedOpen
            total += dcaShares
        }
        return total
    }
    
}


struct DCAResult {
    let current: Double
    let amount: Double
    let gain: Double
    let yield: Double
    let annualReturn: Double
    let isProfitable: Bool
}
