//
//  ViewController.swift
//  MK_Text_OSX
//
//  Created by MBP on 2018/1/25.
//  Copyright © 2018年 MBP. All rights reserved.
//

import Cocoa
import SnapKit

class ViewController: NSViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let ml = MK_Label()
        ml.isAsync = true

        let str = NSMutableAttributedString.init(string: "1234567890")
        str.addAttribute(NSAttributedStringKey.font, value: NSFont.systemFont(ofSize: 16), range: NSRange.init(location: 0, length: str.length))

        let im = NSImage.init(named: NSImage.Name.init("face"))
        let imStr = NSMutableAttributedString.mk_image(im: im!, size: CGSize.init(width: 30, height: 30), alignType: NSMutableAttributedString.AlignType.center)
        str.insert(imStr, at: 2)


        let v = NSView()
        v.wantsLayer = true
        v.layer?.backgroundColor = CGColor.black
        let vStr = NSMutableAttributedString.mk_view(view: v, superView: ml, size: CGSize.init(width: 30, height: 30))
        str.append(vStr)

        ml.text = str

        self.view.addSubview(ml)
        ml.frame = CGRect.init(x: 100, y: 100, width: 100, height: 100)


//        ml.snp.makeConstraints { (make) in
//            make.center.equalToSuperview()
//        }


    }
}

