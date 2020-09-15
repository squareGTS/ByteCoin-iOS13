//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "3A8A1B69-50C8-41FA-B4B9-C58E77C3A666"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String) {
        
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        //1. Create URL
        if let url = URL(string: urlString) {
            
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3.Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                                    if let bitcoinPrice = self.parseJSON(safeData) {
                                        let priceString = String(format: "%.2f", bitcoinPrice)
                                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                                    }
                                }
                            }
            
            //4.Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
                   
                   let decoder = JSONDecoder()
                   do {
                    //try to decode the data using the CoinData structure
                       let decodedData = try decoder.decode(CoinData.self, from: data)
                       let lastPrice = decodedData.rate
                    //let base = decodedData.asset_id_base
                       print(lastPrice)
                       return lastPrice
                       
                   } catch {
                       delegate?.didFailWithError(error: error)
                       return nil
                   }
               }
               
           }
