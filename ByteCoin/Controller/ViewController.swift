  //
  //  ViewController.swift
  //  ByteCoin
  //
  //  Created by Angela Yu on 11/09/2019.
  //  Copyright © 2019 The App Brewery. All rights reserved.
  //

import UIKit

class ViewController: UIViewController{
  
  @IBOutlet weak var bitcoinLabel: UILabel!
  @IBOutlet weak var currencyLabel: UILabel!
  @IBOutlet weak var currencyPicker: UIPickerView!
  
  var coinManager = CoinManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    coinManager.delegate = self
    currencyPicker.dataSource = self
    currencyPicker.delegate = self
  }
}

  // MARK: - UIPickerView
extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate{
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return coinManager.currencyArray.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return coinManager.currencyArray[row]
  }
  
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let currentCurrency = coinManager.currencyArray[row]
    
    coinManager.getCoinPrince(for: currentCurrency)
  }
}

  // MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate {
  func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel) {
    DispatchQueue.main.async {
      self.bitcoinLabel.text = coin.rate
      self.currencyLabel.text = coin.asset_id_quote
    }
  }
  
  func didFailWithError(error: Error) {
    print(error)
  }
  
  
}
