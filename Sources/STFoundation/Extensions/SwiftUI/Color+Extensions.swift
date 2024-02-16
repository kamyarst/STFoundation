//
//  Color+Extensions.swift
//  JointBudget
//
//  Created by Kamyar Sehati on 07/08/2023.
//

import SwiftUI

extension Color {
    public init(hex: String) {
        // Remove any leading "#" if present
        var cleanedHex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)

        // If the hex string is shortened (e.g., "#FFF" instead of "#FFFFFF"),
        // expand it to the full format
        if cleanedHex.count == 3 {
            cleanedHex = cleanedHex.map { "\($0)\($0)" }.joined()
        }

        // Ensure the cleaned hex string has 6 characters
        if cleanedHex.count != 6 {
            // You may handle the error here according to your app's requirements
            fatalError("Invalid hex color code. It must be a 6-digit value, e.g., #FF0000.")
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cleanedHex).scanHexInt64(&rgbValue)

        // Extract the individual RGB components from the hexadecimal value
        let red = Double((rgbValue & 0xFF0000) >> 16) / 255.0
        let green = Double((rgbValue & 0x00FF00) >> 8) / 255.0
        let blue = Double(rgbValue & 0x0000FF) / 255.0

        // Initialize the SwiftUI Color with the RGB components
        self.init(red: red, green: green, blue: blue)
    }
}
