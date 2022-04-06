//
//  SearchCell.swift
//  Stock-Calculator
//
//  Created by Jenny Lee on 4/5/22.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var assetNameLabel:  UILabel!
    @IBOutlet weak var assetSymbolLabel:  UILabel!
    @IBOutlet weak var assetTypeLabel:  UILabel!
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//    }
    
    func configure(with searchResult: SearchResult) {
        assetNameLabel.text = searchResult.name
        assetSymbolLabel.text = searchResult.symbol
        assetTypeLabel.text = searchResult.type
            .appending(" ")
            .appending(searchResult.currency)
    }
    

}
