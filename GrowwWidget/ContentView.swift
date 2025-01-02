//
//  ContentView.swift
//  GrowwWidget
//
//  Created by Vamshi Gone on 12/28/24.
//
import SwiftUI

private let decimalFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 0
    return formatter
}()

private let integerFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .none
    return formatter
}()

struct ContentView: View {
    @State private var stockSymbol: String = "" // Stock symbol
    @State private var purchasePrice: Double? = nil // Purchase price per stock
    @State private var quantity: Int? = nil // Number of stocks
    @State private var currentPrice: Double? = nil // Current price
    @State private var isLoading: Bool = false // Loading state
    @State private var stocks: [Stock] = [] // List of added stocks
    private let stockService = StockService() // Instance of StockService

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Enter Stock Details")) {
                        TextField("Stock Symbol (e.g., AAPL)", text: $stockSymbol)
                            .textInputAutocapitalization(.characters)
                            .onChange(of: stockSymbol) {
                                stockSymbol = stockSymbol.uppercased()
                            }
                        TextField("Purchase Price", value: $purchasePrice, formatter: decimalFormatter)
                            .keyboardType(.decimalPad)
                        TextField("Quantity", value: $quantity, formatter: integerFormatter)
                            .keyboardType(.numberPad)
                    }
                    
                    // Add Stock button
                    Button(action: {
                        if currentPrice == nil {
                            // Fetch price first, then add stock
                            fetchAndAddStock()
                        } else {
                            // Directly add the stock if price is already fetched
                            addStock()
                        }
                    }) {
                        if isLoading {
                            ProgressView()
                        } else {
                            Text("Add Stock")
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    .disabled(stockSymbol.isEmpty || purchasePrice == nil || quantity == nil)
                }
                // Section for displaying current stock details before adding
                if let purchasePrice = purchasePrice, let quantity = quantity, let currentPrice = currentPrice {
                    Section(header: Text("Summary")) {
                        StockSummaryView(stock: Stock(symbol: stockSymbol, purchasePrice: purchasePrice, quantity: quantity, currentPrice: currentPrice))
                    }
                }

                // Section for displaying the list of added stocks
                Section(header: Text("Stocks List")) {
                    List(stocks) { stock in
                        StockSummaryView(stock: stock)
                    }
                }
            }
            .navigationTitle("Stock Portfolio")
        }
    }

    // Function to add a new stock to the list
    private func addStock() {
        guard let purchasePrice = purchasePrice, let quantity = quantity, let currentPrice = currentPrice else { return }

        let newStock = Stock(symbol: stockSymbol, purchasePrice: purchasePrice, quantity: quantity, currentPrice: currentPrice)
        stocks.append(newStock)

        // Clear the input fields
        stockSymbol = ""
        self.purchasePrice = nil
        self.quantity = nil
        self.currentPrice = nil
    }

    // Function to fetch the current stock price
    private func fetchAndAddStock() {
        isLoading = true
        currentPrice = nil

        Task {
            do {
                // Fetch the price
                let fetchedPrice = try await stockService.fetchPrice(for: stockSymbol)
                DispatchQueue.main.async {
                    self.currentPrice = fetchedPrice
                    self.isLoading = false
                    // Once the price is fetched, add the stock
                    self.addStock()
                }
            } catch {
                print("Error fetching stock price: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
