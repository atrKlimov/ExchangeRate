//
//  FavoritesViewController.swift
//  ExchangeRate
//
//  Created by Artem Klimov on 13.03.2019.
//  Copyright © 2019 Artem Klimov. All rights reserved.
//

import UIKit
import RealmSwift

class FavoritesViewController: UIViewController {

    var currencies: Results<Currencies>!
    
    @IBOutlet weak var favoritesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencies = RealmDataBase.shared.read(object: Currencies.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        favoritesTableView.reloadData()
    }
}

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currencies.count != 0 {
            return currencies.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyRateCell", for: indexPath) as! CurrencyRateCell
        let currency = currencies[indexPath.row]
        cell.setDataforCell(currency: currency)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editingRow = currencies[indexPath.row]
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { _,_ in
            RealmDataBase.shared.delete(object: editingRow)
                tableView.reloadData()
        }
        return [deleteAction]
    }
    
    
}
