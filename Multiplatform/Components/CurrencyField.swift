//
//  CurrencyField.swift
//  TimeLogger
//
//  Created by Samuel Jones on 11/7/24.
//
import SwiftUI

struct CurrencyField: View {
    @Binding var currencyAmount: Double
    @FocusState.Binding var isFocused: Bool
    @State private var currencyString: String = "$0.00"
    let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    var body: some View {
        TextField("Hourly Rate", text: $currencyString)
            .fixedSize()
            .multilineTextAlignment(.center)
            .autocorrectionDisabled()
        #if os(iOS)
            .keyboardType(.numberPad)
        #endif
            .focused($isFocused)
            .onAppear {
                // In case an existing entry is being edited, this will format and display the stored double
                if currencyAmount > 0 {
                    currencyString = currencyFormatter.string(from: NSNumber(value: currencyAmount)) ?? "$0.00"
                }
            }
            .onChange(of: currencyString) { _, newValue in
                let filteredString = newValue.filter { ("0"..."9").contains($0) }

                // This allows the user to enter a sequence of digits with a constantly placed decimal point
                if let number = Double(filteredString) {
                    let dividedBy100 = number / 100
                    currencyAmount = dividedBy100
                    currencyString = currencyFormatter.string(from: NSNumber(value: dividedBy100)) ?? ""
                } else {
                    currencyString = "0.00"
                }
            }
    }
}
