//
//  ViewController.swift
//  CGContextMirror
//
//  Created by Michael on 2020-07-29.
//  Copyright © 2020 Michael. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var sourceView: SourceView!
    @IBOutlet weak var mirrorView: MirrorView!
    @IBOutlet var textView: NSTextView!

    private var contextLayer: CALayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        contextLayer = CALayer()

        if let logo = contextLayer {
            logo.frame = view.frame

            if let backingImage = NSImage(named: "ExternalDisplayBackground") {
                let cgBacking = backingImage.cgImage(forProposedRect: nil, context: nil, hints: nil)
                logo.contents = cgBacking
                logo.contentsGravity = CALayerContentsGravity.resizeAspectFill

                // show background at load time
                logo.isHidden = false
                sourceView.layer?.addSublayer(logo)
            }
        }

        textView.string = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
    }

    static func saveImageCaLayerData(view: NSView) {
        let pngData = view.layer?.data(using: .png, properties: [:], scalePixels: true)
        do {
            try pngData?.write(to: URL(fileURLWithPath: "/Users/Shared/view-saveImageCaLayerData-\(Date().timeIntervalSince1970).png"))
        } catch {
            print("error: \(error)")
        }
    }

    static func writeCGImage(_ image: CGImage, to destinationURL: URL) -> Bool {
        guard let destination = CGImageDestinationCreateWithURL(destinationURL as CFURL, kUTTypePNG, 1, nil) else { return false }
        CGImageDestinationAddImage(destination, image, nil)
        return CGImageDestinationFinalize(destination)
    }


    override func viewDidAppear() {
        super.viewDidAppear()
        print("source view context: \(String(describing: sourceView.currentContext))")

    }

    @IBAction func saveAsPngFile(_ sender: Any) {
        ViewController.saveImageCaLayerData(view: sourceView)
    }
}
