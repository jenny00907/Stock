//
//  CalculatorTableVC.swift
//  Stock-Calculator
//
//  Created by Jenny Lee on 4/10/22.
//

import UIKit


class CalculatorTableVC: UITableViewController {
    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var assetNameLabel: UILabel!
    @IBOutlet var currencyLabels: [UILabel]!
    @IBOutlet weak var currencyAmountLabel: UILabel!
    
    var asset: Asset?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    private
    func setUpViews() {
        symbolLabel.text = asset?.searchResult.symbol
        assetNameLabel.text = asset?.searchResult.name
        currencyAmountLabel.text = asset!.searchResult.currency
        currencyLabels.forEach { (label) in
            let currency = asset!.searchResult.currency
            label.text = currency.addBrackets()
        }
    }
}
