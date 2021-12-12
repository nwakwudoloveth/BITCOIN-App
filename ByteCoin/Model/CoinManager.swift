//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//


import UIKit


protocol CoinManagerDelegate{
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
    
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "DE4EAF82-8073-4D9A-990E-1CF173065B0E"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
 
    let imageArray = [#imageLiteral(resourceName: "AUD"),#imageLiteral(resourceName: "BRL"),#imageLiteral(resourceName: "CAD"),#imageLiteral(resourceName: "CNY"),#imageLiteral(resourceName: "EUR"),#imageLiteral(resourceName: "GBP"),#imageLiteral(resourceName: "HKG"),#imageLiteral(resourceName: "IDR"),#imageLiteral(resourceName: "ILS"),#imageLiteral(resourceName: "INR"),#imageLiteral(resourceName: "JPY"),#imageLiteral(resourceName: "MXN"),#imageLiteral(resourceName: "NOR"),#imageLiteral(resourceName: "NZD"),#imageLiteral(resourceName: "PLN"),#imageLiteral(resourceName: "RON"),#imageLiteral(resourceName: "RUB"),#imageLiteral(resourceName: "SEK"),#imageLiteral(resourceName: "SGD"),#imageLiteral(resourceName: "USD"),#imageLiteral(resourceName: "ZAR")]
    
    func getCoinPrice(for currency:String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        print(urlString)
        //performRequest(with: urlString)
        
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    print(error!)
                }
                if let safeData = data {
                    print (safeData)
                    if let coinPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", coinPrice)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                        print(priceString)
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
            
            let ratePrice = decodedData.rate
            return ratePrice
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
    
}
