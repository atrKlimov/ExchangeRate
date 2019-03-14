//
//  ViewController.swift
//  ExchangeRate
//
//  Created by Artem Klimov on 12.03.2019.
//  Copyright © 2019 Artem Klimov. All rights reserved.
//

import UIKit

import RealmSwift
import Moya

class  CurrenciesViewController: UIViewController {

    let provider = MoyaProvider<NBU>()
    private var datePicker: UIDatePicker?
    
    private var state: State = .loading {
        didSet {
            switch state {
            case .ready:
                activityIndicator.stopAnimating()
                activityIndicator.isHidden = true
                tableView.isHidden = false
                errorLabel.isHidden = true
                self.tableView.reloadData()
                
            case .loading:
                errorLabel.isHidden = true
                tableView.isHidden = true
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
            case .error(let error):
                activityIndicator.stopAnimating()
                activityIndicator.isHidden = true
                tableView.isHidden = true
                errorLabel.isHidden = false
                errorLabel.text = error.localizedDescription
            }
        }
    }
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDatePicker()
        dateField.text = dateFormatter(date: getCurrentDate(), format: "dd / MM / yyyy")
        
        NBU.APIcall(target: .all(date: dateFormatter(date: getCurrentDate(), format: "yyyyMMdd")))
            .done { currency in
                self.state = .ready(currency)
                RealmDataBase.shared.update(with: currency)
            }
            .catch({ error in
                self.state = .error(error)
            })
    }

    private func setUpDatePicker() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.maximumDate = getCurrentDate()
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        dateField.inputView = datePicker
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        state = .loading
        dateField.text = dateFormatter(date: datePicker.date, format: "dd / MM / yyyy")
        NBU.APIcall(target: .all(date: dateFormatter(date: datePicker.date, format: "yyyyMMdd")))
            .done { currency in
                self.state = .ready(currency)
            }
            .catch({ error in
                self.state = .error(error)
            })
        view.endEditing(true) // TODO gestures
    }
    
   
}

extension CurrenciesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard case .ready(let items) = state else { return 0 }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyRateCell", for: indexPath) as! CurrencyRateCell
        guard case .ready(let currencies) = state else { return cell }
        cell.setDataforCell(currency: currencies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editingRow = self.state.get()![indexPath.row]
        
        let element = Currencies()
        let addtoFavorite = UITableViewRowAction(style: .default, title: "Add to Favorites") { _,_ in
            NBU.APIcall(target: .single(currencyCode: editingRow.currencyCode))
                .done { result in
                    if !result.isEmpty {
                        element.currencyCode = result.first!.currencyCode
                        element.currencyName = result.first!.currencyName
                        element.currencyRate = result.first!.currencyRate
                        RealmDataBase.shared.create(currency: element)
                    }
                }
                .catch({ error in
                    self.state = .error(error)
                })
        }
        return [addtoFavorite]
    }
}

extension CurrenciesViewController {
    private enum State {
        case loading
        case ready([Currency])
        case error(Error)
        
        func get() -> [Currency]? {
            switch self {
            case .ready(let currency): return currency
            case .loading: return nil
            case .error: return nil
            }
        }
    }
}

// Date functions
extension CurrenciesViewController {
    func getCurrentDate() -> Date {
        var now = Date()
        var nowComponents = DateComponents()
        let calendar = Calendar.current
        nowComponents.year = Calendar.current.component(.year, from: now)
        nowComponents.month = Calendar.current.component(.month, from: now)
        nowComponents.day = Calendar.current.component(.day, from: now)
        now = calendar.date(from: nowComponents)!
        return now as Date
    }
    
    func dateFormatter(date: Date, format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let formattedDate = dateFormatter.string(from: date)
        return formattedDate
    }
}
