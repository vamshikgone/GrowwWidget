//
//  StockPriceResponse.swift
//  GrowwWidget
//
//  Created by Vamshi Gone on 12/29/24.
//

struct StockPriceResponse: Codable {
    struct QuoteSummary: Codable {
        struct Result: Codable {
            struct Price: Codable {
                struct RegularMarketPrice: Codable {
                    let raw: Double
                }
                
                let regularMarketPrice: RegularMarketPrice
            }
            
            let price: Price
        }
        
        let result: [Result]
    }
    
    let quoteSummary: QuoteSummary
}


