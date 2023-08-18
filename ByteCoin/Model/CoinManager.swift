  //
  //  CoinManager.swift
  //  ByteCoin
  //
  //  Created by Angela Yu on 11/09/2019.
  //  Copyright © 2019 The App Brewery. All rights reserved.
  //

import Foundation

protocol CoinManagerDelegate {
  func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel)
  func didFailWithError(error: Error)
}

struct CoinManager {
  
  let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
  let apiKey = "D9E34C00-534E-4075-9D22-E902FB99BFAA"
  
  let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
  
  var delegate: CoinManagerDelegate?
  
  func getCoinPrince(for currency: String){
    let urlString = "\(baseURL)/\(currency)?apiKey=\(apiKey)"
    performRequest(with: urlString)
  }
  
  func performRequest(with urlString: String){
    
    if let url = URL(string: urlString){
      
      let session = URLSession(configuration: .default)
      
      let task = session.dataTask(with: url) { data, response, error in
        if error != nil {
          delegate?.didFailWithError(error: error!)
          return
        }
        
        if let safeData = data {
          if let coin = parseJSON(coinData: safeData){
            delegate?.didUpdateCoin(self, coin: coin)
          }
        }
        
      }
      
      task.resume()
      
    }
    
  }
  
  func parseJSON(coinData: Data) -> CoinModel? {
    
    let decoder = JSONDecoder()
    
    do {
      let decodedData = try decoder.decode(CoinData.self, from: coinData)
      let rate = String(format: "%.1f", decodedData.rate)
      let asset_id_quote = decodedData.asset_id_quote
      
      let coin = CoinModel(rate: rate, asset_id_quote: asset_id_quote)
      return coin
      
    } catch {
      delegate?.didFailWithError(error: error)
      return nil
    }
    
    
  }
  

}
