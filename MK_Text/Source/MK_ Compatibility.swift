//
//  MK_ Compatibility.swift
//  MK_Text
//
//  Created by MBP on 2018/1/25.
//  Copyright © 2018年 MBP. All rights reserved.
//


///处理OSX 与 iOS 类兼容 
#if os(macOS)
    import AppKit
    public typealias MK_View = NSView
    public typealias MK_Image = NSImage
    public typealias MK_TapGes = NSClickGestureRecognizer
let MK_Scale = NSScreen.main != nil ? NSScreen.main!.backingScaleFactor : 1.0

#else
    import UIKit
    public typealias MK_View = UIView
    public typealias MK_Image = UIImage
    public typealias MK_TapGes = UITapGestureRecognizer
let MK_Scale = UIScreen.main.scale

#endif


#if os(macOS)
    extension MK_Image {
        var CGImage:CGImage{
            get{
                let source = CGImageSourceCreateWithData(self.tiffRepresentation! as CFData, nil)!
                return CGImageSourceCreateImageAtIndex(source, 0, nil)!
            }
        }
    }


#else
    extension MK_Image {
        var CGImage:CGImage{
            get{
                return self.cgImage!
            }
        }
    }

#endif
