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
        //ml.isAsync = true
        //ml.frame = CGRect.init(x: 100, y: 100, width: 100, height: 100)
        let str = NSMutableAttributedString.init(string: "1234567890")
        str.addAttribute(NSAttributedStringKey.font, value: NSFont.systemFont(ofSize: 36), range: NSRange.init(location: 0, length: str.length))

        //
        //        let imStr = NSMutableAttributedString.mk_image(im: MK_Image.init(named: NSImage.Name.init("face"))!, size: CGSize.init(width: 30, height: 30), alignType: NSMutableAttributedString.AlignType.center)
        //        str.append(imStr)
        //
        //
        //        let v = NSButton.init()
        //        v.frame = NSRect.init(x: 0, y: 0, width: 30, height: 30)
        //        let viewStr = NSMutableAttributedString.mk_view(view: v, superView: ml, size: v.bounds.size ,alignType: NSMutableAttributedString.AlignType.center)
        //        str.append(viewStr)
        //
        //
        //
        //
        //        let tap = NSMutableAttributedString.init(string: "可点击字符")
        //        let response = MK_TapResponse.init(highlite: { (str) -> [NSAttributedStringKey : Any]? in
        //            return [NSAttributedStringKey.foregroundColor : NSColor.red]
        //        }) { (str, range) in
        //            print("点击字符串~")
        //        }
        //        tap.addTapAttr(response: response, range: nil)
        //        str.append(tap)
        //
        //        ml.numberOfLines = 1

        ml.text = str
        ml.isAutoLayoutSize = true
        //ml.layoutMaxHight = 100.0
        
        self.view.addSubview(ml)

        //ml.translatesAutoresizingMaskIntoConstraints = false
        self.view.translatesAutoresizingMaskIntoConstraints = false

//        let wi = NSLayoutConstraint.init(item: ml, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: 100)
//
//        let hi = NSLayoutConstraint.init(item: ml, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1.0, constant: 100)
        let x = NSLayoutConstraint.init(item: ml, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: 100.0)
        let y = NSLayoutConstraint.init(item: ml, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self.view, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: 100.0)

        self.view.addConstraints([x,y])
       // ml.addConstraints([wi,hi])

        //        ml.snp.makeConstraints { (make) in
        //            make.center.equalToSuperview()
        //        }
        
        

    }
}

