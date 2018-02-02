//
//  ViewController.swift
//  MK_Text_OSX
//
//  Created by MBP on 2018/1/25.
//  Copyright © 2018年 MBP. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //        let point = CGPoint.init(x: 45, y: 3)
        //        let str = NSMutableAttributedString.init(string: "r6t8yadmlhjamnxhwevbdlhsaj2s")
        //        let framesetter = CTFramesetterCreateWithAttributedString(str)
        //        let frame = CTFramesetterCreateFrame(framesetter, CFRange.init(location: 0, length: str.length), CGPath.init(rect: CGRect.init(origin: CGPoint.zero, size: CGSize.init(width: INTPTR_MAX, height: INTPTR_MAX)), transform: nil), nil)
        //        let line = unsafeBitCast(CFArrayGetValueAtIndex(CTFrameGetLines(frame), 0), to: CTLine.self)
        //        let clickPoint = CGPoint.init(x: point.x, y: (str.mk_size.height)*0.5)
        //        let starIndex = CTLineGetStringIndexForPosition(line, clickPoint)
        //        print(starIndex)
        
        let ml = MK_Label()
        ml.frame = CGRect.init(x: 0, y: 0, width: 100, height: 100)
        var str = NSMutableAttributedString.init(string: "a")
        str.addAttribute(NSAttributedStringKey.font, value: NSFont.systemFont(ofSize: 20), range: NSRange.init(location: 0, length: str.length))
        
        let imStr = NSMutableAttributedString.mk_image(im: MK_Image.init(named: NSImage.Name.init("face"))!, size: CGSize.init(width: 30, height: 30), alignType: NSMutableAttributedString.AlignType.top)
        
        
        
        str.append(imStr)
        str.append(NSAttributedString.init(string: "0000009999999"))
        str = str.mk_tap { (str) in
            
        }
        
        ml.text = str
        self.view.addSubview(ml)
        
        
    }
}

