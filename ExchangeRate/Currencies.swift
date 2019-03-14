//
//  File.swift
//  ExchangeRate
//
//  Created by Artem Klimov on 13.03.2019.
//  Copyright © 2019 Artem Klimov. All rights reserved.
//

import Foundation
import RealmSwift


struct Currency: Codable, DataProtocol {
    var currencyName: String
    var currencyRate: Double
    var currencyCode: String
    
    enum CodingKeys: String, CodingKey {
        case currencyName = "txt"
        case currencyRate = "rate"
        case currencyCode = "cc"
    }
}

class Currencies: Object, DataProtocol {
    @objc dynamic var currencyName = ""
    @objc dynamic var currencyRate: Double = 0
    @objc dynamic var currencyCode = ""
    @objc dynamic var isFavorite: Bool = false
    override static func primaryKey() -> String? {
        return "currencyName"
    }
}
