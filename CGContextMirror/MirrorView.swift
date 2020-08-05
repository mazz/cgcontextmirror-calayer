//
//  MirrorView.swift
//  CGContextMirror
//
//  Created by Michael on 2020-07-29.
//  Copyright © 2020 Michael. All rights reserved.
//

import Cocoa

class MirrorView: NSView {

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
//        contextTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
//            self?.needsDisplay = true
//        }
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
//        print("self.currentContext: \(String(describing: self.currentContext))")

//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mirror_context"), object: self.currentContext)

    }
    
}
