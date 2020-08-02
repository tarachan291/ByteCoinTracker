//
//  ViewController.swift
//  ByteCoinTracker
//
//  Created by Taras Hanis on 2020/08/01.
//  Copyright © 2020 Taras Hanis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var coinManeger = CoinManager()
    
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManeger.delegate = self
        // Do any additional setup after loading the view.
    }
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        coinManeger.currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManeger.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManeger.currencyArray[row]
        coinManeger.getCoinPrice(currency: selectedCurrency)
    }
    
}

extension ViewController: CoinManagerDelegate {
    
    func didUpdateCoinPrice(price: String, currency: String) {
        DispatchQueue.main.async {
            self.priceLabel.text = price
            self.currencyLabel.text = currency
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}



