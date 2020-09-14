//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCounBtc(price: String, currency: String)
    func didUpdateCounEth(price: String, currency: String)
    func didWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "9A8E8FEB-2C64-4582-AE4C-9D3A05A50DA6"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    let criptoCurrencyArray = ["BTC", "ETH"]
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String, row: Int) {
        
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        //1. Create URL
        if let url = URL(string: urlString) {
            
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3.Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if  let bitcoinPrice = self.parseJSON(safeData) {
                        
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        
                        if bitcoinPrice > 1000 {
                            self.delegate?.didUpdateCounBtc(price: priceString, currency: currency)
                        } else {
                            self.delegate?.didUpdateCounEth(price: priceString, currency: currency)
                        }
                    }
                }
            }
            //4.Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            
            //try to decode the data using the CoinData structure
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            
            //Get the last property from the decoded data.
            let price = decodedData.rate
            print(price)
            return price
        } catch {
            
            delegate?.didWithError(error: error)
            return nil
        }
    }
}
