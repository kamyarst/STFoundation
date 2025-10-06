//
//  STConstant.swift
//
//
//  Created by Kamyar on 28/01/2023.
//

import SwiftUI

public enum STConstant {
    public enum Margin {
        /// 4
        public static let verySmall: CGFloat = 4
        /// 8
        public static let small: CGFloat = 8
        /// 12
        public static let medium: CGFloat = 12
        /// 16
        public static let standard: CGFloat = 16
        /// 20
        public static let big: CGFloat = 20
        /// 24
        public static let veryBig: CGFloat = 24
    }

    public enum Radius {
        /// 5
        public static let small: CGFloat = 5
        /// 10
        public static let standard: CGFloat = 10
        /// 20
        public static let big: CGFloat = 20
    }

    public enum ControlHeight {
        /// 52
        public static let big: CGFloat = 52
        /// 48
        public static let standard: CGFloat = 48
        /// 44
        public static let small: CGFloat = 44
    }

    /// 24*24
    static let barButtonItem = CGSize(width: 24, height: 24)
    /// 1
    static let minBorderWidth: CGFloat = 1
    /// 2
    static let standardBorderWidth: CGFloat = 2
    /// 3
    static let maxBorderWidth: CGFloat = 3
    #if canImport(UIKit)
        /// screenWidth * 0.8
        @MainActor static let maxButtonWidth: CGFloat = screenWidth * 0.8
        /// screenWidth * 0.65
        @MainActor static let standardButtonWidth: CGFloat = screenWidth * 0.65
        /// screenWidth * 0.5
        @MainActor static let minButtonWidth: CGFloat = screenWidth * 0.5

        /// Screen Width
        @MainActor public static let screenWidth: CGFloat = UIScreen.main.bounds.width
        /// Screen Height
        @MainActor public static let screenHeight: CGFloat = UIScreen.main.bounds.height
    #endif
}
