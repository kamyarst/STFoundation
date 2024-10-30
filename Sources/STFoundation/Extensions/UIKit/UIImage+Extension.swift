//
//  UIImage+Extension.swift
//
//
//  Created by Kamyar Sehati on 26/02/2024.
//

#if canImport(UIKit)
    import UIKit

    public extension UIImage {
        func resize(width: CGFloat) -> UIImage {
            let scale = width / self.size.width
            let newHeight = self.size.height * scale
            let newSize = CGSize(width: width, height: newHeight)

            let renderer = UIGraphicsImageRenderer(size: newSize)

            let image = renderer.image { _ in
                self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
            }
            return image
        }
    }
#endif
