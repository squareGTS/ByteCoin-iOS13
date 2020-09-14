//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    @IBOutlet weak var ethLabel: UILabel!
    @IBOutlet weak var currencyEthLabel: UILabel!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        coinManager.delegate = self
        currencyPicker.dataSource = self // ViewController class is the datasource to the currencyPicker object
        currencyPicker.delegate = self
    }
}

//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
    
    func didUpdateCounBtc(price: String, currency: String) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = price
            self.currencyLabel.text = currency
        }
    }
    
    func didUpdateCounEth(price: String, currency: String) {
        DispatchQueue.main.async {
            self.ethLabel.text = price
            self.currencyEthLabel.text = currency
        }
    }
    
    func didWithError(error: Error) {
        print(error)
    }
}

//MARK: - UIPickerView DataSource & Delegate

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // how many columns in picker
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count // how many rows in picker
    }
    
    //use the row (Int) to pick the title from our currencyArray
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    //called every time when the user scrolls the picker
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        
        if self.bitcoinLabel != nil {
            let selectedCriptoCurency = 0
            coinManager.getCoinPrice(for: selectedCurrency, row: selectedCriptoCurency)
        }
        
        if self.ethLabel != nil {
            let selectedCriptoCurency = 1
            coinManager.getCoinPrice(for: selectedCurrency, row: selectedCriptoCurency)
        }
        
    }
}
