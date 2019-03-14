//
//  RealmDataBase.swift
//  ExchangeRate
//
//  Created by Artem Klimov on 13.03.2019.
//  Copyright © 2019 Artem Klimov. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDataBase {
    static let shared = RealmDataBase()
    
    var realm = try! Realm()
    var currencies: Results<Currencies> {
        return read(object: Currencies.self)
    }
    
    func create (currency: Currencies) {
        try! realm.write {
            realm.add(currency, update: true)
        }
    }
    
    func read <T: Object> (object: T.Type) -> Results<T> {
        let result = realm.objects(object.self)
        return result
    }
    
    func delete<T: Object>(object: T) {
        try! realm.write {
            realm.delete(object)
        }
    }
    
    func update(with dictionary: [Currency]) {
        for currency in self.currencies {
            if let updater = dictionary.filter({$0.currencyName == currency.currencyName}).first {
                try! realm.write {
                   currency.currencyRate = updater.currencyRate
                }
            }
        }
    }
    
}
