//
//  StockService.swift
//  GrowwWidget
//
//  Created by Vamshi Gone on 1/1/25.
//

import Foundation

class StockService {
    func fetchPrice(for symbol: String, region: String = "IN") async throws -> Double {
        guard !symbol.isEmpty else { throw NSError(domain: "EmptySymbol", code: 1, userInfo: nil) }
        
        var components = URLComponents(string: "https://yahoo-finance166.p.rapidapi.com/api/stock/get-price")!
        components.queryItems = [
            URLQueryItem(name: "symbol", value: symbol),
            URLQueryItem(name: "region", value: region)
        ]
        
        var request = URLRequest(url: components.url!)
        request.setValue("7731648623mshbff769bcb1bb04dp1137f2jsn7c799acc3773", forHTTPHeaderField: "X-RapidAPI-Key")
        request.setValue("yahoo-finance166.p.rapidapi.com", forHTTPHeaderField: "X-RapidAPI-Host")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decodedResponse = try JSONDecoder().decode(StockPriceResponse.self, from: data)
        
        if let price = decodedResponse.quoteSummary.result.first?.price.regularMarketPrice.raw {
            return price
        } else {
            throw NSError(domain: "NoPriceFound", code: 2, userInfo: nil)
        }
    }
}
