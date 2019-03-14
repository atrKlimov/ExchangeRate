//
//  DataProtocol.swift
//  ExchangeRate
//
//  Created by Artem Klimov on 13.03.2019.
//  Copyright © 2019 Artem Klimov. All rights reserved.
//

import Foundation

protocol DataProtocol {
    var currencyName: String {get}
    var currencyRate: Double {get}
    var currencyCode: String {get}
}
