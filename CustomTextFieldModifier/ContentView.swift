//
//  ContentView.swift
//  CustomTextFieldModifier
//
//  Created by Victor Kilyungi on 05/04/2024.
//
import SwiftUI

struct ContentView: View {
    enum FocusedField {
        case int, dec
    }
    
    @State private var intNumberString = ""
    @State private var decNumberString = ""
    @FocusState private var focusedField: FocusedField?
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Section(title: "Integer Number", content: {
                TextField("Enter Integer Number", text: $intNumberString)
                    .focused($focusedField, equals: .int)
                    .numbersOnly($intNumberString, errorMessage: $errorMessage)
            })
            
            Section(title: "Decimal Number", content: {
                TextField("Enter Decimal Number", text: $decNumberString)
                    .focused($focusedField, equals: .dec)
                    .numbersOnly($decNumberString, includeDecimal: true, errorMessage: $errorMessage)
            })
            
            Button(action: {
                submitTextField()
            }) {
                Text("Submit")
            }
            .disabled(errorMessage != nil)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
            
            Spacer()
        }
        .padding()
        .navigationTitle("Numbers Only")
    }
    
    func submitTextField() {
        // Add your submission logic here
        print("Submitting...")
    }
}

struct Section<Content: View>: View {
    let title: String
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            
            content()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
