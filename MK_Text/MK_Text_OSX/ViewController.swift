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
        ml.frame = CGRect.init(x: 100, y: 100, width: 100, height: 100)
        let str = NSMutableAttributedString.init(string: "miku")
        str.addAttribute(NSAttributedStringKey.font, value: NSFont.systemFont(ofSize: 30), range: NSRange.init(location: 0, length: str.length))


        let imStr = NSMutableAttributedString.mk_image(im: MK_Image.init(named: NSImage.Name.init("face"))!, size: CGSize.init(width: 30, height: 30), alignType: NSMutableAttributedString.AlignType.center)
        str.append(imStr)


        let v = NSButton.init()
        v.frame = NSRect.init(x: 0, y: 0, width: 30, height: 30)
        let viewStr = NSMutableAttributedString.mk_view(view: v, superView: ml, size: v.bounds.size ,alignType: NSMutableAttributedString.AlignType.center)
        str.append(viewStr)




        let tap = NSMutableAttributedString.init(string: "可点击字符")
        let response = MK_TapResponse.init(highlite: { (str) -> [NSAttributedStringKey : Any]? in
            return [NSAttributedStringKey.foregroundColor : NSColor.red]
        }) { (str, range) in
            print("点击字符串~")
        }
        tap.addTapAttr(response: response, range: nil)
        str.append(tap)

        

        ml.text = str
        self.view.addSubview(ml)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            //ml.text?.mk_setAttrtbute(dic: [NSAttributedStringKey.foregroundColor : NSColor.blue], range: ml.text!.range)
        }

    }
}

