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
        public static var verySmall: CGFloat = 4
        /// 8
        public static var small: CGFloat = 8
        /// 12
        public static var medium: CGFloat = 12
        /// 16
        public static var standard: CGFloat = 16
        /// 20
        public static var big: CGFloat = 20
        /// 24
        public static var veryBig: CGFloat = 24
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
        /// 48
        public static let big: CGFloat = 48
        /// 44
        public static let standard: CGFloat = 44
        /// 40
        public static let small: CGFloat = 40
    }

    /// screenWidth * 0.8
    static let maxButtonWidth: CGFloat = screenWidth * 0.8
    /// screenWidth * 0.65
    static let standardButtonWidth: CGFloat = screenWidth * 0.65
    /// screenWidth * 0.5
    static let minButtonWidth: CGFloat = screenWidth * 0.5

    /// 24*24
    static let barButtonItem = CGSize(width: 24, height: 24)
    /// 1
    static let minBorderWidth: CGFloat = 1
    /// 2
    static let standardBorderWidth: CGFloat = 2
    /// 3
    static let maxBorderWidth: CGFloat = 3
    /// Screen Width
    static let screenWidth: CGFloat = UIScreen.main.bounds.width
    /// Screen Height
    static let screenHeight: CGFloat = UIScreen.main.bounds.height
    /// Status Bar Size
    static let statusBarSize: CGRect = {
        let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        return window?.windowScene?.statusBarManager?.statusBarFrame
            ?? CGRect(x: 0, y: 0, width: screenWidth, height: 20)
    }()
}
