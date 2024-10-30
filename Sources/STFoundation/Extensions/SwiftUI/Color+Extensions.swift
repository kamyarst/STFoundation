//
//  Color+Extensions.swift
//  JointBudget
//
//  Created by Kamyar Sehati on 07/08/2023.
//

import SwiftUI

public extension Color {
    init(hex: String) {
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

    func labelColor() -> Color {
        // Extract RGB components from the background color
        let components = self.cgColor?.components
        let r = components?[0] ?? 0
        let g = components?[1] ?? 0
        let b = components?[2] ?? 0

        // Calculate the relative luminance
        let luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b

        // Determine the color of the label based on the luminance
        return luminance > 0.5 ? .black : .white
    }
}
