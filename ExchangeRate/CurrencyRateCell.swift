//
//  CurrencyRateCell.swift
//  ExchangeRate
//
//  Created by Artem Klimov on 13.03.2019.
//  Copyright © 2019 Artem Klimov. All rights reserved.
//

import UIKit

class CurrencyRateCell: UITableViewCell {

    @IBOutlet weak var currencyCode: UILabel!
    @IBOutlet weak var currencyName: UILabel!
    @IBOutlet weak var currencyRate: UILabel!
    
    
    
    
    func setDataforCell(currency: DataProtocol){
        
        currencyCode.text = currency.currencyCode
        currencyName.lineBreakMode = .byWordWrapping

        currencyName.text = currency.currencyName
        currencyRate.text = String(currency.currencyRate)
        
        
    }

}
