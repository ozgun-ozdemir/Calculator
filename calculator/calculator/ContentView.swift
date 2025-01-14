//
//  calculatorApp.swift
//  calculator
//
//  Created by Ozgun Umut Ozdemir on 1/14/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var display = "0" // The default display screen
    @State private var currentOperation: String? = nil
    @State private var previousValue: Double? = nil
    @State private var isInCalculationMode = false

    // Define buttons
    let buttons: [[String]] = [
        ["AC", "+/-", "%", "/"],
        ["7", "8", "9", "x"],
        ["4", "5", "6", "-"],
        ["1", "2", "3", "+"],
        ["0", ".", "="]
    ]
    
    var body: some View {
        VStack {
            Spacer()
            // Display Screen
            Text(display)
                .bold()
                .font(.system(size: 72))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
                .padding(.top, 200)
                .foregroundColor(.white)
            
            // Buttons
            ForEach(buttons, id: \.self) { row in
                HStack(spacing: 10) {
                    ForEach(row, id: \.self) { button in
                        if button == "0" {
                            Button(action: {
                                buttonTapped(button)
                            }) {
                                Text(button)
                                    .font(.system(size: 32))
                                    .frame(width: 170, height: 80)
                                    .background(buttonColor(button))
                                    .foregroundColor(.white)
                                    .cornerRadius(40)
                            }
                        } else {
                            Button(action: {
                                buttonTapped(button)
                            }) {
                                Text(button)
                                    .font(.system(size: 32))
                                    .frame(width: 80, height: 80)
                                    .background(buttonColor(button))
                                    .foregroundColor(.white)
                                    .cornerRadius(40)
                            }
                        }
                    }
                }
            }
            Spacer()
        }
        .padding()
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
    
    // Determine the color for the buttons
    private func buttonColor(_ button: String) -> Color {
        switch button {
        case "+", "-", "x", "/", "=":
            return Color.orange
        case "AC", "+/-", "%":
            return Color.gray
        default:
            return Color.gray.opacity(0.5)
        }
    }
    
    private func buttonTapped(_ button: String) {
        switch button {
        case "AC":
            display = "0"
            previousValue = nil
            currentOperation = nil
            isInCalculationMode = false
        case "+/-":
            if let value = Double(display) {
                display = String(value * -1)
            }
        case "%":
            if let previous = previousValue, let current = Double(display), currentOperation == "%" {
                performCalculation()
            }
            currentOperation = "%"
            previousValue = Double(display)
            isInCalculationMode = true
            
        case "0"..."9":
            if isInCalculationMode {
                display = button
                isInCalculationMode = false
            } else {
                if display == "0" {
                    display = button
                } else {
                    display += button
                }
            }
        case ".":
            if !display.contains(".") {
                display += "."
            }
        case "=":
            performCalculation()
        case "+", "-", "x", "/":
            if let previous = previousValue, let current = Double(display), currentOperation != nil {
                performCalculation()
            }
            currentOperation = button
            previousValue = Double(display)
            isInCalculationMode = true
        default:
            break
        }
    }

    private func performCalculation() {
        guard let previous = previousValue, let current = Double(display) else { return }

        var result: Double?

        switch currentOperation {
        case "+":
            result = previous + current
        case "-":
            result = previous - current
        case "x":
            result = previous * current
        case "/":
            result = current != 0 ? previous / current : Double.nan
        case "%":
            result = current != 0 ? previous.truncatingRemainder(dividingBy: current) : Double.nan
        default:
            break
        }

        // Result
        if let result = result {
            display = formatDisplay(result)
        }

        // Reset
        previousValue = nil
        currentOperation = nil
        isInCalculationMode = false
    }

    // Format the result to show integer or decimal
    private func formatDisplay(_ value: Double) -> String {
        if value == floor(value) {
            return String(Int(value))
        } else {
            return String(value)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
