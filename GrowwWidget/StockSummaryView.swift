//
//  StockSummaryView.swift
//  GrowwWidget
//
//  Created by Vamshi Gone on 1/2/25.
//

// StockSummaryView: A reusable view to display stock details
import SwiftUI

struct StockSummaryView: View {
    let stock: Stock

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Stock: \(stock.symbol)")
                .font(.headline)
            Text("Shares: \(stock.quantity)")
            Text("Purchase Price: ₹\(stock.purchasePrice, specifier: "%.2f")")
            Text("Current Price: ₹\(stock.currentPrice, specifier: "%.2f")")
            Text("Total Purchase Price: ₹\(stock.purchasePrice * Double(stock.quantity), specifier: "%.2f")")
            Text("Total Current Value: ₹\(stock.currentPrice * Double(stock.quantity), specifier: "%.2f")")
            Text("Total Returns: \(formattedReturns(stock))")
                .foregroundColor(stock.currentPrice >= stock.purchasePrice ? .green : .red)
        }
        .padding(.vertical, 5)
    }

    private func formattedReturns(_ stock: Stock) -> String {
        let totalPurchasePrice = stock.purchasePrice * Double(stock.quantity)
        let totalCurrentValue = stock.currentPrice * Double(stock.quantity)
        let profitLoss = totalCurrentValue - totalPurchasePrice
        let percentage = (profitLoss / totalPurchasePrice) * 100
        return String(format: "%@₹%.2f (%.2f%%)", profitLoss >= 0 ? "+" : "-", abs(profitLoss), abs(percentage))
    }
}

#Preview {
    StockSummaryView(stock: Stock(symbol: "TATA", purchasePrice: 120.0, quantity: 10, currentPrice: 130.0))
}
