//
//  UIImage+Extensions.swift
//  SuperAwesomeExampleUITests
//
//  Created by Tom O'Rourke on 30/10/2022.
//

import UIKit

extension UIImage {

    func centreCroppedTo(_ size: CGSize) -> UIImage {
        let refWidth: CGFloat = CGFloat(self.cgImage!.width)
        let refHeight: CGFloat = CGFloat(self.cgImage!.height)
        let x = (refWidth - size.width) / 2
        let y = (refHeight - size.height) / 2
        let cropRect = CGRect(x: x, y: y, width: size.width, height: size.height)
        let imageRef = self.cgImage!.cropping(to: cropRect)
        let cropped: UIImage = UIImage(cgImage: imageRef!, scale: 0, orientation: self.imageOrientation)
        return cropped
    }
}
