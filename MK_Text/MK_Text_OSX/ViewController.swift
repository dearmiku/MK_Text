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
        

        let ml = MK_Label()
        //ml.isAsync = true
        ml.frame = CGRect.init(x: 0, y: 0, width: 100, height: 100)
        let str = NSMutableAttributedString.init(string: "miku")
        str.addAttribute(NSAttributedStringKey.font, value: NSFont.systemFont(ofSize: 20), range: NSRange.init(location: 0, length: str.length))


        let imStr = NSMutableAttributedString.mk_image(im: MK_Image.init(named: NSImage.Name.init("face"))!, size: CGSize.init(width: 30, height: 30), alignType: NSMutableAttributedString.AlignType.top)
        str.append(imStr)



        let tap = NSMutableAttributedString.init(string: "可点击字符")
        let response = MK_TapResponse.init(highlitedBlock: { (str) -> [NSAttributedStringKey : Any]? in
            return [NSAttributedStringKey.foregroundColor : NSColor.red]
        }) { (str, range) in
            print("点击字符串~")
        }
        tap.addTapAttr(response: response, range: nil)
        str.append(tap)



        ml.text = str
        self.view.addSubview(ml)

    }
}

