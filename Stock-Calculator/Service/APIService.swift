//
//  File.swift
//  Stock-Calculator
//
//  Created by Jenny Lee on 4/5/22.
//

import Foundation
import Combine



struct APIService {
    
    var API_KEY: String {
        return keys.randomElement() ?? ""
    }
    
    let keys = ["KQDKDLLHN3GL5WWW", "M2PPS1NQXWSMQ1TD", "JAMPK8F0U35ILFZ"]
    
    func fetchSymbolsPublisher(keywords: String) -> AnyPublisher<SearchResults, Error> {
        let urlString = "https://www.alphavantage.co/query?function=SYMBOL_SEARCH&keywords=\(keywords)&apikey=\(API_KEY)"
        let url = URL(string: urlString)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data })
            .decode(type: SearchResults.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }
}
