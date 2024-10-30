//
//  UIColor.swift
//
//
//  Created by Kamyar on 27/01/2023.
//

#if canImport(UIKit)
    import UIKit

    extension UIColor {

        static func data(_ data: Data) -> UIColor? {

            try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor
        }

        var data: Data? {
            try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
        }
    }
#endif
