//
//  Stock.swift
//  GrowwWidget
//
//  Created by Vamshi Gone on 12/28/24.
//

import Foundation

struct Stock: Identifiable {
    let id = UUID()
    let symbol: String
    let purchasePrice: Double
    let quantity: Int
    let currentPrice: Double
}

