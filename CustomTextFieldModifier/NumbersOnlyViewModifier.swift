//
//  NumbersOnlyViewModifier.swift
//  CustomTextFieldModifier
//
//  Created by Victor Kilyungi on 05/04/2024.
//

import SwiftUI
import Combine

struct NumbersOnlyViewModifier: ViewModifier {
    @Binding var text: String
    var includeDecimal: Bool
    @Binding var errorMessage: String?
    
    func body(content: Content) -> some View {
        content
            .onReceive(Just(text)) { newValue in
                var numbers = "0123456789"
                let decimalSeparator: String = Locale.current.decimalSeparator ?? "."
                if includeDecimal {
                    numbers += decimalSeparator
                }
                if newValue.components(separatedBy: decimalSeparator).count-1 > 1 {
                    // If there are more than one decimal separator, remove the last one
                    let filtered = newValue
                    self.text = String(filtered.dropLast())
                    self.errorMessage = "Invalid number format"
                } else {
                    // If there's only one or no decimal separator
                    let filtered = newValue.filter { numbers.contains($0)}
                    
                    // If it contains a decimal separator
                    if newValue.contains(decimalSeparator) {
                        // Split the string into integer and fractional parts
                        let parts = newValue.components(separatedBy: decimalSeparator)
                        if parts.count == 2 && parts[1].count > 2 {
                            // If there are more than 2 digits after the decimal separator, truncate it
                            let integerPart = parts[0]
                            let fractionalPart = parts[1].prefix(2)
                            self.text = "\(integerPart)\(decimalSeparator)\(fractionalPart)"
                            return
                        }
                    }
                    if let intValue = Int(filtered), intValue > 250000 {
                        // If the value exceeds the upper bound, set the error message
                        self.errorMessage = "Maximum value is 250000"
                    } else {
                        self.errorMessage = nil
                    }
                    if filtered != newValue {
                        self.text = filtered
                    }
                }
            }
    }
}

extension View {
    func numbersOnly(_ text: Binding<String>, includeDecimal: Bool = false, errorMessage: Binding<String?>) -> some View {
        self.modifier(NumbersOnlyViewModifier(text: text, includeDecimal: includeDecimal, errorMessage: errorMessage))
    }
}
