//
//  MonthlyAdjusted.swift
//  Stock-Calculator
//
//  Created by Jenny Lee on 4/10/22.
//

//{
//    "Meta Data": {
//        "1. Information": "Monthly Adjusted Prices and Volumes",
//        "2. Symbol": "IBM",
//        "3. Last Refreshed": "2022-04-08",
//        "4. Time Zone": "US/Eastern"
//    },
//    "Monthly Adjusted Time Series": {
//        "2022-04-08": {
//            "1. open": "129.6600",
//            "2. high": "131.2300",
//            "3. low": "126.7300",
//            "4. close": "127.7300",
//            "5. adjusted close": "127.7300",
//            "6. volume": "20565394",
//            "7. dividend amount": "0.0000"
//        }
//}


import Foundation

struct MonthInfo {
    let date: Date
    let adjustedOpen: Double
    let adjustedClose: Double
}


struct MonthlyAdjusted: Decodable {
    let meta: Meta
    let timeSeries: [String: OHLC]
    
    enum CodingKeys: String, CodingKey {
        case meta = "Meta Data"
        case timeSeries = "Monthly Adjusted Time Series"
    }
    
    func getMonthlyInfo() -> [MonthInfo] {
        var monthInfos: [MonthInfo] = []
        let sorted = timeSeries.sorted(by: { $0.key > $1.key })
        sorted.forEach { (dateString, ohlc) in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.date(from: dateString)!
            let adjustedOpen = getAdjustedOpen(ohlc: ohlc)
            let monthInfo = MonthInfo(date: date, adjustedOpen: adjustedOpen, adjustedClose: Double(ohlc.adjustedClose)!)
            monthInfos.append(monthInfo)
        }
        return monthInfos
    }
    
    private func getAdjustedOpen(ohlc: OHLC) -> Double {
        return Double(ohlc.open)! * (Double(ohlc.adjustedClose)! / Double(ohlc.close)!)
    }
}

struct Meta: Decodable {
    let symbol: String
    enum CodingKeys: String, CodingKey {
        case symbol = "2. Symbol"
    }
}

struct OHLC: Decodable {
    let open: String
    let close: String
    let adjustedClose: String
    
    enum CodingKeys: String, CodingKey {
        case open = "1. open"
        case close = "4. close"
        case adjustedClose = "5. adjusted close"
    }
}

