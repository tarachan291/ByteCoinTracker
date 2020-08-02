//
//  CoinManager.swift
//  ByteCoinTracker
//
//  Created by Taras Hanis on 2020/08/01.
//  Copyright © 2020 Taras Hanis. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoinPrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","EUR","GBP","HKD","IDR","INR","JPY","MXN","NZD","PLN","RUB","SGD","USD","ZAR","UAH"]
    
    let mainURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let myAPI = "AC43DA8E-F286-48DF-BBA0-4B00D8157242"
    
    func getCoinPrice(currency: String) {
        
        let urlString = "\(mainURL)/\(currency)?apikey=\(myAPI)"
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        self.delegate?.didUpdateCoinPrice(price: priceString, currency: currency)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            
            return lastPrice
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
}
