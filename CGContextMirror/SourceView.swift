//
//  SourceView.swift
//  CGContextMirror
//
//  Created by Michael on 2020-07-29.
//  Copyright © 2020 Michael. All rights reserved.
//

import Cocoa

class SourceView: NSView {

    var contextTimer: Timer?
    var currentContext : CGContext? {
        get {
            if #available(OSX 10.10, *) {
                return NSGraphicsContext.current?.cgContext
            } else if let contextPointer = NSGraphicsContext.current?.graphicsPort {
                return Unmanaged.fromOpaque(contextPointer).takeUnretainedValue()
            }

            return nil
        }
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {
        wantsLayer = true

        contextTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.needsDisplay = true
        }
    }

    func writePngImageRepresentationToDesktop() {
        var bir = self.bitmapImageRepForCachingDisplay(in: frame)
        bir?.size = CGSize(width: frame.size.width, height: frame.size.height)
        if let bir = bir {
            cacheDisplay(in: bounds, to: bir)
            let imageData = bir.representation(using: .png, properties: [.interlaced: 0])
            do {
                try imageData?.write(to: URL(fileURLWithPath: "/Users/michael/Desktop/view-image-writePngImageRepresentationToDesktop-\(Date().timeIntervalSince1970).png"))
            } catch {
                print("error writing file: \(error)")
            }

        }
    }

    func writePdfImageRepresentationToDesktop() {
        let pdfData = dataWithPDF(inside: frame)
        do {
            try pdfData.write(to: URL(fileURLWithPath: "/Users/michael/Desktop/view-image-writePdfImageRepresentationToDesktop-\(Date().timeIntervalSince1970).pdf"))
        } catch {
            print("pdf write error: \(error)")
        }
    }

    func writeCGImage(_ image: CGImage, to destinationURL: URL) -> Bool {
        guard let destination = CGImageDestinationCreateWithURL(destinationURL as CFURL, kUTTypePNG, 1, nil) else { return false }
        CGImageDestinationAddImage(destination, image, nil)
        return CGImageDestinationFinalize(destination)
    }

    func createCGImage() -> CGImage? {
        var rect = CGRect(x: 0, y:0, width: bounds.size.width, height: bounds.size.height)
        //method 2
        if let pdfRep = NSPDFImageRep(data: dataWithPDF(inside: bounds)) {
            return pdfRep.cgImage(forProposedRect: &rect, context: bitmapContext(), hints: nil)
        }
        return nil
    }

    func bitmapContext() -> NSGraphicsContext? {
        var context : NSGraphicsContext? = nil
        if let imageRep =  NSBitmapImageRep(bitmapDataPlanes: nil,
                                            pixelsWide: Int(bounds.size.width),
                                            pixelsHigh: Int(bounds.size.height), bitsPerSample: 8,
                                            samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
                                            colorSpaceName: NSColorSpaceName.calibratedRGB,
                                            bytesPerRow: Int(bounds.size.width) * 4,
                                            bitsPerPixel: 32) {
            imageRep.size = NSSize(width: bounds.size.width, height: bounds.size.height)
            context = NSGraphicsContext(bitmapImageRep: imageRep)
        }
        return context
    }
}


extension NSView {

    /// Get `NSImage` representation of the view.
    ///
    /// - Returns: `NSImage` of view

    func image() -> NSImage {
        let imageRepresentation = bitmapImageRepForCachingDisplay(in: bounds)!
        cacheDisplay(in: bounds, to: imageRepresentation)

        var doubleSize = bounds.size
        doubleSize.width = bounds.size.width * 2
        doubleSize.height = bounds.size.height * 2
        return NSImage(cgImage: imageRepresentation.cgImage!, size: bounds.size)
    }
}
