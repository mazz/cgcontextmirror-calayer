//
//  CALayerExtensions.swift
//  CGContextMirror
//
//  Created by Michael on 2020-08-05.
//  Copyright © 2020 Michael. All rights reserved.
//

import AppKit

extension CALayer {

    /// Get `Data` representation of the layer.
    ///
    /// - Parameters:
    ///   - fileType: The format of file. Defaults to PNG.
    ///   - properties: A dictionary that contains key-value pairs specifying image properties.
    ///   - scalePixels: render as HiDPI by layer contentsScale value
    ///
    /// - Returns: `Data` for image.

    func data(using fileType: NSBitmapImageRep.FileType = .png, properties: [NSBitmapImageRep.PropertyKey : Any] = [:], scalePixels: Bool = false) -> Data? {
        let width = Int(bounds.width * self.contentsScale)
        let height = Int(bounds.height * self.contentsScale)

        var pixelsWide = width
        var pixelsHigh = height
        if scalePixels {
            pixelsWide = width * Int(self.contentsScale)
            pixelsHigh = height * Int(self.contentsScale)
        }

        let imageRepresentation = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: pixelsWide, pixelsHigh: pixelsHigh, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: NSColorSpaceName.deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
        imageRepresentation.size = bounds.size

        if let context = NSGraphicsContext(bitmapImageRep: imageRepresentation) {
            render(in: context.cgContext)
            return imageRepresentation.representation(using: fileType, properties: properties)
        }
        return nil
    }

}
